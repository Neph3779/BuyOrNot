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
            return UIColor(red: 129/255, green: 0/255, blue: 0/255, alpha: 1)
        case .naver:
            return UIColor(red: 6/255, green: 68/255, blue: 32/255, alpha: 1)
        case .tistory:
            return UIColor(red: 59/255, green: 40/255, blue: 23/255, alpha: 1)
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
