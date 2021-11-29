//
//  RankManager.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation
import RealmSwift

// TODO: 매일 1회 업데이트 로직 구현 (가능하다면 백그라운드에서?)

final class RankManager {
    var didLoadingEnd = false

    func refreshRank(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            ProductCategory.allCases.forEach {
                DanawaAPIClient.shared.fetchRankData(category: $0).forEach { product in
                    try! Realm().write {
                        try! Realm().add(product)
                    }
                }
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
