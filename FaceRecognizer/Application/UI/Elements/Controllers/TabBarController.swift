//
//  TabBarController.swift
//  ForaArchitecture
//
//  Created by Dmitriy.K on 09.02.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    override var shouldAutorotate: Bool {
        selectedViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
