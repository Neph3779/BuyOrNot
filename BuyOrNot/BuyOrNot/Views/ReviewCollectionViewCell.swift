//
//  ReviewCollectionViewCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit

final class ReviewCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "reviewCollectionViewCell"

    private let siteKind: ReviewSiteKind = .youtube
    private let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellAppearance()
        setLogoImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setSiteKind(siteKind: ReviewSiteKind) {
        contentView.backgroundColor = siteKind.cellColor.withAlphaComponent(0.5)
        logoImageView.image = UIImage(named: siteKind.imageName)
    }

    private func setLogoImageView() {
        logoImageView.contentMode = .scaleAspectFit
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { imageView in
            imageView.trailing.equalTo(contentView).inset(20)
            imageView.width.height.equalTo(contentView.snp.height).multipliedBy(0.3)
            imageView.centerY.equalTo(contentView.snp.centerY)
        }
    }

    private func setCellAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 5
        layer.masksToBounds = true

        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
