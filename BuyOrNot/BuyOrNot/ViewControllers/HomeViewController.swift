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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        return label
    }()

    private let outerTableView = UITableView()
    private let categoryCollectionView = CategoryCollectionView()
    private let recommendCollectionView = RecommendCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setBackgroundColorView()
        setTitleLabel()
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

    private func setTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { label in
            label.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func setOuterTableView() {
        outerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "outerTableViewCell")
        outerTableView.dataSource = self
        outerTableView.delegate = self
        outerTableView.backgroundColor = .clear
        view.addSubview(outerTableView)
        outerTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
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
            let cellWidth = (tableView.safeAreaLayoutGuide.layoutFrame.width - 30) / CGFloat(2)
            let cellHeight = cellWidth * 0.85
            return cellHeight * 3 + 30
        } else {
            return 220
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
}
