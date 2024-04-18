//
//  UISwitch+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UISwitch {
    func toggle(animated: Bool = true) {
        setOn(!isOn, animated: animated)
    }
}
