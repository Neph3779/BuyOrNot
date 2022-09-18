//
//  HomeViewModel.swift
//  BuyOrNot
//
//  Created by 천수현 on 2022/09/11.
//

import Foundation
import RealmSwift

final class HomeViewModel {
    private(set) var products: [Product]?
    var reloadRecommendProductSection: (() -> Void)?
    var highlightedIndexPathForCategoryCell: IndexPath?
    var highlightedIndexPathForRecommendProductCell: IndexPath?
    private(set) var isLoading = false

    init() {
        setRandomProducts()
        addNotificationObserver()
    }

    func removeProducts() {
        products = []
    }

    func setRandomProducts() {
        if try! Realm().objects(Product.self).isEmpty {
           products = []
        }
        let productArray = Array(try! Realm().objects(Product.self))
        if DateController.shared.shouldShowItsProductOnly() {
            products = productArray.filter { $0.brand == "APPLE" }
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

        products = randomProductArray
    }

    private func addNotificationObserver() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(shouldStopLoadingIndicator(_:)),
                         name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil)

        NotificationCenter.default
            .addObserver(self, selector: #selector(shouldStartLoadingIndicator(_:)),
                         name: NSNotification.Name("rankedProductsDeleteAllEnd"), object: nil)
    }

    @objc private func shouldStartLoadingIndicator(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeProducts()
            self.isLoading = true
            self.reloadRecommendProductSection?()
        }
    }

    @objc private func shouldStopLoadingIndicator(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setRandomProducts()
            self.isLoading = false
            self.reloadRecommendProductSection?()
        }
    }
}
