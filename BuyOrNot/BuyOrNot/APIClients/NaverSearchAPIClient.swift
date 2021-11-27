//
//  NaverAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import Alamofire

final class NaverSearchAPIClient {
    private var blogSearchURL = URL(string: "https://openapi.naver.com/v1/search/blog.json")!
    private var shoppingSearchURL = URL(string: "https://openapi.naver.com/v1/search/shop.json")!

    private var clientId: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "NaverClientId") as? String else {
                  fatalError("Client-Id valid failed")
              }
        return value
    }

    private var clientSecret: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "NaverClientSecret") as? String else {
                  fatalError("Client-Secret valid failed")
              }
        return value
    }

    private init() {}
    static let shared = NaverSearchAPIClient()

    func fetchNaverBlogPosts(query: String, count: Int = 10, completion: @escaping (DataResponse<NaverBlogPost, AFError>) -> Void) {
        var headers: HTTPHeaders = []
        var parameters: [String: String] = [:]
        headers.update(name: "X-Naver-Client-Id", value: clientId)
        headers.update(name: "X-Naver-Client-Secret", value: clientSecret)

        parameters.updateValue(query, forKey: "query")
        parameters.updateValue(String(count), forKey: "display")

        AF.request(blogSearchURL, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(completionHandler: completion)
    }

    func fetchNaverShoppingItem(query: String, count: Int = 10, completion: @escaping (DataResponse<NaverShoppingItem, AFError>) -> Void) {
        var headers: HTTPHeaders = []
        var parameters: [String: String] = [:]
        headers.update(name: "X-Naver-Client-Id", value: clientId)
        headers.update(name: "X-Naver-Client-Secret", value: clientSecret)

        parameters.updateValue(query, forKey: "query")
        parameters.updateValue(String(count), forKey: "display")

        AF.request(shoppingSearchURL, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(completionHandler: completion)
    }
}
