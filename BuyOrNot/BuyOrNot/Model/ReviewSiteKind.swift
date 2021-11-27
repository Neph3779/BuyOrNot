//
//  ReviewSiteKind.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/28.
//

import Foundation
import UIKit

enum ReviewSiteKind {
    case youtube
    case naver
    case daum

    var cellColor: UIColor {
        switch self {
        case .youtube:
            return UIColor(red: 253/255, green: 94/255, blue: 83/255, alpha: 1)
        case .naver:
            return UIColor(red: 33/255, green: 191/255, blue: 115/255, alpha: 1)
        case .daum:
            return UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
        }
    }

    var imageName: String {
        switch self {
        case .youtube:
            return "youtubeLogo"
        case .naver:
            return "naverLogo"
        case .daum:
            return "tistoryLogo"
        }
    }
}
