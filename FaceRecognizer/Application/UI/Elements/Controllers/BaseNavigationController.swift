//
//  BaseNavigationController.swift
//  ForaArchitecture
//
//  Created by Dmitriy.K on 09.02.2022.
//

import Foundation

import UIKit

final class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .darkContent
    }
    
    override var shouldAutorotate: Bool {
        topViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
    }
}
