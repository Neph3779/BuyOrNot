//
//  ViewSize.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/25.
//

import UIKit

enum ViewSize {
    static var viewWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    static let categoryCellSize = CGSize(width: viewWidth / 2 - 30, height: (viewWidth / 2 - 30) * 0.85)
    static let recommendCellSize = CGSize(width: 135, height: 220)
}
