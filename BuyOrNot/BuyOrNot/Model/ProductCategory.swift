//
//  ProductRank.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import UIKit

enum ProductCategory: String, CaseIterable {
    case phone = "phone"
    case keyboard = "keyboard"
    case monitor = "monitor"
    case spaeker = "speaker"
    case tablet = "tablet"
    case smartWatch = "smartWatch"

    var name: String {
        switch self {
        case .phone:
            return "Phone"
        case .keyboard:
            return "Keyboard"
        case .monitor:
            return "Monitor"
        case .spaeker:
            return "Speaker"
        case .tablet:
            return "Tablet"
        case .smartWatch:
            return "Smart Watch"
        }
    }

    var image: String {
        switch self {
        case .phone:
            return "phoneCategoryImage"
        case .keyboard:
            return "keyboardCategoryImage"
        case .monitor:
            return "monitorCategoryImage"
        case .spaeker:
            return "speakerCategoryImage"
        case .tablet:
            return "tabletCategoryImage"
        case .smartWatch:
            return "smartWatchCategoryImage"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .phone:
            return UIColor(red: 236/255, green: 223/255, blue: 200/255, alpha: 0.7)
        case .keyboard:
            return UIColor(red: 110/255, green: 190/255, blue: 194/255, alpha: 0.7)
        case .monitor:
            return UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 0.7)
        case .spaeker:
            return UIColor(red: 98/255, green: 77/255, blue: 67/255, alpha: 0.7)
        case .tablet:
            return UIColor(red: 172/255, green: 221/255, blue: 240/255, alpha: 0.7)
        case .smartWatch:
            return UIColor(red: 143/255, green: 97/255, blue: 60/255, alpha: 0.7)
        }
    }
}
