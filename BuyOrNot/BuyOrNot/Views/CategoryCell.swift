//
//  CategoryCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/24.
//

import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "categoryCell"
    let productImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCellAppearance()
        setUpProductImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpCellAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }

    private func setUpProductImageView() {
        contentView.addSubview(productImageView)
        productImageView.backgroundColor = .clear
        productImageView.snp.makeConstraints { view in
            view.width.equalTo(self.contentView.snp.width).multipliedBy(0.7)
            view.top.bottom.trailing.equalTo(self.contentView)
        }
        productImageView.image = UIImage(named: "phoneCategoryImage")
        productImageView.contentMode = .scaleAspectFit
    }
}
