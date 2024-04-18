//
//  UIScrollView+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UIScrollView {
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint(x: contentOffset.x, y: -contentInset.top), animated: animated)
    }
    
    func scrollToBottom(animated: Bool = true) {
        setContentOffset(
            CGPoint(x: contentOffset.x, y: max(0, contentSize.height - bounds.height) + contentInset.bottom),
            animated: animated)
    }
}
