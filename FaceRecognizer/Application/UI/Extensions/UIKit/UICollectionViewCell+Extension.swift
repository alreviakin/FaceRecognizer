//
//  UICollectionViewCell+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        superview as? UICollectionView
    }
    
    var indexPath: IndexPath? {
        collectionView?.indexPath(for: self)
    }
}
