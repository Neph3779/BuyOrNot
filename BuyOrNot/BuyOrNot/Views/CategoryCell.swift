//
//  CategoryCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/24.
//

import UIKit
import SnapKit
import Then

final class CategoryCell: TapReactCollectionViewCell {
    static let reuseIdentifier = "categoryCell"

    private let categoryLabel = UILabel()
    private let productImageView = UIImageView()
    private(set) var category: ProductCategory = .phone

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCategoryLabel()
        setUpProductImageView()
        setUpCellAppearance()
        addSelectMaskToContentView(cornerRadius: 10)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpContents(category: ProductCategory) {
        self.category = category
        productImageView.image = UIImage(named: category.image)
        categoryLabel.text = category.name
        contentView.backgroundColor = category.backgroundColor
    }

    private func setUpCategoryLabel() {
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
