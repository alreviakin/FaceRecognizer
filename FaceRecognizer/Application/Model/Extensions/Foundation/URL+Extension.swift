//
//  URL+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import Foundation

public extension URL {
    init?(string: String?) {
        guard let string else { return nil }
        self.init(string: string)
    }
}
