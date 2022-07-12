//
//  RankManager.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation
import RealmSwift

final class RankManager {
    static let shared = RankManager()

    func refreshRank() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.deleteAll()
            ProductCategory.allCases.forEach {
                DanawaCrawler.shared.fetchRankData(category: $0).forEach { product in
                    try! Realm().write { try! Realm().add(product) }
                }
            }
            NotificationCenter.default
                .post(name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil, userInfo: nil)
        }
    }

    private init() {}

    private func deleteAll() {
        let rankedProducts = try! Realm().objects(Product.self)
        if !rankedProducts.isEmpty {
            try! Realm().write { try! Realm().delete(rankedProducts) }
        }
        NotificationCenter.default
            .post(name: NSNotification.Name("rankedProductsDeleteAllEnd"), object: nil, userInfo: nil)
    }
}
