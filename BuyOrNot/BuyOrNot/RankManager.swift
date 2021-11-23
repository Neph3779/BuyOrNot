//
//  RankManager.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation

final class RankManager {
    static var rankedProducts: [ProductCategory: [RankedProduct]] = [:]

    func refreshRank() {
        ProductCategory.allCases.forEach {
            RankManager.rankedProducts.updateValue(DanawaAPIClient.shared.fetchRankData(category: $0), forKey: $0)
        }
    }
    private init() {}
    static let shared = RankManager()
}
