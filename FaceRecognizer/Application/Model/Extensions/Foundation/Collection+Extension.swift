//
//  Collection+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 16.04.2024.
//

import Foundation

public extension Collection where Element: Numeric {
    func sum() -> Element {
        reduce(0, +)
    }
}

public extension Collection {
    subscript(safe index: Self.Index) -> Iterator.Element? {
        getValue(at: index)
    }
    
    func getValue(at index: Self.Index) -> Iterator.Element? {
        (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
