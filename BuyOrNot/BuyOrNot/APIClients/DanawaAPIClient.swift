//
//  DanawaAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import SwiftSoup

// TODO: data 가공 로직, Danawa URL 추가

final class DanawaAPIClient {
    private init() {}
    static let shared = DanawaAPIClient()

    func fetchRankData(category: ProductCategory) -> [RankedProduct] {
        do {
            let html = try String(contentsOf: danawaUrl(category: category), encoding: .utf8)
            let document = try SwiftSoup.parse(html)
            let doc = try document.select(".product_list").select(".prod_name").select("a").text()

            let list = doc.replacingOccurrences(of: ", 공기계", with: "")
                .replacingOccurrences(of: "NEW", with: "")

            print(list)
        } catch {

        }
        return []
    }
}

extension DanawaAPIClient {
    func danawaUrl(category: ProductCategory) -> URL {
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

    enum DanawaURL {
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
