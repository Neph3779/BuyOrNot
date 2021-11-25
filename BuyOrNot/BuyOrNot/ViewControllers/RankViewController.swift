//
//  RankViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit
import SnapKit

final class RankViewController: UIViewController {
    private let categoryView = UIImageView()
    private let rankCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setCategoryView()
        setRankColletionView()
    }

    private func setCategoryView() {
        categoryView.contentMode = .scaleAspectFill
        categoryView.image = UIImage(named: "phoneCategoryImage")
        view.addSubview(categoryView)
        categoryView.snp.makeConstraints { categoryView in
            categoryView.top.leading.trailing.equalTo(view)
            categoryView.height.equalTo(view.snp.height).multipliedBy(0.3)
        }

        let label = UILabel()
        label.text = "Phone"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white

        categoryView.addSubview(label)
        label.snp.makeConstraints { label in
            label.center.equalToSuperview()
        }
    }

    private func setRankColletionView() {
        rankCollectionView.register(RankCollectionViewCell.self,
                                    forCellWithReuseIdentifier: RankCollectionViewCell.reuseidentifier)
        rankCollectionView.dataSource = self
        rankCollectionView.delegate = self

        view.addSubview(rankCollectionView)
        rankCollectionView.snp.makeConstraints { tableView in
            tableView.leading.trailing.bottom.equalTo(view)
            tableView.top.equalTo(categoryView.snp.bottom)
        }
    }
}

extension RankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductCategory.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankCollectionViewCell.reuseidentifier,
                                                      for: indexPath)

        return cell
    }
}

extension RankViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension RankViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ViewSize.viewWidth - 20, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
}
