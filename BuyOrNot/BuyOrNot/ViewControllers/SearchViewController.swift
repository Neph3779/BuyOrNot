//
//  SearchViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import UIKit
import Alamofire

// TODO: 검색 기록 저장 구현
final class SearchViewController: UIViewController {
    private let backButtonImageView = UIImageView()
    private let searchBar = UISearchBar()
    private let searchRecordTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.backgroundColor
        setNavigationItems()
        setSearchBar()
        setSearchRecordTableView()
    }

    private func setNavigationItems() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "arrow.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow.backward")
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .darkGray
        navigationItem.titleView = searchBar
    }

    private func setSearchBar() {
        searchBar.placeholder = "제품명 검색"
        searchBar.delegate = self
    }

    private func setSearchRecordTableView() {
        searchRecordTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchRecordTableViewCell")
        searchRecordTableView.register(UITableViewHeaderFooterView.self,
                                       forHeaderFooterViewReuseIdentifier: "searchRecordTableHeaderView")
        searchRecordTableView.dataSource = self
        searchRecordTableView.delegate = self
        view.addSubview(searchRecordTableView)
        searchRecordTableView.snp.makeConstraints { $0.edges.equalTo(view) }
    }

    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "에러가 발생했어요 😫", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let seartchText = searchBar.text else { return }
        NaverSearchAPIClient.shared
            .fetchNaverShoppingResults(query: seartchText) { (response: DataResponse<NaverShoppingResult, AFError>) in
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
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchRecordTableViewCell") else {
            return UITableViewCell()
        }

        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = "아이폰13"
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = "아이폰13"
        }
        cell.accessoryView = UIImageView(image: UIImage(named: "xmark"))
        cell.accessoryView?.tintColor = .darkGray

        return cell
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
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let product = Product(category: nil, brand: <#T##String#>, name: <#T##String#>, rank: <#T##Int?#>, image: <#T##String?#>)
    }
}
