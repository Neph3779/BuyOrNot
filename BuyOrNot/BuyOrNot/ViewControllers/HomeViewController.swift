//
//  HomeViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let searchIcon = UIImageView()
    private let outerTableView = UITableView(frame: .zero, style: .grouped)
    private let categoryCollectionView = CategoryCollectionView()
    private let recommendCollectionView = RecommendCollectionView()
    private let loadingIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.backgroundColor
        navigationController?.navigationBar.isHidden = true
        setSearchIcon()
        setOuterTableView()
        addNotificationObserver()
    }

    private func setSearchIcon() {
        searchIcon.image = UIImage(named: "search")
        searchIcon.tintColor = .darkGray
        searchIcon.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToSearchView(_:)))
        searchIcon.addGestureRecognizer(gesture)
        view.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { imageView in
            imageView.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            imageView.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            imageView.width.height.equalTo(30)
        }
    }

    @objc private func moveToSearchView(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    private func setOuterTableView() {
        outerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "outerTableViewCell")
        outerTableView.register(UITableViewHeaderFooterView.self,
                                forHeaderFooterViewReuseIdentifier: "outerTableViewHeader")
        outerTableView.dataSource = self
        outerTableView.delegate = self
        outerTableView.backgroundColor = .clear
        outerTableView.separatorColor = .clear

        view.addSubview(outerTableView)
        outerTableView.snp.makeConstraints { tableView in
            tableView.top.equalTo(searchIcon.snp.bottom).offset(10)
            tableView.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setLoadingIndicator(cell: UITableViewCell) {
        if RankManager.shared.didLoadingEnd == false {
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            cell.addSubview(loadingIndicator)
            loadingIndicator.snp.makeConstraints { indicator in
                indicator.center.equalTo(cell.snp.center)
                indicator.width.height.equalTo(200)
            }
            loadingIndicator.startAnimating()
        }
    }

    private func addNotificationObserver() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(didLoadingEnd(_:)),
                         name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil)
    }

    @objc func didLoadingEnd(_ notification: Notification) {
        loadingIndicator.stopAnimating()
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = outerTableView.dequeueReusableCell(withIdentifier: "outerTableViewCell") else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        if indexPath.section == 0 {
            cell.setContentView(view: categoryCollectionView)
        } else if indexPath.section == 1 {
            cell.setContentView(view: recommendCollectionView)
        }

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let cellHeight = ViewSize.categoryCellSize.height
            return cellHeight + 20
        } else {
            let cellHeight = ViewSize.recommendCellSize.height
            return cellHeight + 20
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "outerTableViewHeader") else {
            return UIView()
        }

        if #available(iOS 14.0, *) {
            var content = headerView.defaultContentConfiguration()
            content.textProperties.font = section == 0 ? .boldSystemFont(ofSize: 40)
            : .boldSystemFont(ofSize: 18)

            content.text = section == 0 ? "Category" : "이런 제품은 어떠세요?"
            content.textProperties.color = .darkGray
            headerView.contentConfiguration = content
        } else {
            headerView.textLabel?.font = section == 0 ? .boldSystemFont(ofSize: 40)
            : .boldSystemFont(ofSize: 18)

            headerView.textLabel?.text = section == 0 ? "Category" : "이런 제품은 어떠세요?"
            headerView.textLabel?.textColor = .darkGray
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 1) {
            setLoadingIndicator(cell: cell)
        }
    }
}
