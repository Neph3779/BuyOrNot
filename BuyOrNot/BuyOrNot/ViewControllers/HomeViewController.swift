//
//  HomeViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import UIKit
import SnapKit
import RealmSwift
import Then
// TODO: 로딩 인디케이터 제작
final class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .darkGray
        $0.contentMode = .scaleAspectFill
        $0.setPreferredSymbolConfiguration(.init(pointSize: 28), forImageIn: .normal)
        $0.addTarget(self, action: #selector(moveToSearchView(_:)), for: .touchUpInside) // MARK: ignore warning
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout()).then {
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        $0.register(RecommendProductCell.self, forCellWithReuseIdentifier: RecommendProductCell.reuseIdentifier)
        $0.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: "header",
                    withReuseIdentifier: HomeCollectionHeaderView.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = ColorSet.backgroundColor
    }
    private let loadingIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.backgroundColor
        layout()
        addNotificationObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    private func layout() {
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { button in
            button.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            button.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            button.width.height.equalTo(50)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { collection in
            collection.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            collection.top.equalTo(searchButton.snp.bottom).offset(10)
        }
    }

    private func compositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            if section == 0 {
                let categoryItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                            heightDimension: .fractionalHeight(1)))
                categoryItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
                let categoryGroup = NSCollectionLayoutGroup
                    .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.55),
                                                  heightDimension: .fractionalHeight(0.5)),
                                subitems: [categoryItem])
                let categorySection = NSCollectionLayoutSection(group: categoryGroup)
                categorySection.orthogonalScrollingBehavior = .continuous

                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(100))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                             elementKind: "header",
                                                                             alignment: .top)

                categorySection.boundarySupplementaryItems = [headerItem]
                categorySection.contentInsets = .init(top: 20, leading: 10, bottom: 30, trailing: 0)
                return categorySection
            } else {
                let recommendItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
                recommendItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
                let recommendGroup = NSCollectionLayoutGroup
                    .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.55),
                                                  heightDimension: .absolute(200)),
                                subitems: [recommendItem])
                let recommendSection = NSCollectionLayoutSection(group: recommendGroup)
                recommendSection.orthogonalScrollingBehavior = .continuous
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(100))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                             elementKind: "header",
                                                                             alignment: .top)
                recommendSection.boundarySupplementaryItems = [headerItem]
                recommendSection.contentInsets = .init(top: 20, leading: 10, bottom: 0, trailing: 0)
                return recommendSection
            }
        }
    }

    @objc private func moveToSearchView(_ sender: UIButton) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    private func addNotificationObserver() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(didLoadingEnd(_:)),
                         name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil)

        NotificationCenter.default
            .addObserver(self, selector: #selector(didDeleteAllEnd(_:)),
                         name: NSNotification.Name("rankedProductsDeleteAllEnd"), object: nil)
    }

    @objc func didLoadingEnd(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.viewModel.setRandomProducts()
            self.collectionView.reloadSections(.init(integer: 1))
        }
    }

    @objc func didDeleteAllEnd(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel.removeProducts()
            self.collectionView.reloadSections(.init(integer: 1))
            self.loadingIndicator.startAnimating()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return ProductCategory.allCases.count
        } else {
            if let productCount = viewModel.products?.count {
                return productCount
            }
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let categoryCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
                    as? CategoryCell else { return UICollectionViewCell() }
            categoryCell.setUpContents(category: ProductCategory.allCases[indexPath.row])
            return categoryCell
        } else {
            guard let recommnedCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: RecommendProductCell.reuseIdentifier, for: indexPath)
                    as? RecommendProductCell else { return UICollectionViewCell() }
            if let product = viewModel.products?[indexPath.row] {
                recommnedCell.setContents(product: product)
            }

            return recommnedCell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView
            .dequeueReusableSupplementaryView(ofKind: "header",
                                              withReuseIdentifier: HomeCollectionHeaderView.reuseIdentifier,
                                              for: indexPath) as? HomeCollectionHeaderView else {
            return UICollectionReusableView()
        }

        if indexPath.section == 0 {
            header.setUpContents(section: .category)
        } else {
            header.setUpContents(section: .recommend)
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
            let category = cell.category
            navigationController?.pushViewController(RankViewController(category: category), animated: true)
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecommendProductCell,
                  let product = cell.product else { return }
            navigationController?.pushViewController(ProductDetailViewController(product: product), animated: true)
        }
    }
}
