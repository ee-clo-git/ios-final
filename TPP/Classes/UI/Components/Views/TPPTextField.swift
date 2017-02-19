//
//  TPPTextField.swift
//  TPP
//
//  Created by Igors Nemenonoks on 09/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit

class TPPTextField: UITextField {

    var insets: UIEdgeInsets?

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        if let insets = insets {
            rect.size.height += insets.top + insets.bottom
            rect.size.width += insets.left + insets.right
            rect.origin.x = insets.left
            rect.origin.y = insets.top
        }
        return rect
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
