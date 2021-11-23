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
        self.backgroundColor = .brown
        setImageViewLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setImageViewLayout() {
        self.contentView.addSubview(productImageView)
        productImageView.backgroundColor = .gray
        productImageView.snp.makeConstraints { view in
            view.width.equalTo(self.contentView.snp.width).multipliedBy(0.5)
            view.top.bottom.trailing.equalTo(self.contentView)
        }
    }
}
