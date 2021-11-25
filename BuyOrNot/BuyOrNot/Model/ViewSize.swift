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

    static let categoryCellSize = CGSize(width: 180, height: 300)
    static let recommendCellSize = CGSize(width: 200, height: 200)
}
