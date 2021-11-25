//
//  ProductRank.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation

enum ProductCategory: CaseIterable {
    case phone
    case keyboard
    case monitor
    case spaeker
    case tablet
    case smartWatch

    var image: String {
        switch self {
        case .phone:
            return "phoneCategoryImage"
        case .keyboard:
            return "keyboardCategoryImage"
        case .monitor:
            return "monitorCategoryImage"
        case .spaeker:
            return "speakerCategoryImage"
        case .tablet:
            return "tabletCategoryImage"
        case .smartWatch:
            return "smartWatchCategoryImage"
        }
    }
}

struct RankedProduct {
    let category: ProductCategory
    let brand: String
    let name: String
    var rank: Int
    let image: URL
}
