//
// Created by Igors Nemenonoks on 21/04/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa

protocol PTextFieldsNextFocus {
    func addNextButtonForTextFields(textFields: [UITextField])
}

extension PTextFieldsNextFocus where Self : UIViewController {
    func addNextButtonForTextFields(textFields: [UITextField]) {
        for (index, textField) in textFields.enumerated() {
            if textFields.count > index + 1 {
                let nextTextField = textFields[index + 1]
                textField.returnKeyType = .next
                textField.onReturnKeyTap {
                    nextTextField.becomeFirstResponder()
                }
            }
        }
    }

    func resignTextFieldsReponder(textFields: [UITextField]) {
        for textField in textFields {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
                return
            }
        }
    }
}

extension UITextField {
    func onReturnKeyTap(handler:@escaping (() -> Void)) {
        let _ = self.rx.controlEvent(UIControlEvents.editingDidEndOnExit).subscribe(onNext: {
            handler()
        })

    }
}
