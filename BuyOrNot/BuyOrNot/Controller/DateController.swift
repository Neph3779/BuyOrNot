//
//  DateController.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/12/07.
//

import Foundation

final class DateController {
    static let shared = DateController()

    private init() {}

    func isDateNotOver() -> Bool {
        let dateComponent = DateComponents(year: 2021, month: 12, day: 8, hour: 18)
        guard let date = Calendar.current.date(from: dateComponent) else { return false }

        return Date() < date ? true : false
    }
}
