//
//  Product.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/26.
//

import Foundation
import RealmSwift

final class Product: Object {
    @Persisted var category: String? = ""
    @Persisted var brand: String = ""
    @Persisted var name: String = ""
    @Persisted var rank: Int? = 0
    @Persisted var image: String? = ""

    override init() {

    }

    init(category: String?, brand: String, name: String, rank: Int?, image: String?) {
        self.category = category
        self.brand = brand
        self.name = name
        self.rank = rank
        self.image = image
    }
}
