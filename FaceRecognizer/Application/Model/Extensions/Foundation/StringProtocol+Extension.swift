//
//  StringProtocol+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import Foundation

public extension StringProtocol {
    func capitalizedFirst() -> String {
        self.prefix(1).uppercased() +
        self.lowercased().dropFirst()
    }
}
