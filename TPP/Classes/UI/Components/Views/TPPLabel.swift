//
//  TPPLabel.swift
//  TPP
//
//  Created by Mihails Tumkins on 07/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//
import UIKit

class TPPLabel: UILabel {
    var insets: UIEdgeInsets?

    override func drawText(in rect: CGRect) {
        var rect = rect
        if let insets = insets {
            rect = UIEdgeInsetsInsetRect(rect, insets)
        }
        super.drawText(in: rect)
    }

    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if let insets = insets {
            size.height += insets.top + insets.bottom
            size.width += insets.left + insets.right
        }
        return size
    }
}
