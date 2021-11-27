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
    private var category: ProductCategory

    init(category: ProductCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.category = .phone
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setCategoryView()
        setRankColletionView()
    }

    private func setCategoryView() {
        categoryView.contentMode = .scaleAspectFill
        categoryView.image = UIImage(named: category.image)
        view.addSubview(categoryView)
        categoryView.snp.makeConstraints { categoryView in
            categoryView.top.leading.trailing.equalTo(view)
            categoryView.height.equalTo(view.snp.height).multipliedBy(0.3)
        }

        let label = UILabel()
        label.text = category.name
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .darkGray.withAlphaComponent(0.5)

        categoryView.addSubview(label)
        label.snp.makeConstraints { label in
            label.edges.equalToSuperview()
        }
    }

    private func setRankColletionView() {
        rankCollectionView.register(RankCollectionViewCell.self,
                                    forCellWithReuseIdentifier: RankCollectionViewCell.reuseidentifier)
        rankCollectionView.dataSource = self
        rankCollectionView.delegate = self
        rankCollectionView.backgroundColor = .white

        view.addSubview(rankCollectionView)
        rankCollectionView.snp.makeConstraints { tableView in
            tableView.leading.trailing.bottom.equalTo(view)
            tableView.top.equalTo(categoryView.snp.bottom)
        }
    }
}

extension RankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = RankManager.shared.rankedProducts[category]?.count else { return 0 }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let products = RankManager.shared.rankedProducts[category],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankCollectionViewCell.reuseidentifier,
                                                            for: indexPath) as? RankCollectionViewCell else {
                  return UICollectionViewCell()
              }
        cell.setContents(product: products[indexPath.row])

        return cell
    }
}

extension RankViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(ProductDetailViewController(), animated: true)
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
