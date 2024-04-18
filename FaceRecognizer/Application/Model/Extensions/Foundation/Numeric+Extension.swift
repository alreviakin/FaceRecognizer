//
//  Numeric+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 16.04.2024.
//

import Foundation

public extension Numeric {
    func asString() -> String {
        String(describing: self)
    }
    
    func formattedWithSeparator(_ separator: String = " ") -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? String(describing: self)
    }
}

public extension Numeric where Self: BinaryInteger {
    func asDouble() -> Double {
        Double(self)
    }
}

public extension Numeric where Self: BinaryFloatingPoint {
    func asInt() -> Int {
        Int(self)
    }
}
