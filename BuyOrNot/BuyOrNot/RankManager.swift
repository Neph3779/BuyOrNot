//
//  RankManager.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation

final class RankManager {
    var rankedProducts: [ProductCategory: [RankedProduct]] = [:]

    func refreshRank(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            ProductCategory.allCases.forEach { [weak self] in
                self?.rankedProducts.updateValue(DanawaAPIClient.shared.fetchRankData(category: $0), forKey: $0)
            }
            DispatchQueue.main.sync {
                completion()
            }
        }
    }
    private init() {}
    static let shared = RankManager()
}
