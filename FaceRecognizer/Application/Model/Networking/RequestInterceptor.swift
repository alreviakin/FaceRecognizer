//
//  RequestInterceptor.swift
//
//
//  Created by alexandr galkin on 12.04.2024.
//

import Foundation

protocol RequestInterceptorDelegate: AnyObject {
    /// ## Example of generic structure
    /// ```
    /// func refreshToken(request: NetworkRequest) async throws -> NetworkResponseDto<UpdateAccessTokenDto>
    /// ```
    func refreshToken<T: Decodable>(request: NetworkRequest) async throws -> NetworkResponseDto<T>
}

protocol RequestInterceptor {
    var delegate: RequestInterceptorDelegate? { get set }
    func adapt(_ urlRequest: inout URLRequest)
    func shouldRetry(request: inout URLRequest, for error: NetworkError, shouldAuthorize: Bool) async throws -> Bool
}

final class RequestInterceptorImpl {
    
    private enum AuthorizationStatus {
        case unauthorized
        case authorized
    }
    
    weak var delegate: RequestInterceptorDelegate?

    // MARK: - Private Properties
    
    private var authorizationStatus: AuthorizationStatus = .unauthorized
    private let semaphore = AsyncSemaphore(value: 1)
    
    /// ## Example of sendRefresh
    /// ```
    /// private func sendRefresh(with refreshToken: String) async throws -> NetworkResponseDto<UpdateAccessTokenDto>? {
    ///     let refreshRequest = NetworkRequest(
    ///         path: APIPath.refreshToken.rawValue,
    ///         method: .post,
    ///         shouldAuthorize: false,
    ///         parameters: [
    ///             "refreshToken": refreshToken
    ///         ]
    ///     )
    ///
    ///     return try await delegate?.refreshToken(request: refreshRequest)
    /// }
    /// ```
    private func sendRefresh<T: Decodable>(with refreshToken: String) async throws -> NetworkResponseDto<T>? {
        return nil
    }
    
    /// ## Example
    /// ```
    /// private func logout() {
    ///     authorizationStatus = .unauthorized
    ///     profileManager.logout()
    /// }
    /// ```
    private func logout() {
        authorizationStatus = .unauthorized
    }
    
    /// ## Example
    /// ```
    /// private func applyNewAccessToken(_ token: String) {
    ///     self.profileManager.updateToken(accessToken: token)
    ///     self.authorizationStatus = .authorized
    /// }
    /// ```
    private func applyNewAccessToken(_ token: String) {
        self.authorizationStatus = .authorized
    }
}

extension RequestInterceptorImpl: RequestInterceptor {
    /// ## Example
    /// ```
    /// func shouldRetry(request: inout URLRequest, for error: NetworkError, shouldAuthorize: Bool) async throws -> Bool {
    ///     guard case .authorizationError = error, shouldAuthorize else { return false }
    ///
    ///     authorizationStatus = .unauthorized
    ///
    ///     do {
    ///         try await semaphore.waitUnlessCancelled()
    ///         defer { semaphore.signal() }
    ///
    ///         if authorizationStatus == .unauthorized,
    ///            let token = profileManager.state.refreshToken {
    ///             let response = try await sendRefresh(with: token)
    ///             if let success = response?.success {
    ///                 applyNewAccessToken(success.accessToken)
    ///             } else {
    ///                 logout()
    ///                 return false
    ///             }
    ///         }
    ///     } catch {
    ///         logout()
    ///         return false
    ///     }
    ///
    ///     return true
    /// }
    /// ```
    func shouldRetry(request: inout URLRequest, for error: NetworkError, shouldAuthorize: Bool) async throws -> Bool {
        return false
    }
    
    /// ## Example
    /// ```
    /// func adapt(_ urlRequest: inout URLRequest) {
    ///     if let accessToken = profileManager.state.accessToken {
    ///         urlRequest.setValue(NetworkQueryHeaderValue.bearerHeader(accessToken).value, forHTTPHeaderField: NetworkQueryHeaderType.authorization.rawValue)
    ///     }
    /// }
    /// ```
    func adapt(_ urlRequest: inout URLRequest) {
        
    }
}
