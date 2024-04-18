//
//  UITableViewCell+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UITableViewCell {
    var tableView: UITableView? {
        superview as? UITableView
    }
    
    var indexPath: IndexPath? {
        tableView?.indexPath(for: self)
    }
}
