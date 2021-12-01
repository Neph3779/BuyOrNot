//
//  YoutubeVideoItem.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import Foundation

struct YoutubeSearchResult: Decodable {
    let items: [YoutubeSearchResult.VideoItem]

    struct VideoItem: Decodable {
        let id: Id
        let snippet: YoutubeSearchResult.Snippet
    }

    struct Id: Decodable {
        let videoId: String
    }

    struct Snippet: Decodable {
        let title: String
        let description: String
        let channelTitle: String
        let thumbnails: YoutubeSearchResult.Thumbnails
    }

    struct Thumbnails: Decodable {
        let `default`: YoutubeSearchResult.Thumbnail
        let medium: YoutubeSearchResult.Thumbnail
        let high: YoutubeSearchResult.Thumbnail
    }

    struct Thumbnail: Decodable {
        let url: String
        let width: Int
        let height: Int
    }
}
