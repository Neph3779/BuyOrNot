//
//  HomeViewModel.swift
//  BuyOrNot
//
//  Created by 천수현 on 2022/09/11.
//

import Foundation
import RealmSwift

final class HomeViewModel {
    var products: [Product]?

    init() {
        products = randomProducts()
    }

    private func randomProducts() -> [Product] {
        if try! Realm().objects(Product.self).isEmpty {
            return []
        }
        let productArray = Array(try! Realm().objects(Product.self))
        if DateController.shared.shouldShowItsProductOnly() {
            return productArray.filter { $0.brand == "APPLE" }
        }

        var randomArray = Array(repeating: 0, count: productArray.count).map { _ in
            Int.random(in: 0 ..< productArray.count)
        }
        randomArray = Array(Set(randomArray))

        let count = randomArray.count < 30 ? randomArray.count : 30
        var randomProductArray = [Product]()

        for i in 0 ..< count {
            randomProductArray.append(productArray[randomArray[i]])
        }

        return randomProductArray
    }
}
