//
//  SearchViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import UIKit
import Alamofire

final class SearchViewController: UIViewController {
    private let backButtonImageView = UIImageView()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.backgroundColor
        setNavigationItems()
        setSearchBar()
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
