//
//  API.swift
//  communityhill
//
//  Created by Georgii Kazhuro on 02.12.2021.
//

import Foundation

struct API {
    static var baseURL: String {
        return "\(InfoPlistService().serverApiURL())"
    }
}

