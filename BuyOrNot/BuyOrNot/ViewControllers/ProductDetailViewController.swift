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
    private var youtubeReviews = [ReviewContent]()
    private var naverBlogReviews = [ReviewContent]()
    private var tistoryBlogReviews = [ReviewContent]()

    private var didFetchingDone: Bool {
        return !youtubeReviews.isEmpty && !naverBlogReviews.isEmpty && !youtubeReviews.isEmpty
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
        fetchYoutubeReviews()
        fetchNaverBlogReviews()
        fetchTistoryBlogReviews()
    }

    required init?(coder: NSCoder) {
        product = Product(category: .phone, brand: "", name: "", rank: nil, image: nil)
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

    private func setNaverShoppingThumnail() {
        NaverSearchAPIClient.shared
            .fetchNaverShoppingResults(query: product.name) { (response: DataResponse<NaverShoppingResult, AFError>) in
                do {
                    if let data = response.data {
                        let shoppingItem = try JSONDecoder().decode(NaverShoppingResult.self, from: data)
                        let imageURL = try shoppingItem.items[0].image.asURL()
                        self.productImageView.kf.setImage(with: imageURL, options: [.loadDiskFileSynchronously])
                    }
                } catch {
                    self.productImageView.image = UIImage(named: "errorImage")
                }
            }
    }

    private func fetchYoutubeReviews() {
        YoutubeAPIClient.shared
            .fetchYoutubeVideos(query: product.name + "리뷰", count: 20) { (response: DataResponse<YoutubeSearchResult, AFError>) in
            do {
                if let data = response.data {
                    let youtubeResult = try JSONDecoder().decode(YoutubeSearchResult.self, from: data)
                    let items = youtubeResult.items

                    items.forEach { item in
                        let thumbnailURL = URL(string: item.snippet.thumbnails.high.url)
                        self.youtubeReviews.append(ReviewContent(siteKind: .youtube, title: item.snippet.title,
                                                                 producerName: item.snippet.channelTitle,
                                                                 thumbnail: thumbnailURL))
                    }
                    if self.didFetchingDone { self.reviewCollectionView.reloadData() }
                }
            } catch {
                if self.didFetchingDone {
                    self.presentErrorAlert()
                }
            }
        }
    }

    private func fetchNaverBlogReviews() {
        NaverSearchAPIClient.shared
            .fetchNaverBlogResults(query: product.name, count: 20) { (response: DataResponse<NaverBlogResult, AFError>) in
            do {
                if let data = response.data {
                    let naverResult = try JSONDecoder().decode(NaverBlogResult.self, from: data)
                    let items = naverResult.items

                    items.forEach { item in
                        self.naverBlogReviews.append(ReviewContent(siteKind: .naver, title: item.title,
                                                                   producerName: item.bloggerName,
                                                                   thumbnail: nil))
                    }
                    if self.didFetchingDone { self.reviewCollectionView.reloadData() }
                }
            } catch {
                if self.didFetchingDone {
                    self.presentErrorAlert()
                }
            }
        }
    }

    private func fetchTistoryBlogReviews() {
        KakaoAPIClient.shared
            .fetchKakaoBlogPosts(query: product.name, count: 20) { (response: DataResponse<KakaoBlogResult, AFError>) in
            do {
                if let data = response.data {
                    let kakaoResult = try JSONDecoder().decode(KakaoBlogResult.self, from: data)
                    let items = kakaoResult.documents

                    items.forEach { item in
                        let thumbnailURL = URL(string: item.thumbnail)
                        self.tistoryBlogReviews.append(ReviewContent(siteKind: .tistory, title: item.title,
                                                                     producerName: item.blogName,
                                                                     thumbnail: thumbnailURL))
                    }
                    if self.didFetchingDone { self.reviewCollectionView.reloadData() }
                }
                self.reviewCollectionView.reloadData()
            } catch {
                if self.didFetchingDone {
                    self.presentErrorAlert()
                }
            }
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

    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "에러가 발생했어요 😫", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
    }

    @objc private func popView(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youtubeReviews.count + naverBlogReviews.count + tistoryBlogReviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
                                     for: indexPath) as? ReviewCollectionViewCell else { return UICollectionViewCell() }
        if !didFetchingDone { return cell }

        var content = ReviewContent(siteKind: .youtube, title: "", producerName: "", thumbnail: nil)

        if indexPath.row % 3 == 0 {
            content = youtubeReviews[indexPath.row / 3]
        } else if indexPath.row % 3 == 1 {
            content = naverBlogReviews[indexPath.row / 3]
        } else if indexPath.row % 3 == 2 {
            content = tistoryBlogReviews[indexPath.row / 3]
        }

        cell.setContents(content: content)
        return cell
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ReviewCollectionViewCell else { return }
        // TODO: 링크로 이동
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
