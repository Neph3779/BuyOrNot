//
//  ProductDetailViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

final class ProductDetailViewController: UIViewController {
    private var product: Product
    private var youtubeResults = [YoutubeVideosResult]()
    private var naverResults: NaverBlogResult?
    private var tistoryResults: KakaoBlogResult?
    private var joinedReview = [ReviewContent]() // TODO: review 가져오는 로직 객체로 분리할 수 있을듯

    private var didYoutubeFetchingDone = false
    private var didNaverFetchingDone = false
    private var didTistoryFetchingDone = false

    private var didFetchingDone: Bool {
        return didYoutubeFetchingDone && didNaverFetchingDone && didTistoryFetchingDone
    }
    private let productImageView = UIImageView()
    private let reviewContentView = UIView()
    private let productLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    private let productNameLabel = UILabel()
    private let productBrandLabel = UILabel()
    private let reviewCollectionView = UICollectionView(frame: .zero,
                                                        collectionViewLayout: UICollectionViewFlowLayout())
    private let backButtonImageView = UIImageView()

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        productNameLabel.text = product.name
        productBrandLabel.text = product.brand
        setNaverShoppingThumnail()
        fetchYoutubeVideoIds()
        fetchNaverBlogReviews()
        fetchTistoryBlogReviews()
    }

    required init?(coder: NSCoder) {
        product = Product(category: "", brand: "", name: "", rank: nil, image: nil)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setProductImageView()
        setReviewContentView()
        setReviewCollectionView()
        setbackButtonImageView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    private func setNaverShoppingThumnail() {
        NaverSearchAPIClient.shared
            .fetchNaverShoppingResults(query: "\(product.brand) \(product.name)") { [weak self]
                (response: DataResponse<NaverShoppingResult, AFError>) in
                guard let self = self else { return }
                do {
                    let naverShoppingResult = try JSONDecoder().decode(NaverShoppingResult.self, from: response.data!)
                    if naverShoppingResult.items.isEmpty {
                        self.productImageView.image = UIImage(named: "errorImage")
                    } else {
                        let shoppingItem = naverShoppingResult
                        let imageURL = try shoppingItem.items[0].image.asURL()
                        self.productImageView.kf.setImage(with: imageURL, options: [.loadDiskFileSynchronously])
                    }
                } catch {
                    self.productImageView.image = UIImage(named: "errorImage")
                }
            }
    }

    private func fetchYoutubeVideoIds() {
        YoutubeCrawler.shared.fetchYoutubeReviews(query: "\(product.brand) \(product.name) 리뷰",
                                                  completion: youtubeVideoIdFetchCompletion(contents:))

    }

    private func youtubeVideoIdFetchCompletion(contents: [YoutubeCrawlingResult.VideoContent]?) {
        var videoIds = [String?]()
        guard let contents = contents else { return }
        contents.forEach { videoIds.append($0.videoRenderer?.videoId) }
        let videoIdsWithoutNil = videoIds.compactMap { $0 }

        for index in 0 ..< videoIdsWithoutNil.count {
            YoutubeAPIClient.shared.fetchYoutubeVideoById(videoId: videoIdsWithoutNil[index]) { [weak self]
                (response: DataResponse<YoutubeVideosResult, AFError>) in
                guard let self = self else { return }
                do {
                    let result = try JSONDecoder().decode(YoutubeVideosResult.self, from: response.data!)
                    self.youtubeResults.append(result)
                } catch {

                }
                if index == videoIdsWithoutNil.count - 1 {
                    self.didYoutubeFetchingDone = true
                    if self.didFetchingDone {
                        self.joinReviews()
                        self.reviewCollectionView.reloadData()
                    }
                }
            }
        }
    }

    private func fetchNaverBlogReviews() {
        NaverSearchAPIClient.shared
            .fetchNaverBlogResults(query: "\(product.brand) \(product.name) 리뷰", count: 20) { [weak self]
                (response: DataResponse<NaverBlogResult, AFError>) in
                guard let self = self else { return }
                do {
                    self.naverResults = try JSONDecoder().decode(NaverBlogResult.self, from: response.data!)
                } catch {
                    self.presentErrorAlert(title: "네이버 블로그 데이터 전송 실패",
                                           message: "네이버 블로그 데이터를 받아오는데 실패했어요 😫\n 잠시 뒤에 다시 시도해주세요")
                }
                self.didNaverFetchingDone = true
                if self.didFetchingDone {
                    self.joinReviews()
                    self.reviewCollectionView.reloadData()
                }
            }
    }

    private func fetchTistoryBlogReviews() {
        KakaoAPIClient.shared
            .fetchKakaoBlogPosts(query: "\(product.brand) \(product.name) 리뷰", count: 20) { [weak self]
                (response: DataResponse<KakaoBlogResult, AFError>) in
                guard let self = self else { return }
                do {
                    self.tistoryResults = try JSONDecoder().decode(KakaoBlogResult.self, from: response.data!)
                } catch {
                    self.presentErrorAlert(title: "티스토리 블로그 데이터 전송 실패",
                                           message: "티스토리 데이터를 받아오는데 실패했어요 😫\n 잠시 뒤에 다시 시도해주세요")
                }
                self.didTistoryFetchingDone = true
                if self.didFetchingDone {
                    self.joinReviews()
                    self.reviewCollectionView.reloadData()
                }
            }
    }

    private func joinReviews() {
        let youtubeReviews: [ReviewContent]? = youtubeResults.map { result in
            let item = result.items[0]
            let thumbnailURL = URL(string: item.snippet.thumbnails.high.url)
            let link = URL(string: "https://www.youtube.com/watch?v=" + item.id)

            return ReviewContent(siteKind: .youtube, title: item.snippet.title,
                                 producerName: item.snippet.channelTitle,
                                 thumbnail: thumbnailURL, link: link, youtubeId: item.id)
        }

        let tistoryReviews: [ReviewContent]? = tistoryResults?.documents.map { item -> ReviewContent in
            let siteKind: ReviewSiteKind = item.link.contains("naver") ? .naver : .tistory
            let thumbnailURL = URL(string: item.thumbnail)
            let link = URL(string: item.link)
            return ReviewContent(siteKind: siteKind, title: item.title,
                                 producerName: item.blogName,
                                 thumbnail: thumbnailURL, link: link, youtubeId: nil)
        }

        let naverReviews: [ReviewContent]? = naverResults?.items.map { item -> ReviewContent? in
            let link = URL(string: item.link)
            if let tistoryReviews = tistoryReviews {
                if tistoryReviews.filter({ $0.producerName == item.bloggerName }).isEmpty {
                    return ReviewContent(siteKind: .naver, title: item.title,
                                         producerName: item.bloggerName,
                                         thumbnail: nil, link: link, youtubeId: nil)
                }
            }
            return nil
        }.compactMap { $0 }

        var count = 0

        while count < youtubeReviews?.count ?? 0 || count < naverReviews?.count ?? 0 || count < tistoryReviews?.count ?? 0 {
            if count < youtubeReviews?.count ?? 0 {
                joinedReview.append(youtubeReviews![count])
            }

            if count < tistoryReviews?.count ?? 0 {
                joinedReview.append(tistoryReviews![count])
            }

            if count < naverReviews?.count ?? 0 {
                joinedReview.append(naverReviews![count])
            }

            count += 1
        }
    }

    private func setProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        productImageView.backgroundColor = .white
        let height = ViewSize.viewHeight * 0.4 // makeConstraint 내부에서 계산시 오류 발생해서 밖으로 빼낸 것
        view.addSubview(productImageView)
        productImageView.snp.makeConstraints { imageView in
            imageView.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            imageView.height.equalTo(height)
        }
    }

    private func setReviewContentView() {
        reviewContentView.backgroundColor = ColorSet.backgroundColor
        reviewContentView.alpha = 0.85
        view.addSubview(reviewContentView)
        reviewContentView.snp.makeConstraints { contentView in
            contentView.top.equalTo(productImageView.snp.bottom).inset(80)
            contentView.leading.trailing.equalTo(view)
            contentView.bottom.equalTo(productImageView.snp.bottom)
        }
        setProductLabelStackView()
        setProductBrandLabel()
        setProductNameLabel()
    }

    private func setProductLabelStackView() {
        productLabelStackView.axis = .vertical
        productLabelStackView.distribution = .equalSpacing
        productLabelStackView.spacing = 0
        reviewContentView.addSubview(productLabelStackView)
        productLabelStackView.snp.makeConstraints { stackView in
            stackView.centerY.equalTo(reviewContentView)
            stackView.leading.trailing.equalTo(reviewContentView).inset(10)
        }
    }

    private func setProductBrandLabel() {
        productBrandLabel.text = product.brand
        productBrandLabel.textColor = .black
        productBrandLabel.font = UIFont.systemFont(ofSize: 16)
        reviewContentView.addSubview(productBrandLabel)

        productLabelStackView.addArrangedSubview(productBrandLabel)
    }

    private func setProductNameLabel() {
        productNameLabel.text = product.name
        productNameLabel.textColor = .black
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        reviewContentView.addSubview(productNameLabel)

        productLabelStackView.addArrangedSubview(productNameLabel)
    }

    private func setReviewCollectionView() {
        reviewCollectionView.register(ReviewCollectionViewCell.self,
                                      forCellWithReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier)
        reviewCollectionView.dataSource = self
        reviewCollectionView.delegate = self
        reviewCollectionView.layer.cornerRadius = 5
        reviewCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        reviewCollectionView.backgroundColor = ColorSet.backgroundColor

        view.addSubview(reviewCollectionView)
        reviewCollectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(productImageView.snp.bottom)
            collectionView.leading.trailing.equalTo(view)
            collectionView.bottom.equalTo(view)
        }
    }

    private func setbackButtonImageView() {
        backButtonImageView.image = UIImage(named: "arrow.backward")
        backButtonImageView.tintColor = .darkGray
        backButtonImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(popView(_:)))
        backButtonImageView.addGestureRecognizer(gesture)
        view.addSubview(backButtonImageView)
        backButtonImageView.snp.makeConstraints { imageView in
            imageView.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.width.height.equalTo(30)
        }
    }

    @objc private func popView(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return joinedReview.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
                                     for: indexPath) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        if !didFetchingDone { return cell }

        cell.setContents(content: joinedReview[indexPath.row])
        return cell
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReviewCollectionViewCell,
              let content = cell.reviewContent else { return }

        if let youtubeId = content.youtubeId,
           let youtubeURL = URL(string: "youtube://" + youtubeId),
           UIApplication.shared.canOpenURL(youtubeURL) {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let link = content.link {
            UIApplication.shared.open(link)
        } else {
            presentErrorAlert(title: "Error", message: "링크를 여는데 실패했어요 😫")
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width

        return CGSize(width: collectionViewWidth - 20, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
