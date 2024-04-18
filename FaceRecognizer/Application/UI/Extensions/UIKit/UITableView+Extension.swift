//
//  UITableView+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UITableView {
    
    /// Registers a classes for use in creating new table cells
    ///
    /// Method uses default identifiers based on class type
    /// # Example
    /// This line
    /// ```
    /// register([CellA.self, CellB.self])
    /// ```
    /// is equal
    /// ```
    /// register(CellA.self, forCellWithReuseIdentifier: "CellA")
    /// register(CellB.self, forCellWithReuseIdentifier: "CellB")
    /// ```
    /// - Parameter classes: array of class types
    func register(_ classes: [UITableViewCell.Type]) {
        classes.forEach {
            register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
    
    func registerHeaderFooter(_ classes: [UITableViewHeaderFooterView.Type]) {
        classes.forEach {
            register($0, forHeaderFooterViewReuseIdentifier: String(describing: $0))
        }
    }
    
    /// Dequeues a reusable cell object located by its *class type* identifier.
    /// - Parameter indexPath: The index path specifying the location of the cell.
    /// - Returns: A reusable cell object downcasted to given type
    /// # Example
    /// ```
    /// let cell: MyCellType = tableView.dequeueReusableCell(for: indexPath)
    /// ```
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        // swiftlint:disable force_cast
        dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        // swiftlint:enable force_cast
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        // swiftlint:disable force_cast
        dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
        // swiftlint:enable force_cast
    }
    
}
