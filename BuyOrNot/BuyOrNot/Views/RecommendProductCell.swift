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
        stackView.distribution = .fill
        return stackView
    }()

    private let productImageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "시험"
        return label
    }()

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
            stackView.top.leading.trailing.equalTo(contentView)
            stackView.bottom.equalTo(contentView).inset(10)
        }
    }

    private func setUpProductImageView() {
        productImageView.image = UIImage(named: "phoneCategoryImage")
        productImageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(productImageView)
    }

    private func setUpTitleLabel() {
        titleLabel.text = "시범용"
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
    }
}
