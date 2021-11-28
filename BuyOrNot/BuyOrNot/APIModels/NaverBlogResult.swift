//
//  NaverBlogPosts.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation

struct NaverBlogResult: Decodable {
    let items: [NaverBlogItem]
}

struct NaverBlogItem: Decodable {
    let title: String
    let link: String
    let description: String
    let bloggerName: String

    enum CodingKeys: String, CodingKey {
        case title, link, description
        case bloggerName = "bloggername"
    }
}
