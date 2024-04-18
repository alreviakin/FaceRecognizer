//
//  Decodable+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import Foundation

public extension Decodable {
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(Self.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}
