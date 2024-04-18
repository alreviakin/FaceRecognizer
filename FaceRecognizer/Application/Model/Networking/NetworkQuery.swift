//
//  NetworkQuery.swift
//
//
//  Created by alexandr galkin on 15.04.2024.
//

import Foundation

enum NetworkQueryEncoding {
    case json
    case queryString
    case multipart
}

enum NetworkQueryErrorReason: Error {
    case invalidJsonObject
    case inputStreamReadFailed(Error?)
}

enum NetworkQueryError: Error {
    case jsonEncodingFailed(Error)
    case creatingUrlFailed
    case multipartEncodingFailed(Error)
}

enum NetworkQueryHeaderType: String {
    case contentDidposition = "Content-Disposition"
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum NetworkQueryHeaderValue {
    case jsonApplication
    case bearerHeader(String)
    case urlEncodedApplication
    case multipart(boundary: String)
    
    var value: String {
        switch self {
        case .jsonApplication: "application/json"
        case .bearerHeader(let value): "Bearer \(value)"
        case .urlEncodedApplication: "application/x-www-form-urlencoded"
        case .multipart(let boundary): "multipart/form-data; boundary=\(boundary)"
        }
    }
}

protocol NetworkQuery {
    func createRequest(request: NetworkRequest, encoding: NetworkQueryEncoding) throws -> URLRequest
    func url(for path: String) -> String
}

final class NetworkQueryImpl {
    private let serverUrl: String

    init(environmentManager: EnvironmentManager) {
        self.serverUrl = environmentManager.serverApiURL()
    }
    
    private func encodeAsJson(url: URL, parameters: [String: Any?]) throws -> Data {
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw NetworkQueryError.jsonEncodingFailed(NetworkQueryErrorReason.invalidJsonObject)
        }
        
        do {
            return try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            throw NetworkQueryError.jsonEncodingFailed(error)
        }
    }
    
    private func createQueryItems(parameters: [String: Any?]) -> [URLQueryItem] {
        guard !parameters.isEmpty else { return [] }
        return parameters.map { key, value in
            createQueryItemValue(key, item: value)
        }.flatMap { $0 }
    }
    
    private func createQueryItemValue(_ key: String, item: Any?) -> [URLQueryItem] {
        var components: [URLQueryItem] = []
        switch item {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                components += createQueryItemValue("\(key)[\(nestedKey)]", item: value)
            }
        case let array as [Any]:
            for index in 0..<array.count {
                let value = array[index]
                components += createQueryItemValue("\(key)[]", item: value)
            }
        case let number as NSNumber:
            return [URLQueryItem(name: key, value: "\(number)")]
        case let bool as Bool:
            return [URLQueryItem(name: key, value: bool ? "true" : "false")]
        case let string as String:
            return [URLQueryItem(name: key, value: string)]
        default:
            return components
        }
        return components
    }
    
    private func randomBoundary() -> String {
        let first = UInt32.random(in: UInt32.min...UInt32.max)
        let second = UInt32.random(in: UInt32.min...UInt32.max)

        return String(format: "networkmanager.boundary.%08x%08x", first, second)
    }
    
    private func url(for request: NetworkRequest) -> String {
        return String(format: "%@/v1/%@", serverUrl, request.path)
    }
}

extension NetworkQueryImpl: NetworkQuery {
    func createRequest(request: NetworkRequest, encoding: NetworkQueryEncoding) throws -> URLRequest {
        guard let url = URL(string: url(for: request)) else { throw NetworkQueryError.creatingUrlFailed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        switch encoding {
        case .json:
            do {
                let encodedParameters = try encodeAsJson(url: url, parameters: request.parameters)
                urlRequest.addValue(NetworkQueryHeaderValue.jsonApplication.value,
                                    forHTTPHeaderField: NetworkQueryHeaderType.contentType.rawValue)
                urlRequest.httpBody = encodedParameters
            } catch {
                throw error
            }
        case .queryString:
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = createQueryItems(parameters: request.parameters)
            urlRequest.url = urlComponents?.url
        case .multipart:
            do {
                let boundary = randomBoundary()
                let multipart = MultipartQuery(boundary: boundary)
                let encodedData = try multipart.createMultipartSendingData(for: request)
                urlRequest.addValue(NetworkQueryHeaderValue.multipart(boundary: boundary).value,
                                    forHTTPHeaderField: NetworkQueryHeaderType.contentType.rawValue)
                urlRequest.httpBody = encodedData
            }
        }
        return urlRequest
    }
    
    func url(for path: String) -> String {
        return String(format: "%@/v1/%@", serverUrl, path)
    }
}
