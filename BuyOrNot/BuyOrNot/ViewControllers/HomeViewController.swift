//
//  HomeViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/21.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private let backgroundColorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.mainThemeColor
        view.layer.cornerRadius = 20
        return view
    }()

    private let outerTableView = UITableView(frame: .zero, style: .grouped)
    private let categoryCollectionView = CategoryCollectionView()
    private let recommendCollectionView = RecommendCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setBackgroundColorView()
        setOuterTableView()
    }

    private func setBackgroundColorView() {
        view.addSubview(backgroundColorView)
        backgroundColorView.snp.makeConstraints { colorView in
            colorView.height.equalTo(view.snp.height).multipliedBy(0.3)
            colorView.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            colorView.top.equalTo(view)
        }
    }

    private func setOuterTableView() {
        outerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "outerTableViewCell")
        outerTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "outerTableViewHeader")
        outerTableView.dataSource = self
        outerTableView.delegate = self
        outerTableView.backgroundColor = .clear
        outerTableView.separatorColor = .clear
        view.addSubview(outerTableView)
        outerTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }

        outerTableView.rowHeight = UITableView.automaticDimension
        outerTableView.estimatedRowHeight = 1000
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = outerTableView.dequeueReusableCell(withIdentifier: "outerTableViewCell") else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        if indexPath.section == 0 {
            cell.setContentView(view: categoryCollectionView)
        } else {
            cell.setContentView(view: recommendCollectionView)
        }

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let cellHeight = ViewSize.categoryCellSize.height
            return (cellHeight + 20) * trunc(CGFloat(ProductCategory.allCases.count / 2))
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
            : .preferredFont(forTextStyle: .title3)

            content.text = section == 0 ? "Category" : "이런 제품은 어떠세요?"
            content.textProperties.color = section == 0 ? .white : .black
            headerView.contentConfiguration = content
        } else {
            headerView.textLabel?.font = section == 0 ? .boldSystemFont(ofSize: 40)
            : .preferredFont(forTextStyle: .title3)

            headerView.textLabel?.text = section == 0 ? "Category" : "이런 제품은 어떠세요?"
            headerView.textLabel?.textColor = section == 0 ? .white : .black
        }

        return headerView
    }
}
