//
//  UITextField+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setText(text: String?) {
        guard text != nil else { return }
        
        let selectedRange = selectedTextRange
        self.text = text
        let formattedRange = selectedTextRange
        
        if let selectedRange = selectedRange,
           let formattedRange = formattedRange,
           offset(from: selectedRange.start, to: formattedRange.start) > 1 {
            selectedTextRange = textRange(from: selectedRange.start, to: selectedRange.start)
        }
    }
}
