//
//  YoutubeAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import Alamofire

final class YoutubeAPIClient {
    private var url: URL {
        guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search") else {
            fatalError("Can not convert to URL")
        }
        return url
    }

    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
            fatalError("Couldn't find file 'KeyList.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "YoutubeAPIKey") as? String else {
            fatalError("Couldn't find key 'YoutubeAPIKey' in 'APIKeyList.plist'.")
        }
        return value
    }

    private var parameters: [String: String] = [:]

    func fetchYoutubeVideos(query: String, count: Int = 10, completion: @escaping (DataResponse<YoutubeSearchResult, AFError>) -> Void) {
        parameters.updateValue(apiKey, forKey: "key")
        parameters.updateValue("snippet", forKey: "part")
        parameters.updateValue(query, forKey: "q")
        parameters.updateValue(String(count), forKey: "maxResults")

        AF.request(url, method: .get, parameters: parameters)
            .responseDecodable(completionHandler: completion)
    }
}
