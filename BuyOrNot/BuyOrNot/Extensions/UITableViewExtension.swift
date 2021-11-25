//
//  UITableViewExtension.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/25.
//

import UIKit
import SnapKit

extension UITableViewCell {
    func setContentView(view: UIView) {
        contentView.addSubview(view)
        view.snp.makeConstraints { view in
            view.edges.equalToSuperview()
        }
    }
}
