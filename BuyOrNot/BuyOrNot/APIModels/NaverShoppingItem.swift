//
//  NaverShoppingItem.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import Foundation

struct NaverShoppingItem: Decodable {
    let name: String
    let link: URL
    let image: URL
    let lowestPrice: Int
    let brand: String

    enum CodingKeys: String, CodingKey {
        case name = "title"
        case lowestPrice = "lprice"
        case image, link, brand
    }
}
