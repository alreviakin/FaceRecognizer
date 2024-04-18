//
//  NetworkManager.swift
//
//
//  Created by alexandr galkin on 11.04.2024.
//

import Foundation
import Kingfisher

typealias Response<T> = Result<T, NetworkError> //for legacy compability

protocol NetworkManager {
    func sendRequest<T>(_ request: NetworkRequest) async throws -> T where T: Decodable
    func uploadRequest<T>(_ request: NetworkRequest) async throws -> T where T: Decodable
    func loadImage(
        imagePath: String,
        options: KingfisherOptionsInfo?,
        progressBlock: DownloadProgressBlock?,
        completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?
    )
}

final class NetworkManagerImpl {

    private var requestInterceptor: RequestInterceptor
    private let decoder: JSONDecoder = JSONDecoder()
    private let networkQuery: NetworkQuery
    private let executer: RequestExecutor
    private let responseHandler: NetworkResponseHandler
    
    init(requestInterceptor: RequestInterceptor,
         executer: RequestExecutor,
         nenworkQuery: NetworkQuery,
         responseHandler: NetworkResponseHandler) {
        
        self.requestInterceptor = requestInterceptor
        self.executer = executer
        self.networkQuery = nenworkQuery
        self.responseHandler = responseHandler
        
        self.requestInterceptor.delegate = self
    }
    
    private func sendRequest<T>(_ request: NetworkRequest, asMultipart: Bool) async throws -> T where T: Decodable {
        do {
            var encoding: NetworkQueryEncoding = request.method == .get ? .queryString : .json
            
            if asMultipart {
                encoding = .multipart
            }
            
            var urlRequest = try networkQuery.createRequest(request: request, encoding: encoding)

            let (data, response) = try await executer.executeWithRetry(request: &urlRequest, shouldAuthorize: request.shouldAuthorize)
            
            return try responseHandler.handleResponse(response: response, data: data)
        } catch {
            debugPrint(error)
            throw error
        }
    }
}

extension NetworkManagerImpl: NetworkManager {
    func sendRequest<T>(_ request: NetworkRequest) async throws -> T where T: Decodable {
        return try await sendRequest(request, asMultipart: false)
    }
    
    func uploadRequest<T>(_ request: NetworkRequest) async throws -> T where T: Decodable {
        return try await sendRequest(request, asMultipart: true)
    }
    
    func loadImage(
        imagePath: String,
        options: KingfisherOptionsInfo?,
        progressBlock: DownloadProgressBlock?,
        completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?
    ) {
        guard let url = URL(string: networkQuery.url(for: imagePath)) else { return }
        KingfisherManager.shared.retrieveImage(with: url, options: options, progressBlock: progressBlock, completionHandler: completion)
    }
}

extension NetworkManagerImpl: RequestInterceptorDelegate {
    func refreshToken<T: Decodable>(request: NetworkRequest) async throws -> NetworkResponseDto<T> {
        return try await sendRequest(request)
    }
}
