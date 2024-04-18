//
//  NetworkError.swift
//
//
//  Created by alexandr galkin on 01.03.2024.
//

import Foundation

enum NetworkError: Error {
    case internetNotReachable
    case internalServerError
    case serializableError(String?)
    case requestError(error: NetworkErrorDto?)
    case authorizationError
    
    var localizedDescription: String {
        switch self {
        case .internetNotReachable:
            return "Your device is not connected to the Internet. Please check connection and try again."
        case .internalServerError:
            return "Internal server error"
        case .serializableError:
            return "Data serializable error"
        case .requestError(let error):
            return error?.message ?? "Unknown error"
        case .authorizationError:
            return "Token is invalid or expired"
        }
    }
}
