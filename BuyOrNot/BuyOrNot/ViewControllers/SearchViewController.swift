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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.backgroundColor
        setbackButtonImageView()
        setSearchBar()
        setSearchRecordTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchRecords()
        searchBar.text = ""
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

    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "에러가 발생했어요 😫", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
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
        NaverSearchAPIClient.shared
            .fetchNaverShoppingResults(query: searchText) { (response: DataResponse<NaverShoppingResult, AFError>) in
                do {
                    if let data = response.data {
                        let naverShoppingResult = try JSONDecoder().decode(NaverShoppingResult.self, from: data)
                        let item = naverShoppingResult.items[0]
                        let product = Product(category: nil, brand: item.brand.htmlEscaped,
                                              name: item.name.htmlEscaped, rank: nil, image: nil)
                        self.navigationController?
                            .pushViewController(ProductDetailViewController(product: product), animated: true)
                    }
                } catch {
                    self.presentErrorAlert()
                }
            }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        try! Realm().objects(SearchRecord.self).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchRecordTableViewCell.reuseIdentifier)
                as? SearchRecordTableViewCell,
              let title = records[indexPath.row].title else { return UITableViewCell() }
        cell.setTitleLabelText(title: title)
        cell.indexPath = indexPath
        cell.searchRecordTableViewCellDelegate = self
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = searchRecordTableView.cellForRow(at: indexPath) as? SearchRecordTableViewCell,
              let searchText = cell.titleLabel.text else { return }

        NaverSearchAPIClient.shared
            .fetchNaverShoppingResults(query: searchText) { (response: DataResponse<NaverShoppingResult, AFError>) in
                do {
                    if let data = response.data {
                        let naverShoppingResult = try JSONDecoder().decode(NaverShoppingResult.self, from: data)
                        let item = naverShoppingResult.items[0]
                        let product = Product(category: nil, brand: item.brand.htmlEscaped,
                                              name: item.name.htmlEscaped, rank: nil, image: nil)
                        self.navigationController?
                            .pushViewController(ProductDetailViewController(product: product), animated: true)
                    }
                } catch {
                    self.presentErrorAlert()
                }
            }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView
                .dequeueReusableHeaderFooterView(withIdentifier: "searchRecordTableHeaderView") else { return UIView() }

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
