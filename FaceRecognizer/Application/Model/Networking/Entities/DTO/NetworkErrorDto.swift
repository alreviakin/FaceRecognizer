//
//  NetworkErrorDto.swift
//
//
//  Created by alexandr galkin on 01.03.2024.
//

import Foundation

struct NetworkErrorDto: Decodable, Error {
    
    // MARK: - Private Properties
    
    private enum CodingKeys: String, CodingKey {
        case message, code
    }
    
    // MARK: - Public Properties
    
    let message: String
    let code: String
    
    // MARK: - Initializer
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
    }
    
    init(message: String, code: String) {
        self.code = code
        self.message = message
    }
}
