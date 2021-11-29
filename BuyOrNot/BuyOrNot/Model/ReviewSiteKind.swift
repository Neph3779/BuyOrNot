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
    case tistory

    var cellColor: UIColor {
        switch self {
        case .youtube:
            return UIColor(red: 211/255, green: 93/255, blue: 110/255, alpha: 1)
        case .naver:
            return UIColor(red: 90/255, green: 164/255, blue: 105/255, alpha: 1)
        case .tistory:
            return UIColor(red: 239/255, green: 176/255, blue: 140/255, alpha: 1)
        }
    }

    var imageName: String {
        switch self {
        case .youtube:
            return "youtubeLogo"
        case .naver:
            return "naverLogo"
        case .tistory:
            return "tistoryLogo"
        }
    }
}
