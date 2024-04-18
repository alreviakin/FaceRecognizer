//
//  UICollectionView+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UICollectionView {
    
    /// Registers a classes for use in creating new collection view cells
    ///
    /// Method uses default identifiers based on class type
    ///
    /// **Example**
    ///
    /// ```
    /// register(CellA.self, CellB.self)
    /// ```
    /// is equal
    /// ```
    /// register(CellA.self, forCellWithReuseIdentifier: "CellA")
    /// register(CellB.self, forCellWithReuseIdentifier: "CellB")
    /// ```
    /// - Parameter classes: Zero or more class types to register.
    func register(_ classes: UICollectionViewCell.Type...) {
        classes.forEach {
            register($0, forCellWithReuseIdentifier: String(describing: $0))
        }
    }
    
    /// Registers a reusableViews classes with kind for use in creating new collection view cells
    ///
    /// Method uses default identifiers based on class type
    /// - Parameter reusableViews: tuples of class and kind
    func register(_ reusableViews: (class: UICollectionReusableView.Type, kind: String)...) {
        reusableViews.forEach {
            register($0.class, forSupplementaryViewOfKind: $0.kind, withReuseIdentifier: String(describing: $0.class))
        }
    }
    
    /// Registers a classes for use in creating supplementary views for the collection view.
    ///
    /// Method uses default identifiers based on class type
    ///
    /// **Example**
    ///
    /// ```
    /// registerHeader(CellA.self, CellB.self)
    /// ```
    /// is equal
    /// ```
    /// register(CellA.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CellA")
    /// register(CellB.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CellB")
    /// ```
    /// - Parameter classes: Zero or more class types to register.
    func registerHeader(_ classes: UICollectionReusableView.Type...) {
        classes.forEach {
            register($0, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: $0))
        }
    }
    
    /// Registers a classes for use in creating supplementary views for the collection view.
    ///
    /// Method uses default identifiers based on class type
    ///
    /// **Example**
    ///
    /// ```
    /// registerFooter(CellA.self, CellB.self)
    /// ```
    /// is equal
    /// ```
    /// register(CellA.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CellA")
    /// register(CellB.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CellB")
    /// ```
    /// - Parameter classes: Zero or more class types to register.
    func registerFooter(_ classes: UICollectionReusableView.Type...) {
        classes.forEach {
            register($0, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: $0))
        }
    }
    
    /// Dequeues a reusable cell object located by its *class type* identifier.
    /// - Parameter indexPath: The index path specifying the location of the cell.
    /// - Returns: A reusable cell object downcasted to given type
    ///
    /// **Example**
    ///
    /// ```
    /// let cell: MyCellType = collectionView.dequeueReusableCell(for: indexPath)
    /// ```
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        // swiftlint:disable force_cast
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        // swiftlint:enable force_cast
    }
    
    /// Dequeues a reusable supplementary view located by its *class type* identifier and kind.
    /// - Parameter elementKind: The kind of supplementary view to retrieve.
    /// - Parameter indexPath: The index path specifying the location of the supplementary view in the collection view.
    /// - Returns: A reusable supplementary view object downcasted to given type
    ///
    /// **Example**
    ///
    /// ```
    /// let view: MyReusableViewType = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
    /// ```
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
        // swiftlint:disable force_cast
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
        // swiftlint:enable force_cast
    }
}
