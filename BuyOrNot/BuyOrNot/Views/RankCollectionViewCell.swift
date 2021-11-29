//
//  RankTableViewCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit
import Kingfisher

final class RankCollectionViewCell: UICollectionViewCell {
    static let reuseidentifier = "rankTableViewCell"
    var product: Product?
    private let productImageView = UIImageView()
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let brandLabel = UILabel()
    private let rankBadge: UIView? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        setProductImageView()
        setLabelStackView()
        setTitleLabel()
        setBrandLabel()
        setCellAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setContents(product: Product) {
        self.product = product
        productImageView.kf.setImage(with: product.image, options: [.loadDiskFileSynchronously])
        titleLabel.text = product.name
        brandLabel.text = product.brand
    }

    private func setProductImageView() {
        productImageView.image = UIImage(named: "phoneCategoryImage")
        productImageView.contentMode = .scaleAspectFit
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints { imageView in
            imageView.leading.top.equalTo(contentView).inset(10)
            imageView.width.height.equalTo(contentView.snp.height).multipliedBy(0.8)
        }
    }

    private func setLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = 5
        contentView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { stackView in
            stackView.leading.equalTo(productImageView.snp.trailing).offset(10)
            stackView.top.bottom.equalTo(contentView).inset(20)
            stackView.trailing.equalTo(contentView).inset(10)
        }
    }

    private func setTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 18)

        labelStackView.addArrangedSubview(titleLabel)
    }

    private func setBrandLabel() {
        brandLabel.textColor = .lightGray
        brandLabel.numberOfLines = 1
        brandLabel.font = UIFont.systemFont(ofSize: 14)
        labelStackView.addArrangedSubview(brandLabel)
    }

    private func setCellAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 10
        layer.masksToBounds = true

//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        layer.shadowRadius = 2.0
//        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
