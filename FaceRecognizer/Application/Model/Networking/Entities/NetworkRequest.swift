//
//  NetworkRequest.swift
//
//
//  Created by alexandr galkin on 01.03.2024.
//

import Foundation

struct NetworkRequest {

    let path: String
    let method: HTTPMethod
    var parameters: [String: Any?]
    var files: [MultipartFormDataFile]
    let shouldAuthorize: Bool
    
    init(path: String,
         method: HTTPMethod,
         shouldAuthorize: Bool = true,
         parameters: [String: Any?] = [:],
         files: [MultipartFormDataFile] = []
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.files = files
        self.shouldAuthorize = shouldAuthorize
    }
    
    enum HTTPMethod: String {
      case get = "GET"
      case post = "POST"
      case put = "PUT"
      case patch = "PATCH"
      case delete = "DELETE"
    }
}

struct MultipartFormDataFile: Equatable {
    enum MimeType: String, Equatable {
        case base = "application/octet-stream"
        case jpegImage = "image/jpeg"
        case pngImage = "image/png"
    }
    
    let data: Data
    let name: String
    let mimeType: MimeType
    let contentName: String
}
