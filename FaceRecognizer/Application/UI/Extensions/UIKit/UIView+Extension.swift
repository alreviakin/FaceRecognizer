//
//  UIView+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func addSublayers(_ layers: CALayer...) {
        layers.forEach { layer.addSublayer($0) }
    }
    
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func findView<T: UIView>(of type: T.Type) -> T? {
        if let first = subviews.first(where: { $0 is T }) as? T {
            return first
        } else {
            for view in subviews {
                return view.findView(of: type)
            }
        }
        return nil
    }
    
    func findViews<T: UIView>(of type: T.Type) -> [T] {
        var views = [T]()
        for subview in subviews {
            if let view = subview as? T {
                views.append(view)
            } else if !subview.subviews.isEmpty {
                views.append(contentsOf: subview.findViews(of: type))
            }
        }
        return views
    }
    
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }
    
    func addGestureRecognizers(_ gestureRecognizers: UIGestureRecognizer...) {
        for recognizer in gestureRecognizers {
            addGestureRecognizer(recognizer)
        }
    }
    
    func removeGestureRecognizers(_ gestureRecognizers: UIGestureRecognizer...) {
        for recognizer in gestureRecognizers {
            removeGestureRecognizer(recognizer)
        }
    }
    
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    // MARK: - Layer
    
    func addShadow(cornerRadius: CGFloat = 12,
                   shadowColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0),
                   shadowOpacity: Float = 0.3,
                   shadowRadius: CGFloat = 5) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    // MARK: - Borders
    
    enum ViewSide {
        case left,
             right,
             top,
             bottom
    }
    
    func addBorder(lineWidth: CGFloat, lineColor: UIColor) {
        layer.borderColor = lineColor.cgColor
        layer.borderWidth = lineWidth
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        let border = CALayer()
        border.borderColor = color
        switch side {
        case .left: border.frame = CGRect(x: 0, y: 1, width: thickness, height: frame.height - 1)
        case .right: border.frame = CGRect(x: frame.width - thickness, y: 1, width: thickness, height: frame.height - 1)
        case .top: border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom: border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        }
        border.borderWidth = thickness
        layer.addSublayer(border)
    }
    
    func setGradientBorder(
        width: CGFloat,
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5),
        radius: CGFloat = 0.0
    ) {
        if let gradient = gradientBorderLayer(), gradient.bounds != CGRect(x: 0, y: 0, width: 0, height: 0) {
            return
        } else {
            removeGradientLayer()
        }
        
        let border = CAGradientLayer()
        border.frame = CGRect(origin: CGPoint.zero,
                              size: bounds.size)
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        let maskRect = CGRect(
            x: bounds.origin.x + width / 2,
            y: bounds.origin.y + width / 2,
            width: bounds.size.width - width,
            height: bounds.size.height - width
        )
        mask.path = UIBezierPath(roundedRect: maskRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.black.cgColor
        mask.lineWidth = width
        
        border.mask = mask
        layer.addSublayer(border)
    }
    
    func removeGradientLayer() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        return layer.sublayers?.filter { $0 is CAGradientLayer }.first as? CAGradientLayer
    }
}
