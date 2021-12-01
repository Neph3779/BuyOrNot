//
//  YoutubeAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import Alamofire

final class YoutubeAPIClient {
    private var searchURL = URL(string: "https://www.googleapis.com/youtube/v3/search")!
    private var videosURL = URL(string: "https://www.googleapis.com/youtube/v3/videos")!

    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "YoutubeAPIKey") as? String else {
                  fatalError("API key valid failed")
              }
        return value
    }

    private init() {}
    static let shared = YoutubeAPIClient()

    func fetchYoutubeVideos(query: String, count: Int = 10, completion: @escaping (DataResponse<YoutubeSearchResult, AFError>) -> Void) {
        var parameters: [String: String] = [:]

        parameters.updateValue(apiKey, forKey: "key")
        parameters.updateValue("snippet", forKey: "part")
        parameters.updateValue(query, forKey: "q")
        parameters.updateValue(String(count), forKey: "maxResults")

        AF.request(searchURL, method: .get, parameters: parameters)
            .responseDecodable(completionHandler: completion)
    }

    func fetchYoutubeVideoById(videoId: String, completion: @escaping (DataResponse<YoutubeVideosResult, AFError>) -> Void) {
        var parameters: [String: String] = [:]

        parameters.updateValue(apiKey, forKey: "key")
        parameters.updateValue("snippet", forKey: "part")
        parameters.updateValue(videoId, forKey: "id")
        parameters.updateValue("1", forKey: "maxResults")

        AF.request(videosURL, method: .get, parameters: parameters)
            .responseDecodable(completionHandler: completion)
    }
}
