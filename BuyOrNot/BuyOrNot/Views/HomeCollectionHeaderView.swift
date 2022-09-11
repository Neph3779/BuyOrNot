//
//  HomeCollectionHeaderView.swift
//  BuyOrNot
//
//  Created by 천수현 on 2022/09/11.
//

import UIKit
import SnapKit
import Then

final class HomeCollectionHeaderView: UICollectionReusableView {
    enum Section {
        case category
        case recommend
    }
    static let reuseIdentifier = "homeCollectionHeaderView"
    private let titleLabel = UILabel().then {
        $0.textColor = .darkGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpContents(section: Section) {
        switch section {
        case .category:
            titleLabel.text = "CATEGORY"
            titleLabel.font = .boldSystemFont(ofSize: 40)
        case .recommend:
            titleLabel.text = "이런 제품은 어떠세요?"
            titleLabel.font = .boldSystemFont(ofSize: 18)
        }
    }

    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { label in
            label.edges.equalToSuperview()
        }
    }
}
