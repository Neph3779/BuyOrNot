//
//  KakaoBlogPost.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/28.
//

import Foundation

struct KakaoBlogResult: Decodable {
    let documents: [KakaoDocument]
}

struct KakaoDocument: Decodable {
    let title: String
    let contents: String
    let blogName: String
    let thumbnail: String
    let link: String
    enum CodingKeys: String, CodingKey {
        case title, contents, thumbnail
        case blogName = "blogname"
        case link = "url"
    }
}
