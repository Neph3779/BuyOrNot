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

    func fetchYoutubeReviews(query: String, completion: @escaping ([String?]) -> Void) {
        let searchQuery = query.split(separator: " ").joined(separator: "+")

        guard let encodedString = (baseURL + searchQuery)
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else { return }

        AF.request(url, method: .get).responseString { response in
            do {
                let htmlSource = try response.result.get()
                let script = try SwiftSoup.parse(htmlSource).select("body[dir]").select("script[nonce]").array()
                let filtered = try script.filter { element in
                    try element.html().contains("ytInitialData") // var ytInitialData = JSON FILE; 형태로 저장되어있음
                }

                if let jsonData = filtered.first {
                    let dataString = String(try jsonData.html()
                                                .replacingOccurrences(of: "var ytInitialData = ", with: "")
                                                .dropLast()) // var 선언 부분과 마지막 문자 ;를 제거하여 JSON 파일 형태로 만들어줌
                    let data = Data(dataString.utf8)
                    let result = try JSONDecoder().decode(YoutubeCrawlingResult.self, from: data)

                    let itemSectionRenderers = result.contents?.twoColumnSearchResultsRenderer?
                        .primaryContents?.sectionListRenderer?.contents
                    var videoIds = [String?]()

                    itemSectionRenderers?.forEach { sectionContent in
                        sectionContent.itemSectionRenderer?.contents?.forEach { videoContent in
                            videoIds.append(videoContent.videoRenderer?.videoId)
                        }
                    }

                    completion(videoIds)
                }
            } catch {

            }
        }
    }
}
