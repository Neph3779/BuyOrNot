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
    private let searchIcon = UIImageView().then {
        $0.image = UIImage(named: "search")
        $0.tintColor = .darkGray
        $0.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: HomeViewController.self, action: #selector(moveToSearchView(_:)))
        $0.addGestureRecognizer(gesture)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout()).then {
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        $0.register(RecommendProductCell.self, forCellWithReuseIdentifier: RecommendProductCell.reuseIdentifier)
        $0.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: "header",
                    withReuseIdentifier: HomeCollectionHeaderView.reuseIdentifier)
//        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
    }
    private let loadingIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        view.backgroundColor = ColorSet.backgroundColor
        layout()
        addNotificationObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    private func layout() {
        view.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { imageView in
            imageView.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            imageView.width.height.equalTo(30)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { collection in
            collection.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            collection.top.equalTo(searchIcon.snp.bottom).offset(10)
        }
    }

    private func compositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            if section == 0 {
                let categoryItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                                            heightDimension: .fractionalHeight(1)))
                categoryItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
                let categoryGroup = NSCollectionLayoutGroup
                    .horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                   heightDimension: .fractionalHeight(0.6)),
                                subitems: [categoryItem])
                let categorySection = NSCollectionLayoutSection(group: categoryGroup)
                categorySection.orthogonalScrollingBehavior = .continuous
                categorySection.contentInsets = .init(top: 10, leading: 0, bottom: 50, trailing: 0)

                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(100))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                             elementKind: "header",
                                                                             alignment: .top)

                categorySection.boundarySupplementaryItems = [headerItem]

                return categorySection
            } else {
                let recommendItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(200),
                                                                             heightDimension: .absolute(200)))
                recommendItem.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
                let recommendGroup = NSCollectionLayoutGroup
                    .horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                   heightDimension: .fractionalHeight(0.4)),
                                subitems: [recommendItem])
                let recommendSection = NSCollectionLayoutSection(group: recommendGroup)
                recommendSection.orthogonalScrollingBehavior = .continuous
                recommendSection.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(100))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                             elementKind: "header",
                                                                             alignment: .top)
                recommendSection.boundarySupplementaryItems = [headerItem]
                return recommendSection
            }
        }
    }

    @objc private func moveToSearchView(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    private func setLoadingIndicator(cell: UITableViewCell) {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        cell.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { indicator in
            indicator.center.equalTo(cell.snp.center)
            indicator.width.height.equalTo(200)
        }
        if Array(try! Realm().objects(Product.self)).isEmpty {
            loadingIndicator.startAnimating()
        }
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
        }
    }

    @objc func didDeleteAllEnd(_ notification: Notification) {
        DispatchQueue.main.async {
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
            return 20
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: RecommendProductCell.reuseIdentifier, for: indexPath)
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
}
