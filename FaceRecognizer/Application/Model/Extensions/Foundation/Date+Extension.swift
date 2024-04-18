//
//  Date+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import Foundation

public extension Date {
    var startOfWeek: Date? {
        guard let sunday = Calendar
            .current
            .date(from: Calendar
                .current
                .dateComponents([.yearForWeekOfYear, .weekOfYear],
                                from: self)) else {
            return nil
        }
        return Calendar.current.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        guard let sunday = Calendar
            .current
            .date(from: Calendar
                .current
                .dateComponents([.yearForWeekOfYear, .weekOfYear],
                                from: self)) else {
            return nil
        }
        return Calendar.current.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func agoForward(to days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func add(years: Int = 0,
             months: Int = 0,
             days: Int = 0,
             hours: Int = 0,
             minutes: Int = 0,
             seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years,
                                        month: months,
                                        day: days,
                                        hour: hours,
                                        minute: minutes,
                                        second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    func formatted(with format: String = "yyyy-MM-dd'T'HH:mm:ssZ", locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self)
    }
}
