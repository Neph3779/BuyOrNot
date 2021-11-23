//
//  NaverBlogPosts.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation

struct NaverBlogPost: Decodable {
    let title: String
    let link: URL
    let image: URL
    let description: String
    let bloggerName: String
    let bloggerLink: URL
    let postDate: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, description
        case bloggerName = "bloggername"
        case bloggerLink = "bloggerlink"
        case postDate = "postdate"
    }
}
