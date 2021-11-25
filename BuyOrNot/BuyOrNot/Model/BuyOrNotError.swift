//
//  URLExtension.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/22.
//

import Foundation

enum BuyOrNotError: Error {
    case urlConvertFailed(error: URLConvertError)
}

enum URLConvertError: Error {
    case danawa(error: String)
    case naver(error: String)
    case youtube(error: String)
}
