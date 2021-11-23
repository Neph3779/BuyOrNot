//
//  HomeViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let categoryCollectionView: UICollectionView = UICollectionView(frame: .zero,
                                                          collectionViewLayout: UICollectionViewFlowLayout())
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "홈"
        setCategoryCollectionView()
        categoryCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func setCategoryCollectionView() {
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        view.addSubview(categoryCollectionView)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductCategory.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowWidthWithoutInset: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.width - 10 * CGFloat(2)
        let gridCellWidth: CGFloat = rowWidthWithoutInset / CGFloat(2)

        return CGSize(width: gridCellWidth, height: gridCellWidth * 0.7)
    }
}
