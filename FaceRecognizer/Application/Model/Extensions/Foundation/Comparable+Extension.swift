//
//  Comparable+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 16.04.2024.
//

import Foundation

public extension Comparable {
    func clamped(range: ClosedRange<Self>) -> Self {
        return max(range.lowerBound, min(self, range.upperBound))
    }
    
    func clamped(lowerBound: Self) -> Self {
        return max(lowerBound, self)
    }
    
    func clamped(upperBound: Self) -> Self {
        return min(self, upperBound)
    }
}
