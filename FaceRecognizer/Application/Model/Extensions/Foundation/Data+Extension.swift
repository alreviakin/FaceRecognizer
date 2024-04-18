//
//  Data+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import Foundation

public extension Data {
    func mimeType() -> String? {
        var bytes: UInt8 = 0
        copyBytes(to: &bytes, count: 1)
        
        switch bytes {
        case 0xFF: return "image/jpeg"
        case 0x89: return "image/png"
        case 0x47: return "image/gif"
        case 0x49, 0x4D: return "image/tiff"
        default: return "application/octet-stream"
        }
    }
}
