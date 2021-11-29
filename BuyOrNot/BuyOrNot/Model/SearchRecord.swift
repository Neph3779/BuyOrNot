//
//  SearchRecord.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/29.
//

import Foundation
import RealmSwift

class SearchRecord: Object {
    @Persisted var title: String? = ""
    @Persisted var date: Date = Date()

    override init() {

    }

    init(title: String?) {
        self.title = title
        self.date = Date()
    }
}
