//
//  EnvironmentManager.swift
//
//
//  Created by alexandr galkin on 17.10.2022.
//

import Foundation

protocol EnvironmentManager {
    func serverApiURL() -> String
}

final class EnvironmentManagerImpl {
    
    // MARK: - Private Properties
    
    private let environment: Environment
        
    // MARK: - Initializer
    
    init() {
        #if DEBUG
        environment = .develop
        #elseif TEST
        environment = .test
        #elseif DEMO
        environment = .demo
        #elseif RELEASE
        environment = .release
        #else
        environment = .develop
        #endif
    }
}

extension EnvironmentManagerImpl: EnvironmentManager {
    func serverApiURL() -> String {
        environment.apiURL
    }
}

// MARK: - Environment

private enum Environment {
    case develop
    case test
    case demo
    case release
    
    var apiURL: String {
        switch self {
        case .develop: return ""
        case .test: return ""
        case .demo: return ""
        case .release: return ""
        }
    }
}
