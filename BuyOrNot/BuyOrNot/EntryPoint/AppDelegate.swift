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
            RankManager.shared.refreshRank {
                DispatchQueue.main.async {
                    RankManager.shared.didLoadingEnd = true
                    NotificationCenter.default
                        .post(name: NSNotification.Name("rankedProductsLoadingEnd"), object: nil, userInfo: nil)
                }
            }
        }

        setFetchInterval()

        window = UIWindow()
        let rootViewController = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        RankManager.shared.refreshRank { }
    }

    func setFetchInterval() {
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared
                .register(forTaskWithIdentifier: "com.Neph.BuyOrNot.RankedProduct.fetch", using: nil) { [weak self] task in
                    self?.handleAppRefresh(task: task as! BGAppRefreshTask)
                }
        } else {
            UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(86400))
        }
    }

    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        task.expirationHandler = {
            // Data fetching 취소, 알라모파이어 학습 필요
        }
        RankManager.shared.refreshRank {
            task.setTaskCompleted(success: true)
        }
    }

    func scheduleAppRefresh() {
        if #available(iOS 13.0, *) {
            let request = BGAppRefreshTaskRequest(identifier: "com.Neph.BuyOrNot.RankedProduct.fetch")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 86400)
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                // TODO: Error 처리
            }
        }
    }
}
