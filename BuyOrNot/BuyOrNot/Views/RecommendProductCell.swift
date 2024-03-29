//
//  RecommendProductCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/25.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class RecommendProductCell: TapReactCollectionViewCell {
    static let reuseIdentifier = "recommendProductCell"

    private(set) var product: Product?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()

    private let productImageView = UIImageView()
    private let brandNameLabel = UILabel()
    private let titleLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackView()
        setUpProductImageView()
        setUpBrandNameLabel()
        setUpTitleLabel()
        setCellAppearance()
        setUpLoadingIndicator()
        addSelectMaskToContentView(cornerRadius: 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        contentView.backgroundColor = .white
        stackView.isHidden = false
        loadingIndicator.stopAnimating()
    }

    func setUpContents(product: Product) {
        self.product = product
        if let url = product.image,
           let image = URL(string: url) {
            productImageView.kf.setImage(with: image, options: [.loadDiskFileSynchronously])
        } else {
            productImageView.image = UIImage(named: "errorImage")
        }
        brandNameLabel.text = product.brand
        titleLabel.text = product.name
    }

    func showLoadingIndicator() {
        contentView.backgroundColor = ColorSet.backgroundColor
        stackView.isHidden = true
        loadingIndicator.startAnimating()
    }

    private func setUpStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { stackView in
            stackView.edges.equalTo(contentView).inset(5)
        }
    }

    private func setUpProductImageView() {
        productImageView.image = UIImage(named: "phoneCategoryImage")
        productImageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(productImageView)
        productImageView.snp.makeConstraints { imageView in
            imageView.width.height.equalTo(stackView.snp.width).multipliedBy(0.75)
        }
    }

    private func setUpBrandNameLabel() {
        brandNameLabel.text = "브랜드명"
        brandNameLabel.textAlignment = .center
        brandNameLabel.textColor = .lightGray
        stackView.addArrangedSubview(brandNameLabel)
    }

    private func setUpTitleLabel() {
        titleLabel.text = "제품명"
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
    }

    private func setUpLoadingIndicator() {
        contentView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { indicator in
            indicator.center.equalToSuperview()
        }
    }

    private func setCellAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 10
        layer.masksToBounds = true

//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        layer.shadowRadius = 2.0
//        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
