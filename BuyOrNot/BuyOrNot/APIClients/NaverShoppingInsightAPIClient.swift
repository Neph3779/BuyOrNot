//
//  NaverShoppingInsightAPIClient.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation

final class NaverShoppingInsightAPIClient {
    private var url: URL {
        guard let url = URL(string: "https://openapi.naver.com/v1/datalab/shopping/categories") else {
            fatalError("Can not convert shopping insight URL")
        }
        return url
    }

    private var clientId: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
            fatalError("Couldn't find file 'KeyList.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "NaverClientId") as? String else {
            fatalError("Couldn't find 'NaverClientId' in 'APIKeyList.plist'.")
        }
        return value
    }

    private var clientSecret: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
            fatalError("Couldn't find file 'KeyList.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "NaverClientSecret") as? String else {
            fatalError("Couldn't find 'NaverClientSecret' in 'APIKeyList.plist'.")
        }
        return value
    }

    // date formatting 필요
    // category 파라미터를 위한 parsing model 제작 필요
}
