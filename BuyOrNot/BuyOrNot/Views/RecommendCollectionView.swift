//
//  CategoryCollectionView.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/25.
//

import UIKit
import SnapKit

final class RecommendCollectionView: UICollectionView {
    private var randomCategoryProducts = RankManager.shared.rankedProducts.randomElement()?.value

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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addNotificationObserver() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(didLoadingEnd(_:)),
                         name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil)
    }

    @objc func didLoadingEnd(_ notification: Notification) {
        self.randomCategoryProducts = RankManager.shared.rankedProducts.randomElement()?.value
        self.reloadData()
    }
}

extension RecommendCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let products = randomCategoryProducts else { return 0 }

        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let products = randomCategoryProducts,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendProductCell.reuseIdentifier,
                                                            for: indexPath) as? RecommendProductCell else {
                  return UICollectionViewCell()
              }

        cell.setContents(product: products[indexPath.row])
        return cell
    }
}

extension RecommendCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ViewSize.recommendCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    }
}
