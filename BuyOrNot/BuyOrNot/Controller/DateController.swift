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
        guard let reviewRequestDate = DateComponents(year: 2021, month: 12, day: 8, hour: 18).date,
              let showOtherCompanyDate = Calendar.current.date(byAdding: .day, value: 3, to: reviewRequestDate) else {
            return false
        }

        return Date() < showOtherCompanyDate
    }
}
