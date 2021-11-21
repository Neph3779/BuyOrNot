//
//  NaverAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import Alamofire

final class NaverAPIClient {
    private var blogSearchURL: URL {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/blog.json") else {
            fatalError("Can not convert blogSearchURL")
        }
        return url
    }

    private var shoppingSearchURL: URL {
        guard let url = URL(string: "https://openapi.naver.com/v1/search/shop.json") else {
            fatalError("Can not convert shoppingSearchURL")
        }
        return url
    }

    private var clientId: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
            fatalError("Couldn't find file 'KeyList.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "NaverClientId") as? String else {
            fatalError("Couldn't find 'NaverClientId' in 'APIKeyList.plist'.")
        }
        return value
    }

    private var clientSecret: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
            fatalError("Couldn't find file 'KeyList.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "NaverClientSecret") as? String else {
            fatalError("Couldn't find 'NaverClientSecret' in 'APIKeyList.plist'.")
        }
        return value
    }

    private var parameters: [String: String] = [:]
    private var headers: HTTPHeaders = []

    func fetchNaverBlogPosts(query: String, count: Int = 10, completion: @escaping (DataResponse<YoutubeSearchResult, AFError>) -> Void) {
        headers.update(name: "X-Naver-Client-Id", value: clientId)
        headers.update(name: "X-Naver-Client-Secret", value: clientSecret)

        parameters.updateValue(query, forKey: "query")
        parameters.updateValue(String(count), forKey: "display")

        AF.request(blogSearchURL, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(completionHandler: completion)
    }
}
