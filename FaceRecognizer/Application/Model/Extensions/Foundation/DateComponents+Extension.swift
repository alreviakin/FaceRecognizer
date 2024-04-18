//
//  DateComponents+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import Foundation

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        let now = Date()
        guard let leftDate = Calendar.current.date(byAdding: lhs, to: now),
              let rightDate = Calendar.current.date(byAdding: rhs, to: now) else { return false }
        
        return leftDate < rightDate
    }
}
