//
//  DanawaAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation
import SwiftSoup

final class DanawaAPIClient {
    private init() {}
    static let shared = DanawaAPIClient()

    func fetchRankData(category: Category) {
        do {
            let html = try String(contentsOf: category.url, encoding: .utf8)
            let document = try SwiftSoup.parse(html)
            let doc = try document.select(".product_list").select(".prod_name").select("a").text()

            let list = doc.replacingOccurrences(of: ", 공기계", with: "")
                .replacingOccurrences(of: "NEW", with: "")

            print(list)
        } catch {

        }
    }
}

extension DanawaAPIClient {
    enum Category {
        case phone
        case keyboard
        case monitor
        case camera
        case spaeker
        case tablet
        case smartWatch

        var url: URL {
            switch self {
            case .phone:
                guard let url = URL(string: DanawaURL.phone) else {
                    fatalError("Can not convert phone category URL")
                }
                return url
            case .keyboard:
                guard let url = URL(string: DanawaURL.keyboard) else {
                    fatalError("Can not convert phone category URL")
                }
                return url
            case .monitor:
                guard let url = URL(string: DanawaURL.monitor) else {
                    fatalError("Can not convert phone category URL")
                }
                return url
            case .camera:
                guard let url = URL(string: DanawaURL.camera) else {
                    fatalError("Can not convert phone category URL")
                }
                return url
            case .spaeker:
                guard let url = URL(string: DanawaURL.spaeker) else {
                    fatalError("Can not convert phone category URL")
                }
                return url
            case .tablet:
                guard let url = URL(string: DanawaURL.tablet) else {
                    fatalError("Can not convert tablet category URL")
                }
                return url
            case .smartWatch:
                guard let url = URL(string: DanawaURL.smartWatch) else {
                    fatalError("Can not convert phone category URL")
                }
                return url
            }
        }
    }

    enum DanawaURL {
        static let phone = "https://prod.danawa.com/list/?cate=12215709&logger_kw=ca_main_more"
        static let keyboard = ""
        static let monitor = ""
        static let camera = ""
        static let spaeker = ""
        static let tablet = "http://prod.danawa.com/list/?cate=12210596&logger_kw=ca_list_more"
        static let smartWatch = ""
    }
}

/*
 RankedProduct 모델 제작
 크롤링 결과 formatting하는 로직 필요
 Rank Manager 제작해서 랭킹 알고리즘 구현 (Realm도 add해야할듯)
 특정시간에 Rank 업데이트 되도록 하는 로직 구현
 연령대별 쇼핑 트렌드 검색어 받아오는 API 구현ㄷ
 링크로 이동하는 방법 학습
 url 변환시 에러 처리 방법 고안
 */
