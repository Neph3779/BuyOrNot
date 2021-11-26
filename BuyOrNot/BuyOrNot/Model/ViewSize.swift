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

    static var viewHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    static let categoryCellSize = CGSize(width: viewWidth * 0.5, height: viewHeight * 0.4)
    static let recommendCellSize = CGSize(width: 200, height: 200)
}
