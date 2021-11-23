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
}

struct RankedProduct {
    let category: ProductCategory
    let brand: String
    let name: String
    var rank: Int
    let image: URL
}
