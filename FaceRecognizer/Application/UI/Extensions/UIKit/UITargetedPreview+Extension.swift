//
//  UITargetedPreview+Extension.swift
//  ForaArchitecture
//
//  Created by alexandr galkin on 16.05.2022.
//

import UIKit

extension UITargetedPreview {
    convenience init(views: [UIView]) {
        if let first = views.first {
            self.init(view: first)
        } else {
            self.init(view: UIView())
        }
        
        for index in 1..<views.count {
            view.addSubview(views[index])
        }
    }
}
