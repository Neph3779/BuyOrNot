//
//  TapReactCollectionViewCell.swift
//  BuyOrNot
//
//  Created by 천수현 on 2022/09/19.
//

import UIKit

class TapReactCollectionViewCell: UICollectionViewCell {
    let selectMask = UIView(frame: .zero).then {
        $0.backgroundColor = .darkGray
        $0.layer.opacity = 0.3
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addSelectMaskToContentView(cornerRadius: CGFloat) {
        contentView.addSubview(selectMask)
        selectMask.layer.cornerRadius = cornerRadius
        selectMask.snp.makeConstraints { mask in
            mask.edges.equalTo(contentView)
        }
    }
}
