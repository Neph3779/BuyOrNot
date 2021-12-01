//
//  YoutubeCrawler.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/12/01.
//

import Foundation
import SwiftSoup
import Alamofire

final class YoutubeCrawler {
    private let baseURL = "https://www.youtube.com/results?search_query="
    private init() {}
    static let shared = YoutubeCrawler()

    func fetchYoutubeReviews(query: String, completion: @escaping (YoutubeCrawlingResult) -> Void) {
        let searchQuery = query.split(separator: " ").joined(separator: "+")
        guard let encodedString = (baseURL + searchQuery)
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: encodedString) else { return }
        AF.request(url, method: .get).responseString { response in
            do {
                let html = try response.result.get()
                let body = try SwiftSoup.parse(html).select("body[dir]").select("script[nonce]").array()
                let filtered = try body.filter { element in
                    try element.html().contains("ytInitialData")
                }

                if let jsonData = filtered.first {
                    let dataString = String(try jsonData.html()
                                                .replacingOccurrences(of: "var ytInitialData = ", with: "")
                                                .dropLast())
                    let data = Data(dataString.utf8)
                    let result = try JSONDecoder().decode(YoutubeCrawlingResult.self, from: data)
                    completion(result)
                }
            } catch {
                
            }
        }
    }
}
