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
    private let nameLabel =  UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellAppearance()
        setLogoImageView()
        setNameLabel()
        setTitleLabel()
        setDescriptionLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setSiteKind(siteKind: ReviewSiteKind) {
        contentView.backgroundColor = siteKind.cellColor.withAlphaComponent(0.65)
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

    private func setNameLabel() {
        nameLabel.text = "잇섭"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 12)
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { label in
            label.top.leading.equalTo(contentView).inset(10)
            label.trailing.equalTo(logoImageView.snp.leading).offset(-10)
        }
    }

    private func setTitleLabel() {
        titleLabel.text = "세상에 이런 일이"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { label in
            label.top.equalTo(nameLabel.snp.bottom).offset(5)
            label.leading.equalTo(contentView).inset(10)
            label.trailing.equalTo(logoImageView.snp.leading).offset(-10)
        }
    }

    private func setDescriptionLabel() {
        descriptionLabel.text = "아주 긴 매우 긴 설명이 이어질 예정 어쩌구 저쩌구 솰라솰라 매우매우 길어질 수 있음 이건 당연히 길어야지 설명인데 ㄹㅇㅋㅋ"
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { label in
            label.top.equalTo(titleLabel.snp.bottom).offset(5)
            label.leading.equalTo(contentView).inset(10)
            label.trailing.equalTo(logoImageView.snp.leading).offset(-10)
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
