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
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        dataSource = self
        delegate = self
        backgroundColor = .clear
        isScrollEnabled = false
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        return cell
    }
}

extension CategoryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ViewSize.categoryCellSize
    }
}
