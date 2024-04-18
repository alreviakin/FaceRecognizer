//
//  UIButton+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UIButton {
    func setImage(_ image: UIImage) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
        setTitle(title, for: .highlighted)
    }
    
    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
    }
}
