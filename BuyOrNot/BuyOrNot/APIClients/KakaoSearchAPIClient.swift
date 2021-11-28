//
//  KakaoSearchAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/28.
//

import Foundation
import Alamofire

final class KakaoAPIClient {
    private var url = URL(string: "https://dapi.kakao.com/v2/search/blog")!

    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "KakaoAPIKey") as? String else {
                  fatalError("API key valid failed")
              }
        return value
    }

    private init() {}
    static let shared = KakaoAPIClient()

    func fetchKakaoBlogPosts(query: String, count: Int = 10, completion: @escaping (DataResponse<KakaoBlogResult, AFError>) -> Void) {
        var headers: HTTPHeaders = []
        var parameters: [String: String] = [:]
        headers.update(name: "Authorization", value: apiKey)

        parameters.updateValue(query, forKey: "query")
        parameters.updateValue(String(count), forKey: "size")

        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(completionHandler: completion)
    }
}
