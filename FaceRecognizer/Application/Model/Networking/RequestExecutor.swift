//
//  RequestExecutor.swift
//
//
//  Created by alexandr galkin on 15.04.2024.
//

import Foundation

protocol RequestExecutor {
    func executeWithRetry(request: inout URLRequest, shouldAuthorize: Bool) async throws -> (Data, HTTPURLResponse)
    func execute(request: inout URLRequest, withAuthorize: Bool) async throws -> (Data, HTTPURLResponse)
}

final class RequestExecutorImpl: RequestExecutor {
    private let requestInterceptor: RequestInterceptor
    private let session: URLSession
    private let responseHandler: NetworkResponseHandler
    
    init(requestInterceptor: RequestInterceptor,
         responseHandler: NetworkResponseHandler) {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 30.0
        sessionConfiguration.timeoutIntervalForResource = 60.0
        
        session = URLSession(configuration: sessionConfiguration)
        self.requestInterceptor = requestInterceptor
        self.responseHandler = responseHandler
    }
    
    func execute(request: inout URLRequest, withAuthorize: Bool) async throws -> (Data, HTTPURLResponse) {
        if withAuthorize {
            requestInterceptor.adapt(&request)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.requestError(error: nil)
        }
        
        if let error = responseHandler.error(for: response, data: data) {
            throw error
        }
        
        return (data, response)
    }
    
    func executeWithRetry(request: inout URLRequest, shouldAuthorize: Bool) async throws -> (Data, HTTPURLResponse) {
        do {
            return try await execute(request: &request, withAuthorize: shouldAuthorize)
        } catch let error as NetworkError {
            if try await requestInterceptor.shouldRetry(request: &request, for: error, shouldAuthorize: shouldAuthorize) {
                return try await execute(request: &request, withAuthorize: shouldAuthorize)
            } else {
                throw error
            }
        }
    }
}
