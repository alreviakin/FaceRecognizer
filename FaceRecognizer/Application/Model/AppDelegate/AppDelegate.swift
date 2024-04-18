//
//  AppDelegate.swift
//  ForaArchitecture
//
//  Created by Georgii Kazhuro on 07.04.2021.
//

import UIKit
import DITranquillity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let container = DIContainer()
    
    var window: UIWindow?
    private var applicationCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerParts()
        
        let window = UIWindow()
        let applicationCoordinator = AppCoordinator(window: window, container: container)
        self.applicationCoordinator = applicationCoordinator
        self.window = window
        
        window.makeKeyAndVisible()
        applicationCoordinator.start()
        
        return true
    }

    private func registerParts() {
        container.append(part: ModelPart.self)
        container.append(part: NetworkPart.self)
    }
}

