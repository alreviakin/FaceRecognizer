//
//  File.swift
//  
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import Foundation

public extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int? {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day
    }
}
