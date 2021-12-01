//
//  YoutubeVideosResult.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/12/02.
//

import Foundation

struct YoutubeVideosResult: Decodable {
    let items: [YoutubeVideosResult.VideoItem]

    struct VideoItem: Decodable {
        let id: String
        let snippet: YoutubeVideosResult.Snippet
    }

    struct Snippet: Decodable {
        let title: String
        let channelTitle: String
        let thumbnails: YoutubeVideosResult.Thumbnails
    }

    struct Thumbnails: Decodable {
        let `default`: YoutubeVideosResult.Thumbnail
        let medium: YoutubeVideosResult.Thumbnail
        let high: YoutubeVideosResult.Thumbnail
    }

    struct Thumbnail: Decodable {
        let url: String
        let width: Int
        let height: Int
    }
}
