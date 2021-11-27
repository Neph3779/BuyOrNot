//
//  KakaoBlogPost.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/28.
//

import Foundation

struct KakaoBlogPost: Decodable {
    let documents: [KakaoDocument]
}

struct KakaoDocument: Decodable {
    let title: String
    let contents: String
    let blogName: String
    let thumbnail: String
    enum CodingKeys: String, CodingKey {
        case title, contents, thumbnail
        case blogName = "blogname"
    }
}
