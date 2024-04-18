//
//  InfoPlistService.swift
//  communityhill
//
//  Created by Georgii Kazhuro on 02.12.2021.
//

import Foundation

class InfoPlistService {
    private struct Keys {
        static let keysAndTokens = "FaceRecognizerConstantsDictionary"
        static let serverApiURL = "server_api_url"
    }

    // MARK: Public Properties

    static let shared = InfoPlistService()

    // MARK: Private Properties

    private var info: [String: Any]?

    // MARK: Init Methods & Superclass Overriders

    init() {
        info = Bundle.main.object(forInfoDictionaryKey: Keys.keysAndTokens) as? [String: Any]
    }

    /// Gets server api URL value from Info.plist for current build scheme.
    ///
    /// - returns: Server Api URL as a string.
    ///
    func serverApiURL() -> String {
        if let string = info?[Keys.serverApiURL] as? String {
            return string
        }
        return ""
    }
}
