//
//  UIAlertController+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UIAlertController {
    convenience init(style: UIAlertController.Style,
                     title: String?, message: String?,
                     actions: [UIAlertAction] = [UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                     completion: (() -> Void)? = nil) {
        self.init(title: title, message: message, preferredStyle: style)
        self.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .white
        
        for action in actions {
            self.addAction(action)
        }
    }
}
