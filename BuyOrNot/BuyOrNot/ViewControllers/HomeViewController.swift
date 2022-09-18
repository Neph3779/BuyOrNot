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
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemWrapper>!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        layout()
        configureDatasource()
        applyDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        if let categoryHighlightedIndex = homeViewModel.highlightedIndexPathForCategoryCell,
        let cell = collectionView.cellForItem(at: categoryHighlightedIndex) as? CategoryCell {
            cell.selectMask.isHidden = true
        } else if let recommendHighlightedIndex = homeViewModel.highlightedIndexPathForRecommendProductCell,
                  let cell = collectionView.cellForItem(at: recommendHighlightedIndex) as? RecommendProductCell {
            cell.selectMask.isHidden = true
        }
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

    enum ItemWrapper: Hashable {
        case category(ProductCategory)
        case product(Product)
    }

    private func configureDatasource() {
        setUpDatasourceForCell()
        setUpDatasourceForSupplementaryView()
    }

    private func setUpDatasourceForCell() {
        dataSource = UICollectionViewDiffableDataSource<Section, ItemWrapper>(
            collectionView: collectionView) { (collectionView, indexPath, itemWrapper) -> UICollectionViewCell in
                if case let .category(category) = itemWrapper,
                   let categoryCell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                         for: indexPath) as? CategoryCell {
                    categoryCell.setUpContents(category: category)
                    return categoryCell
                }

                if case let .product(product) = itemWrapper,
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
        var snapShot = NSDiffableDataSourceSnapshot<Section, ItemWrapper>()
        snapShot.appendSections([.category, .recommendProduct])
        ProductCategory.allCases.forEach {
            snapShot.appendItems([.category($0)], toSection: .category)
        }
        products.forEach {
            snapShot.appendItems([.product($0)], toSection: .recommendProduct)
        }
        dataSource.apply(snapShot)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .category(let category):
            navigationController?.pushViewController(RankViewController(category: category), animated: true)
        case .product(let product):
            navigationController?.pushViewController(ProductDetailViewController(product: product), animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            homeViewModel.highlightedIndexPathForCategoryCell = indexPath
            cell.selectMask.isHidden = false
        } else if let cell = collectionView.cellForItem(at: indexPath) as? RecommendProductCell {
            homeViewModel.highlightedIndexPathForRecommendProductCell = indexPath
            cell.selectMask.isHidden = false
        }
    }
}
