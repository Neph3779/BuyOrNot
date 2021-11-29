//
//  RankManager.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation

final class RankManager {
    var rankedProducts: [ProductCategory: [Product]] = [:]
    var didLoadingEnd = false

    func refreshRank(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            ProductCategory.allCases.forEach { [weak self] in
                self?.rankedProducts.updateValue(DanawaAPIClient.shared.fetchRankData(category: $0), forKey: $0)
            }
            DispatchQueue.main.sync {
                completion()
                self.didLoadingEnd = true
                NotificationCenter.default
                    .post(name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil, userInfo: nil)
            }
        }
    }
    private init() {}
    static let shared = RankManager()
}
