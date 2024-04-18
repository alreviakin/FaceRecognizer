//
//  UIViewController+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UIViewController {
    /// Returns top presented controller
    var topPresentedViewController: UIViewController? {
        guard var topPresentedController = presentedViewController else { return nil }
        
        while let presentedController = topPresentedController.presentedViewController {
            topPresentedController = presentedController
        }
        
        return topPresentedController
    }
}
