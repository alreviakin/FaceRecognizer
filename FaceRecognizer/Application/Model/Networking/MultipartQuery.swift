//
//  MultipartQuery.swift
//
//
//  Created by alexandr galkin on 15.04.2024.
//

import Foundation

final class MultipartQuery {
    struct Header {
        let key: String
        let value: String
    }
    
    struct Part {
        let stream: InputStream
        let length: UInt64
        let headers: [Header]
    }
    
    enum BoundaryType {
        case initial, encapsulated, final
    }
    
    enum EncodingCharacters {
        static let crlf = "\r\n"
    }
    
    private var parts: [Part] = []
    private let boundary: String
    
    init(boundary: String) {
        self.boundary = boundary
    }
    
    private func boundaryData(forBoundaryType boundaryType: BoundaryType, boundary: String) -> Data {
        let boundaryText: String

        switch boundaryType {
        case .initial:
            boundaryText = String(format: "--%@%@", boundary, EncodingCharacters.crlf)
        case .encapsulated:
            boundaryText = String(format: "%@--%@%@", EncodingCharacters.crlf, boundary, EncodingCharacters.crlf)
        case .final:
            boundaryText = String(format: "%@--%@--%@", EncodingCharacters.crlf, boundary, EncodingCharacters.crlf)
        }

        return Data(boundaryText.utf8)
    }
    
    private func createAndAppendPart(_ stream: InputStream, withLength length: UInt64, headers: [Header]) {
        parts.append(.init(stream: stream, length: length, headers: headers))
    }
    
    private func encodeUplodaingParameters() throws -> Data {
        var encoded = Data()
        var hasInitialBoundary = false
        
        for index in 0..<parts.count {
            let isLast = index + 1 == parts.count
            encoded.append(try encode(part: parts[index],
                                  hasInitialBoundary: hasInitialBoundary,
                                  hasFinalBoundary: isLast))
            hasInitialBoundary = true
        }
    
        return encoded
    }
    
    private func encodeHeaders(part: Part) -> Data {
        let headerText = part.headers.map { String(format: "%@:%@%@", $0.key, $0.value, EncodingCharacters.crlf) }
            .joined()
            + EncodingCharacters.crlf

        return Data(headerText.utf8)
    }
    
    private func encode(part: Part, hasInitialBoundary: Bool, hasFinalBoundary: Bool) throws -> Data {
        var encoded = Data()
        
        if hasInitialBoundary {
            encoded.append(boundaryData(forBoundaryType: .encapsulated, boundary: boundary))
        } else {
            encoded.append(boundaryData(forBoundaryType: .initial, boundary: boundary))
        }
        
        encoded.append(encodeHeaders(part: part))
        encoded.append(try encodeBodyStream(part: part))
        
        if hasFinalBoundary {
            encoded.append(boundaryData(forBoundaryType: .final, boundary: boundary))
        }
        
        return encoded
    }
    
    private func encodeBodyStream(part: Part) throws -> Data {
        let streamBufferSize = 1024
        let inputStream = part.stream
        inputStream.open()
        
        defer {
            inputStream.close()
        }

        var encoded = Data()

        while inputStream.hasBytesAvailable {
            var buffer = [UInt8](repeating: 0, count: streamBufferSize)
            let bytesRead = inputStream.read(&buffer, maxLength: streamBufferSize)

            if let error = inputStream.streamError {
                throw NetworkQueryError.multipartEncodingFailed(NetworkQueryErrorReason.inputStreamReadFailed(error))
            }

            if bytesRead > 0 {
                encoded.append(buffer, count: bytesRead)
            } else {
                break
            }
        }

        guard UInt64(encoded.count) == part.length else {
            throw NetworkQueryError.multipartEncodingFailed(NetworkQueryErrorReason.inputStreamReadFailed(nil))
        }

        return encoded
    }
    
    private func contentHeaders(withName name: String,
                                fileName: String? = nil,
                                mimeType: String? = nil) -> [Header] {
        var disposition = "form-data; name=\"\(name)\""
        
        if let fileName {
            disposition += "; filename=\"\(fileName)\""
        }

        var headers: [Header] = [.init(key: NetworkQueryHeaderType.contentDidposition.rawValue, value: disposition)]
        
        if let mimeType {
            headers.append(.init(key: NetworkQueryHeaderType.contentType.rawValue, value: mimeType))
        }

        return headers
    }
    
    private func appendData(_ data: Data, withName: String, fileName: String? = nil, mimeType: String? = nil) {
        let headers = contentHeaders(withName: withName, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let lenght = UInt64(data.count)
        createAndAppendPart(stream, withLength: lenght, headers: headers)
    }
}

extension MultipartQuery {
    func createMultipartSendingData(for request: NetworkRequest) throws -> Data {
        request.parameters.forEach { key, value in
            if let data = value as? Data {
                appendData(data, withName: key)
            }
            if let data = value as? [Data] {
                data.forEach {
                    appendData($0, withName: key + "[]")
                }
            }
        }
        
        request.files.forEach { file in
            appendData(file.data,
                       withName: file.contentName,
                       fileName: file.name,
                       mimeType: file.mimeType.rawValue)
        }
        
        return try encodeUplodaingParameters()
    }
}
