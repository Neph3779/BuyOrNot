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
    private var joinedReview = [ReviewContent]()
    private var reviewFetcher: ReviewFetcher?
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
    private let loadingIndicator = UIActivityIndicatorView()

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        reviewFetcher = ReviewFetcher(product: product, delegate: self)
        productNameLabel.text = product.name
        productBrandLabel.text = product.brand
        setNaverShoppingThumnail()
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
        setLoadingIndicator()
        reviewFetcher?.fetchReviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        Alamofire.Session.default.session.getTasksWithCompletionHandler({ dataTasks, _, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        })
    }

    private func setNaverShoppingThumnail() {
        NaverSearchAPIClient.shared
            .fetchNaverShoppingResults(query: "\(product.brand) \(product.name)") { [weak self]
                (response: DataResponse<NaverShoppingResult, AFError>) in
                guard let self = self else { return }
                do {
                    guard let data = response.data else {
                        self.productImageView.image = UIImage(named: "errorImage")
                        return
                    }
                    let naverShoppingResult = try JSONDecoder().decode(NaverShoppingResult.self, from: data)
                    if naverShoppingResult.items.isEmpty {
                        self.productImageView.image = UIImage(named: "errorImage")
                    } else {
                        let shoppingItem = naverShoppingResult
                        let imageURL = try shoppingItem.items.first?.image.asURL()
                        self.productImageView.kf.setImage(with: imageURL, options: [.loadDiskFileSynchronously])
                    }
                } catch {
                    self.productImageView.image = UIImage(named: "errorImage")
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
        productNameLabel.numberOfLines = 2
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

    private func setLoadingIndicator() {
        loadingIndicator.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        reviewCollectionView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { indicator in
            indicator.center.equalTo(reviewCollectionView.snp.center)
        }
        loadingIndicator.startAnimating()
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
        if joinedReview.isEmpty { return cell }

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

extension ProductDetailViewController: ReviewFetcherDelegate {
    func setJoinedReview(reviewContents: [ReviewContent]) {
        self.joinedReview = reviewContents
    }

    func reloadData() {
        reviewCollectionView.reloadData()
        loadingIndicator.stopAnimating()
    }
}
