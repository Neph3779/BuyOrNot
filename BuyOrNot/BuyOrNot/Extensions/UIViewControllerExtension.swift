//
//  UIViewControllerExtension.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/12/01.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = ColorSet.backgroundColor
        alert.view.tintColor = .black
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}
