//
//  RankTableViewCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit

final class RankCollectionViewCell: UICollectionViewCell {
    static let reuseidentifier = "rankTableViewCell"

    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let brankLabel = UILabel()
    private let rankBadge: UIView? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        setProductImageView()
        setTitleLabel()
        setBrandLabel()
        setCellAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

    private func setTitleLabel() {
        titleLabel.text = "Title"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { label in
            label.leading.equalTo(productImageView.snp.trailing).offset(10)
            label.top.equalTo(contentView).inset(10)
        }
    }

    private func setBrandLabel() {
        brankLabel.text = "Brand"
        contentView.addSubview(brankLabel)
        brankLabel.snp.makeConstraints { label in
            label.leading.equalTo(productImageView.snp.trailing).offset(10)
            label.top.equalTo(titleLabel.snp.bottom).offset(10)
            label.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
    }

    private func setCellAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 5
        layer.masksToBounds = true

        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
