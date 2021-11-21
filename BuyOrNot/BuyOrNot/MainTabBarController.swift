//
//  ViewController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/17.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let homeViewController: UINavigationController = {
        let viewController = UINavigationController(rootViewController: HomeViewController())
        viewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "house"), tag: 0)
        return viewController
    }()

    private let searchViewController: UINavigationController = {
        let viewController = UINavigationController(rootViewController: SearchViewController())
        viewController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "search"), tag: 1)
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewControllers = [homeViewController, searchViewController]
    }
}
