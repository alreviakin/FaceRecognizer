//
//  UIStackView+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UIStackView {
    convenience init(
        frame: CGRect,
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        aligment: Alignment = .fill,
        distribution: Distribution = .equalSpacing
    ) {
        self.init(frame: frame)
        
        self.axis = axis
        self.spacing = spacing
        self.alignment = aligment
        self.distribution = distribution
    }
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
    
    func removeArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
        }
    }
}
