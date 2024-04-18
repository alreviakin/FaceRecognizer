//
//  NetworkResponseDto.swift
//
//
//  Created by alexandr galkin on 01.03.2024.
//

import Foundation

struct NetworkResponseDto<T: Decodable>: Decodable {
    let success: T?
    let errors: NetworkErrorDto?
    
    private enum Keys: String, CodingKey {
        case success, errors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.success = try container.decode(T.self, forKey: .success)
        self.errors = try? container.decode([NetworkErrorDto].self, forKey: .errors).first
    }
}
