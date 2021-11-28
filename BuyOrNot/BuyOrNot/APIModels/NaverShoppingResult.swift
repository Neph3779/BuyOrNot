//
//  NaverShoppingItem.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import Foundation

struct NaverShoppingResult: Decodable {
    let items: [NaverShoppingItem]
}
struct NaverShoppingItem: Decodable {
    let name: String
    let link: String
    let image: String
    let lowestPrice: String
    let brand: String

    enum CodingKeys: String, CodingKey {
        case name = "title"
        case lowestPrice = "lprice"
        case image, link, brand
    }
}
