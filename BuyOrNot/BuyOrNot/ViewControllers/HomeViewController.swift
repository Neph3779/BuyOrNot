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

final class HomeViewController: UIViewController {
    private let homeViewModel = HomeViewModel()
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
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = ColorSet.backgroundColor
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layout()
        configureDatasource()
        applyDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    private func bind() {
        homeViewModel.reloadRecommendProductSection = {
            self.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }

    private func layout() {
        view.backgroundColor = ColorSet.backgroundColor
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
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self,
            let sectionKind = Section(rawValue: sectionIndex) else { return .none }

            switch sectionKind {
            case .category:
                return self.sectionForCategorys()
            case .recommendProduct:
                return self.sectionForRecommendProducts()
            }
        }
    }

    private func sectionForCategorys() -> NSCollectionLayoutSection {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: "header",
                                                                     alignment: .top)
        let categoryItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .fractionalHeight(1)))
        categoryItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        let categoryGroup = NSCollectionLayoutGroup
            .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.55),
                                          heightDimension: .fractionalHeight(0.5)),
                        subitems: [categoryItem])
        let categorySection = NSCollectionLayoutSection(group: categoryGroup)
        categorySection.orthogonalScrollingBehavior = .continuous

        categorySection.boundarySupplementaryItems = [headerItem]
        categorySection.contentInsets = .init(top: 20, leading: 10, bottom: 30, trailing: 0)
        return categorySection
    }

    private func sectionForRecommendProducts() -> NSCollectionLayoutSection {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: "header",
                                                                     alignment: .top)

        let recommendItem: NSCollectionLayoutItem
        let recommendGroup: NSCollectionLayoutGroup
        recommendItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1)))
        recommendItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        if homeViewModel.isLoading {
            recommendGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .absolute(200)),
                                         subitems: [recommendItem])
        } else {
            recommendGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.55),
                                                           heightDimension: .absolute(200)),
                                         subitems: [recommendItem])
        }
        let recommendSection = NSCollectionLayoutSection(group: recommendGroup)
        recommendSection.orthogonalScrollingBehavior = .continuous
        recommendSection.boundarySupplementaryItems = [headerItem]
        recommendSection.contentInsets = .init(top: 20, leading: 10, bottom: 0, trailing: 0)
        return recommendSection
    }

    @objc private func moveToSearchView(_ sender: UIButton) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

// MARK: - DiffableDatasource
extension HomeViewController {
    enum Section: Int, CaseIterable {
        case category
        case recommendProduct
    }

    private func configureDatasource() {
        setUpDatasourceForCell()
        setUpDatasourceForSupplementaryView()
    }

    private func setUpDatasourceForCell() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell in
                if let category = item as? ProductCategory,
                   let categoryCell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                         for: indexPath) as? CategoryCell {
                    categoryCell.setUpContents(category: category)
                    return categoryCell
                } else if let product = item as? Product,
                          let recommnedCell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: RecommendProductCell.reuseIdentifier,
                                         for: indexPath) as? RecommendProductCell {
                    if self.homeViewModel.isLoading {
                        recommnedCell.showLoadingIndicator()
                    } else {
                        recommnedCell.setUpContents(product: product)
                    }
                    return recommnedCell
                }
                return UICollectionViewCell()
            }
    }

    private func setUpDatasourceForSupplementaryView() {
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionKind = Section(rawValue: indexPath.section),
                  let header = self.collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: HomeCollectionHeaderView.reuseIdentifier,
                                                  for: indexPath) as? HomeCollectionHeaderView else {
                return UICollectionReusableView()
            }

            switch sectionKind {
            case .category:
                header.setUpContents(section: .category)
            case .recommendProduct:
                header.setUpContents(section: .recommend)
            }
            return header
        }
    }

    private func applyDataSource() {
        guard let products = homeViewModel.products else { return }
        var snapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapShot.appendSections([.category, .recommendProduct])
        snapShot.appendItems(ProductCategory.allCases, toSection: .category)
        snapShot.appendItems(products, toSection: .recommendProduct)
        dataSource.apply(snapShot)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionKind = Section(rawValue: indexPath.section) else { return }

        switch sectionKind {
        case .category:
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
            let category = cell.category
            navigationController?.pushViewController(RankViewController(category: category), animated: true)
        case .recommendProduct:
            guard let cell = collectionView.cellForItem(at: indexPath) as? RecommendProductCell,
                  let product = cell.product else { return }
            navigationController?.pushViewController(ProductDetailViewController(product: product), animated: true)
        }
    }
}
