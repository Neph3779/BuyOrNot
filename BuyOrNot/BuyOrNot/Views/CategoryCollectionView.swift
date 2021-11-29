//
//  CategoryCollectionView.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/25.
//

import UIKit
import SnapKit

final class CategoryCollectionView: UICollectionView {
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)

        register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        dataSource = self
        delegate = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CategoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductCategory.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                                            for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        cell.setCategory(category: ProductCategory.allCases[index])
        cell.contentView.backgroundColor = ProductCategory.allCases[index].backgroundColor
        return cell
    }
}

extension CategoryCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        let categoryViewController = UIApplication.topViewController()
        let category = cell.category
        categoryViewController?.navigationController?.pushViewController(RankViewController(category: category),
                                                                         animated: true)
    }
}

extension CategoryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ViewSize.categoryCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    }
}
