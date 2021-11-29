//
//  ReviewCollectionViewCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit
import SnapKit
import Kingfisher

final class ReviewCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "reviewCollectionViewCell"

    private let siteKind: ReviewSiteKind = .youtube
    let thumnailImageView = UIImageView()
    private let logoImageView = UIImageView()
    private let labelStackView = UIStackView()
    private let nameLabel =  UILabel()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellAppearance()
        setThumbnailImageView()
        setLogoImageView()
        setLabelStackView()
        setNameLabel()
        setTitleLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setContents(content: ReviewContent) {
        contentView.backgroundColor = content.siteKind.cellColor
        logoImageView.image = UIImage(named: content.siteKind.imageName)
        titleLabel.text = content.title.htmlEscaped
        nameLabel.text = content.producerName.htmlEscaped

        if content.thumbnail == nil {
            thumnailImageView.snp.remakeConstraints { imageView in
                imageView.top.leading.bottom.equalTo(contentView).inset(10)
                imageView.width.equalTo(0)
            }
            contentView.layoutSubviews()
        } else {
            thumnailImageView.snp.remakeConstraints { imageView in
                imageView.top.leading.bottom.equalTo(contentView).inset(10)
                imageView.width.equalTo(thumnailImageView.snp.height)
            }
            thumnailImageView.kf.setImage(with: content.thumbnail, options: [.loadDiskFileSynchronously]) { _ in
                self.contentView.layoutSubviews()
            }
        }
    }

    private func setThumbnailImageView() {
        thumnailImageView.contentMode = .scaleAspectFill
        thumnailImageView.layer.cornerRadius = 10
        thumnailImageView.clipsToBounds = true
        contentView.addSubview(thumnailImageView)
        thumnailImageView.snp.makeConstraints { imageView in
            imageView.top.leading.bottom.equalTo(contentView).inset(10)
            imageView.width.equalTo(thumnailImageView.snp.height)
        }
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

    private func setLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        labelStackView.spacing = 5
        contentView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { stackView in
            stackView.centerY.equalTo(contentView)
            stackView.leading.equalTo(thumnailImageView.snp.trailing).offset(10)
            stackView.trailing.equalTo(logoImageView.snp.leading).offset(-10)
        }
    }

    private func setNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .white
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        labelStackView.addArrangedSubview(nameLabel)
    }

    private func setTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        labelStackView.addArrangedSubview(titleLabel)
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
