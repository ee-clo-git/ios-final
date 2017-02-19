//
// Created by Igors Nemenonoks on 15/02/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {

    class func mainFontWithSize(size: CGFloat) -> UIFont? {
        return UIFont.systemFont(ofSize: size)
    }

    class func mainBoldFontWithSize(size: CGFloat) -> UIFont? {
        return UIFont.boldSystemFont(ofSize: size)
    }
}
