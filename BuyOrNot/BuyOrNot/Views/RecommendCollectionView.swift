//
//  CategoryCollectionView.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/25.
//

import UIKit
import SnapKit
import RealmSwift

final class RecommendCollectionView: UICollectionView {
    private var products = [Product]()

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        register(RecommendProductCell.self, forCellWithReuseIdentifier: RecommendProductCell.reuseIdentifier)
        dataSource = self
        delegate = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        addNotificationObserver()
        products = randomProducts()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func randomProducts() -> [Product] {
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

    private func addNotificationObserver() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(didLoadingEnd(_:)),
                         name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil)
    }

    @objc func didLoadingEnd(_ notification: Notification) {
        products = randomProducts()
        self.reloadData()
    }
}

extension RecommendCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendProductCell.reuseIdentifier,
                                                            for: indexPath) as? RecommendProductCell else {
                  return UICollectionViewCell()
              }

        cell.setContents(product: products[indexPath.row])
        return cell
    }
}

extension RecommendCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecommendProductCell,
              let product = cell.product else { return }

        let recommendViewController = UIApplication.topViewController()

        recommendViewController?.navigationController?.pushViewController(ProductDetailViewController(product: product),
                                                                          animated: true)
    }
}

extension RecommendCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ViewSize.recommendCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
