//
//  RankViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import UIKit
import SnapKit
import RealmSwift

final class RankViewController: UIViewController {
    private var category: ProductCategory
    private var products = [Product]()
    private let categoryView = UIImageView()
    private let rankCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let backButtonImageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView()
    private let forceRefreshButtonImageView = UIImageView()

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
        view.backgroundColor = ColorSet.backgroundColor
        navigationController?.navigationBar.isHidden = true
        setProducts()
        setCategoryView()
        setRankColletionView()
        setbackButtonImageView()
        setLoadingIndicator()
        setForceRefreshButton()
        addNotificationObserver()
    }

    private func setProducts() {
        if DateController.shared.shouldShowItsProductOnly() {
            products = Array(try! Realm().objects(Product.self)
                .filter { $0.category == self.category.rawValue && $0.brand == "APPLE" })
        } else {
            products = Array(try! Realm().objects(Product.self).filter { $0.category == self.category.rawValue })
        }
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
        rankCollectionView.backgroundColor = ColorSet.backgroundColor

        view.addSubview(rankCollectionView)
        rankCollectionView.snp.makeConstraints { tableView in
            tableView.leading.trailing.bottom.equalTo(view)
            tableView.top.equalTo(categoryView.snp.bottom)
        }
    }

    private func setbackButtonImageView() {
        backButtonImageView.image = UIImage(named: "arrow.backward")
        backButtonImageView.tintColor = .white
        backButtonImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(popView(_:)))
        backButtonImageView.addGestureRecognizer(gesture)
        view.addSubview(backButtonImageView)
        backButtonImageView.snp.makeConstraints { imageView in
            imageView.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.width.height.equalTo(30)
        }
    }

    private func setLoadingIndicator() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { indicator in
            indicator.center.equalTo(rankCollectionView.snp.center)
        }
        if Array(try! Realm().objects(Product.self)
            .filter { $0.category == self.category.rawValue }).isEmpty {
            loadingIndicator.startAnimating()
        }
    }

    private func setForceRefreshButton() {
        forceRefreshButtonImageView.image = UIImage(named: "arrow.clockwise")
        forceRefreshButtonImageView.tintColor = .white
        forceRefreshButtonImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(refreshRank(_:)))
        forceRefreshButtonImageView.addGestureRecognizer(gesture)
        view.addSubview(forceRefreshButtonImageView)
        forceRefreshButtonImageView.snp.makeConstraints { button in
            button.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            button.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            button.width.height.equalTo(30)
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

    @objc private func popView(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didLoadingEnd(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setProducts()
            self.loadingIndicator.stopAnimating()
            self.rankCollectionView.reloadData()
        }
    }

    @objc func didDeleteAllEnd(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setProducts()
            self.rankCollectionView.reloadData()
            self.loadingIndicator.startAnimating()
        }
    }

    @objc private func refreshRank(_ sender: UITapGestureRecognizer) {
        RankManager.shared.refreshRank()
    }
}

extension RankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankCollectionViewCell.reuseidentifier,
                                                            for: indexPath) as? RankCollectionViewCell else {
                  return UICollectionViewCell()
              }

        cell.setContents(product: products[indexPath.row])

        return cell
    }
}

extension RankViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RankCollectionViewCell,
              let product = cell.product else { return }

        navigationController?.pushViewController(ProductDetailViewController(product: product), animated: true)
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
