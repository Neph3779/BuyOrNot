//
//  RankManager.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation
import RealmSwift

final class RankManager {
    var didLoadingEnd = false

    func refreshRank(completion: @escaping () -> Void) {
        deleteAll()
        DispatchQueue.global().async {
            ProductCategory.allCases.forEach {
                DanawaAPIClient.shared.fetchRankData(category: $0).forEach { product in
                    try! Realm().write { try! Realm().add(product) }
                }
            }
            completion()
        }
    }
    private init() {}
    static let shared = RankManager()

    private func deleteAll() {
        DispatchQueue.global().async {
            let rankedProducts = try! Realm().objects(Product.self)
            if !rankedProducts.isEmpty {
                try! Realm().write { try! Realm().delete(rankedProducts) }
            }
        }
    }
}
