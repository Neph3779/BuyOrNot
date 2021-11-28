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
            return UIColor(red: 255/255, green: 128/255, blue: 128/255, alpha: 1)
        case .naver:
            return UIColor(red: 224/255, green: 245/255, blue: 185/255, alpha: 1)
        case .daum:
            return UIColor(red: 255/255, green: 186/255, blue: 146/255, alpha: 1)
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
