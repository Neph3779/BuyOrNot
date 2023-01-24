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

    func shouldShowItsProductOnly() -> Bool {
        guard let reviewRequestDate = DateComponents(calendar: Calendar.current, year: 2023, month: 1, day: 25, hour: 12).date,
              let showOtherCompanyDate = Calendar.current.date(byAdding: .day, value: 3, to: reviewRequestDate) else {
            return false
        }
        return Date() < showOtherCompanyDate
    }
}
