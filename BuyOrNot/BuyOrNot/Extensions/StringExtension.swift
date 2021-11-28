//
//  StringExtension.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/28.
//

import Foundation

extension String {
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else { return self }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}
