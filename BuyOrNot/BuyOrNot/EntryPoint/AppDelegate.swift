//
//  AppDelegate.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/17.
//

import UIKit
import RealmSwift
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if try! Realm().objects(Product.self).isEmpty {
            RankManager.shared.refreshRank()
        }

        window = UIWindow()
        let rootViewController = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}
