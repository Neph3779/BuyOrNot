//
//  ProductDetailViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit
import SnapKit
import Kingfisher

final class ProductDetailViewController: UIViewController {
    private let productImageView = UIImageView()
    private let reviewContentView = UIView()
    private let productNameLabel = UILabel()
    private let productBrandLabel = UILabel()
    private let reviewCollectionView = UICollectionView(frame: .zero,
                                                        collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.backgroundColor
        setProductImageView()
        setReviewContentView()
        setReviewCollectionView()
    }

    func setProduct(product: Product) {
        productImageView.kf.setImage(with: product.image, options: [.loadDiskFileSynchronously])
        productNameLabel.text = product.name
        productBrandLabel.text = product.brand
    }

    private func setProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.backgroundColor = ColorSet.backgroundColor
        productImageView.image = UIImage(named: "phoneCategoryImage")
        let height = ViewSize.viewHeight * 0.4 // makeConstraint 내부에서 계산시 오류 발생해서 밖으로 빼낸 것
        view.addSubview(productImageView)
        productImageView.snp.makeConstraints { imageView in
            imageView.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            imageView.height.equalTo(height)
        }
    }

    private func setReviewContentView() {
        reviewContentView.backgroundColor = .white
        reviewContentView.alpha = 0.7
        reviewContentView.layer.cornerRadius = 5
        reviewContentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(reviewContentView)
        reviewContentView.snp.makeConstraints { contentView in
            contentView.top.equalTo(productImageView.snp.bottom).inset(100)
            contentView.leading.trailing.equalTo(view).inset(10)
            contentView.bottom.equalTo(productImageView.snp.bottom)
        }

        setProductBrandLabel()
        setProductNameLabel()
    }

    private func setProductBrandLabel() {
        productBrandLabel.text = "Apple"
        reviewContentView.addSubview(productBrandLabel)

        productBrandLabel.snp.makeConstraints { label in
            label.leading.top.equalTo(reviewContentView).inset(10)
        }
    }

    private func setProductNameLabel() {
        productNameLabel.text = "iPhone 13 Pro Max"
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        reviewContentView.addSubview(productNameLabel)

        productNameLabel.snp.makeConstraints { label in
            label.top.equalTo(productBrandLabel.snp.bottom).offset(5)
            label.leading.equalTo(reviewContentView).inset(10)
        }
    }

    private func setReviewCollectionView() {
        reviewCollectionView.register(ReviewCollectionViewCell.self,
                                      forCellWithReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier)
        reviewCollectionView.dataSource = self
        reviewCollectionView.delegate = self
        reviewCollectionView.layer.cornerRadius = 5
        reviewCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        reviewCollectionView.backgroundColor = .white

        view.addSubview(reviewCollectionView)
        reviewCollectionView.snp.makeConstraints { collectionView in
            collectionView.top.equalTo(productImageView.snp.bottom)
            collectionView.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            collectionView.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 10 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.reuseIdentifier,
                                                  for: indexPath)
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {

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
