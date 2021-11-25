//
//  RecommendProductCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/25.
//

import UIKit
import SnapKit

final class RecommendProductCell: UICollectionViewCell {
    static let reuseIdentifier = "recommendProductCell"
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()

    private let productImageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackView()
        setUpProductImageView()
        setUpTitleLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { stackView in
            stackView.edges.equalTo(contentView)
            stackView.bottom.equalTo(contentView).inset(10)
            stackView.height.equalTo(180)
        }
    }

    private func setUpProductImageView() {
        productImageView.image = UIImage(named: "phoneCategoryImage")
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 5
        productImageView.layer.borderWidth = 1
        productImageView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.addArrangedSubview(productImageView)
    }

    private func setUpTitleLabel() {
        titleLabel.text = "시범용"
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
    }
}
