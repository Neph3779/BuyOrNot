//
//  DanawaAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import SwiftSoup
import Alamofire

final class DanawaCrawler {
    private init() {}
    static let shared = DanawaCrawler()

    func fetchRankData(category: ProductCategory) -> [Product] {
        var rankedProducts = [Product]()
        do {
            let html = try String(contentsOf: danawaUrl(category: category), encoding: .utf8)
            let productLists = try SwiftSoup.parse(html).select(".main_prodlist").select(".product_list")
            let productNames = try productLists.select(".prod_name").select("[name=productName]").array()
            let thumbnails = try productLists.select(".thumb_image").select(".thumb_link")
            let earlyThumnails = try thumbnails.select("img[src]").array()
            let lazyThumbnails = try thumbnails.select(".image_lazy").array()
            let thumnailElements = earlyThumnails + lazyThumbnails

            try productNames.enumerated().forEach { index, productName in
                var fullName = try productName.text()

                stringToRemove.forEach {
                    fullName = fullName.replacingOccurrences(of: $0, with: "")
                }

                var thumbnailURLString = try thumnailElements[index].attr("src")
                if thumbnailURLString == "" {
                    thumbnailURLString = try thumnailElements[index].attr("data-original")
                }
                let thumbnailURL = ("https:" + thumbnailURLString)
                let fullNameToList = fullName.split(separator: " ").map { String($0) }
                let brand = fullNameToList.first!
                let name = fullNameToList.dropFirst().joined(separator: " ")
                let rank = index
                rankedProducts.append(Product(category: category.rawValue, brand: brand,
                                                    name: name, rank: rank, image: thumbnailURL))
            }
        } catch {
        }

        return rankedProducts
    }
}

extension DanawaCrawler {
    private var stringToRemove: [String] { return [", 공기계", "NEW", "(정품)", ", 자급제"] }

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
