//
//  AppCoordinator.swift
//  ForaArchitecture
//
//  Created by Georgii Kazhuro on 07.04.2021.
//

import UIKit
import DITranquillity
import ForaArchitecture

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let container: DIContainer
    
    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
    }
    
    override func start() {
    }
    
    override func start(with option: (any DeepLinkOption)?) {
    }

}
