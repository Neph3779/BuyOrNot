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

    private let categoryLabel = UILabel()
    private let productImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightGray
        setUpCategoryLabel()
        setUpProductImageView()
        setUpCellAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setImage(image: UIImage) {
        productImageView.image = image
    }

    func setTitle(title: String) {
        categoryLabel.text = title
    }

    private func setUpCategoryLabel() {
        categoryLabel.text = "Phone"
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 28)

        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { label in
            label.leading.equalTo(contentView.snp.leading).inset(10)
            label.top.equalTo(contentView.snp.top).inset(30)
        }
    }

    private func setUpProductImageView() {
        contentView.addSubview(productImageView)
        productImageView.backgroundColor = .clear
        productImageView.snp.makeConstraints { view in
            view.height.width.equalTo(contentView.snp.width).multipliedBy(0.8)
            view.bottom.trailing.equalTo(contentView).inset(10)
        }
        productImageView.image = UIImage(named: "phoneCategoryImage")
        productImageView.contentMode = .scaleAspectFit
    }

    private func setUpCellAppearance() {
        contentView.layer.cornerRadius = 10
    }
}
