//
//  NetworkResponseHandler.swift
//
//
//  Created by alexandr galkin on 15.04.2024.
//

import Foundation

protocol NetworkResponseHandler {
    func handleResponse<T>(response: HTTPURLResponse?, data: Data?) throws -> T where T: Decodable
    func error(for response: HTTPURLResponse?, data: Data?) -> NetworkError?
}

final class NetworkResponseHandlerImpl: NetworkResponseHandler {
    
    private let decoder = JSONDecoder()
    
    func error(for response: HTTPURLResponse?, data: Data?) -> NetworkError? {
        guard let statusCode = response?.statusCode else {
            return .requestError(error: nil)
        }
        
        switch statusCode {
        case 401:
            return .authorizationError
        case 400..<500:
            if let data = data,
                let model = try? decoder.decode(NetworkResponseDto<EmptyDto>.self, from: data),
                let error = model.errors {
                return .requestError(error: error)
            }
            return .requestError(error: NetworkErrorDto(message: "Status code \(statusCode)", code: "\(statusCode)"))
        case 500:
            return .internalServerError
        default:
            break
        }
        return nil
    }
    
    func handleResponse<T>(response: HTTPURLResponse?, data: Data?) throws -> T where T: Decodable {
        
        debugPrint(String(format: "%@ complete %@ %d", NSDate(), response?.url?.path ?? "", response?.statusCode ?? -1))
        
        if let data = data, let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            debugPrint(object)
        }
        
        if let error = error(for: response, data: data) {
            throw error
        }
        
        if let data {
            do {
                return try self.decoder.decode(T.self, from: data)
            } catch {
                throw error
            }
        } else {
            throw NetworkError.requestError(error: nil)
        }
    }
}
