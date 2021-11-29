//
//  DanawaAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import SwiftSoup
import Alamofire

final class DanawaAPIClient {
    private init() {}
    static let shared = DanawaAPIClient()

    func fetchRankData(category: ProductCategory) -> [Product] {
        var rankedProducts = [Product]()
        do {
            let html = try String(contentsOf: danawaUrl(category: category), encoding: .utf8)
            let productLists = try SwiftSoup.parse(html).select(".product_list")
            let productNames = try productLists.select(".prod_name").select("[name=productName]").array()
            let thumbnails = try productLists.select(".thumb_image").select(".thumb_link")
            let earlyThumnails = try thumbnails.select("img[src]").array()
            let lazyThumbnails = try thumbnails.select(".image_lazy").array()
            let thumnailElements = earlyThumnails + lazyThumbnails

            for indexCount in 0..<productNames.count {
                var fullName = try productNames[indexCount].text()
                    .replacingOccurrences(of: ", 공기계", with: "")
                    .replacingOccurrences(of: "NEW", with: "")
                    .replacingOccurrences(of: "(정품)", with: "")

                stringToRemove.forEach {
                    fullName = fullName.replacingOccurrences(of: $0, with: "")
                }

                var thumbnailURLString = try thumnailElements[indexCount].attr("src")
                if thumbnailURLString == "" {
                    thumbnailURLString = try thumnailElements[indexCount].attr("data-original")
                }
                let thumbnailURL = ("https:" + thumbnailURLString)
                let fullNameToList = fullName.split(separator: " ").map { String($0) }
                let brand = fullNameToList.first!
                let name = fullNameToList.dropFirst().joined(separator: " ")
                let rank = indexCount
                rankedProducts.append(Product(category: category.rawValue, brand: brand,
                                                    name: name, rank: rank, image: thumbnailURL))
            }
        } catch {
        }

        return rankedProducts
    }
}

extension DanawaAPIClient {
    private var stringToRemove: [String] { return [", 공기계", "NEW", "(정품)"] }
    private func danawaUrl(category: ProductCategory) -> URL {
        switch category {
        case .phone:
            return URL(string: DanawaURL.phone)!
        case .keyboard:
            return URL(string: DanawaURL.keyboard)!
        case .monitor:
            return URL(string: DanawaURL.monitor)!
        case .spaeker:
            return URL(string: DanawaURL.spaeker)!
        case .tablet:
            return URL(string: DanawaURL.tablet)!
        case .smartWatch:
            return URL(string: DanawaURL.smartWatch)!
        }
    }

    private enum DanawaURL {
        static let phone = "https://prod.danawa.com/list/?cate=12215709&logger_kw=ca_main_more"
        static let keyboard = "http://prod.danawa.com/list/?cate=112782&logger_kw=ca_list_more"
        static let monitor = "http://prod.danawa.com/list/?cate=112757&logger_kw=ca_list_more"
        static let spaeker = "http://prod.danawa.com/list/?cate=12237379&logger_kw=ca_list_more"
        static let tablet = "http://prod.danawa.com/list/?cate=12210596&logger_kw=ca_list_more"
        static let smartWatch = "http://prod.danawa.com/list/?cate=18211863&logger_kw=ca_list_more"
    }
}

/*
 크롤링 결과 formatting하는 로직 필요
 Rank Manager 제작해서 랭킹 알고리즘 구현 (Realm도 add해야할듯)
 특정시간에 Rank 업데이트 되도록 하는 로직 구현
 연령대별 쇼핑 트렌드 검색어 받아오는 API 구현
 링크로 이동하는 방법 학습
 */
