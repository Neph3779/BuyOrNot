//
//  ReviewCollectionViewCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit

final class ReviewCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "reviewCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
