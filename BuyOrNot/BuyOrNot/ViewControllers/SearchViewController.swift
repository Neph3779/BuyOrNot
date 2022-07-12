//
//  SearchViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import UIKit
import Alamofire
import RealmSwift

final class SearchViewController: UIViewController {
    private var records = [SearchRecord]()
    private let backButtonImageView = UIImageView()
    private let searchBar = UISearchBar()
    private let searchRecordTableView = UITableView()
    private var relatedSearchProducts: [Product] {
        let searchText = searchBar.text?.lowercased() ?? ""
        return try! Realm().objects(Product.self).filter {
            $0.name.lowercased().contains(searchText) || $0.brand.lowercased().contains(searchText)
        }.sorted {
            $0.name < $1.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.backgroundColor
        setbackButtonImageView()
        setSearchBar()
        setSearchRecordTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchBar.text?.removeAll()
        fetchRecords()
        searchRecordTableView.reloadData()
    }

    private func fetchRecords() {
        records = Array(try! Realm().objects(SearchRecord.self)
                            .sorted(byKeyPath: "date", ascending: false))
    }

    private func setbackButtonImageView() {
        backButtonImageView.image = UIImage(named: "arrow.backward")
        backButtonImageView.tintColor = .darkGray
        backButtonImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(popView(_:)))
        backButtonImageView.addGestureRecognizer(gesture)
        view.addSubview(backButtonImageView)
        backButtonImageView.snp.makeConstraints { imageView in
            imageView.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.width.height.equalTo(30)
        }
    }

    private func setSearchBar() {
        searchBar.placeholder = "제품명 검색"
        searchBar.delegate = self
        searchBar.barTintColor = ColorSet.backgroundColor
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { searchBar in
            searchBar.leading.equalTo(backButtonImageView.snp.trailing)
            searchBar.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        backButtonImageView.snp.makeConstraints { imageView in
            imageView.centerY.equalTo(searchBar.snp.centerY)
        }
    }

    private func setSearchRecordTableView() {
        searchRecordTableView.register(SearchRecordTableViewCell.self,
                                       forCellReuseIdentifier: SearchRecordTableViewCell.reuseIdentifier)
        searchRecordTableView.register(UITableViewHeaderFooterView.self,
                                       forHeaderFooterViewReuseIdentifier: "searchRecordTableHeaderView")
        searchRecordTableView.dataSource = self
        searchRecordTableView.delegate = self
        searchRecordTableView.backgroundColor = ColorSet.backgroundColor
        view.addSubview(searchRecordTableView)
        searchRecordTableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(searchBar.snp.bottom)
            tableView.leading.trailing.bottom.equalTo(view)

        }
    }

    private func moveToProductView(with searchText: String) {
        NaverSearchAPIClient.shared
            .fetchNaverShoppingResults(query: searchText) { [weak self]
                (response: DataResponse<NaverShoppingResult, AFError>) in
                guard let self = self else { return }
                do {
                    guard let data = response.data else {
                        self.presentErrorAlert(title: "검색 실패", message: "검색에 실패했어요😫\n통신 상태를 확인해주세요")
                        return
                    }
                    let naverShoppingResult = try JSONDecoder().decode(NaverShoppingResult.self, from: data)

                    if let firstItem = naverShoppingResult.items.first {
                        let product = Product(category: nil, brand: firstItem.brand.htmlEscaped,
                                              name: firstItem.name.htmlEscaped, rank: nil, image: nil)
                        self.navigationController?
                            .pushViewController(ProductDetailViewController(product: product), animated: true)
                    } else {
                        self.presentErrorAlert(title: "상품없음", message: "검색하신 상품을 찾을 수 없어요😫\n상품명을 다시 확인해주세요!")
                    }
                } catch {
                    self.presentErrorAlert(title: "상품 데이터 변환 실패", message: "상품 데이터를 변환하는데 실패했어요 😫")
                }
            }
    }

    @objc private func popView(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        try! Realm().write({
            try! Realm().add(SearchRecord(title: self.searchBar.text))
        })
        guard let searchText = searchBar.text else { return }
        moveToProductView(with: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchRecordTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchText = searchBar.text ?? ""
        if searchText.isEmpty {
            return try! Realm().objects(SearchRecord.self).count
        } else {
            return relatedSearchProducts.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: SearchRecordTableViewCell.reuseIdentifier)
                as? SearchRecordTableViewCell else { return UITableViewCell() }
        let searchText = searchBar.text ?? ""

        if searchText.isEmpty {
            let recordTitle = try! Realm().objects(SearchRecord.self).map { $0.title }[indexPath.row] ?? ""
            cell.setTitleLabelText(title: recordTitle)
            cell.indexPath = indexPath
            cell.searchRecordTableViewCellDelegate = self
        } else {
            let product = relatedSearchProducts[indexPath.row]
            cell.setTitleLabelText(title: product.name)
        }

        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = searchRecordTableView.cellForRow(at: indexPath) as? SearchRecordTableViewCell,
              let searchText = cell.titleLabel.text else { return }
        try! Realm().write({
            try! Realm().add(SearchRecord(title: searchText))
        })
        moveToProductView(with: searchText)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: "searchRecordTableHeaderView") else { return UIView() }
        headerView.backgroundView = UIView(frame: headerView.bounds)
        headerView.backgroundView?.backgroundColor = ColorSet.backgroundColor

        if #available(iOS 14.0, *) {
            var content = headerView.defaultContentConfiguration()
            content.text = "최근 검색어"
            headerView.contentConfiguration = content
        } else {
            headerView.textLabel?.text = "최근 검색어"
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SearchViewController: SearchRecordTableViewCellDelegate {
    func removeCell(indexPath: IndexPath) {
        try! Realm().write {
            try! Realm().delete(records[indexPath.row])
        }
        records.remove(at: indexPath.row)
        searchRecordTableView.reloadData()
    }
}
