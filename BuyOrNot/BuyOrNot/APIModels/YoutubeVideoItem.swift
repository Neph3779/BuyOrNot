//
//  YoutubeVideoItem.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import Foundation

struct YoutubeSearchResult: Decodable {
    let items: [YoutubeVideoItem]
}

struct YoutubeVideoItem: Decodable {
    let snippet: Snippet
}

struct Snippet: Decodable {
    let title: String
    let description: String
    let channelTitle: String
    let thumbnails: YoutubeThumbnails
}

struct YoutubeThumbnails: Decodable {
    let `default`: YoutubeThumnail
    let medium: YoutubeThumnail
    let high: YoutubeThumnail
}

struct YoutubeThumnail: Decodable {
    let url: URL
    let width: Int
    let height: Int
}
