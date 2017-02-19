//
//  CreateNewPasswordVC.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import RxSwift

class CreateNewPasswordVC: UIViewController, PTextFieldsNextFocus, PKeyboardObservable {

    var keyboardNotificationsObserver = EventBusObserver()
    var resetParams: [String: String]?
    @IBOutlet weak var passwordField: TPPLoginField!
    @IBOutlet weak var confirmpasswordField: TPPLoginField!
    @IBOutlet weak var resetButton: ButtonWithPreloader!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    internal let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addNextButtonForTextFields(textFields: [passwordField.textField, confirmpasswordField.textField])
        self.onKeyboardAppear {[weak self] (rect) in
            self?.bottomConstraint.constant = rect.size.height+8
            self?.view.layoutIfNeeded()
        }
        self.onKeyboardDissappear {[weak self] in
            self?.bottomConstraint.constant = 20
            self?.view.layoutIfNeeded()
        }
    }

    @IBAction func onResetTap(_ sender: Any) {
        guard let password = passwordField.textField.text, password.characters.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: passwordField)
            return
        }
        guard let confirmPassword = confirmpasswordField.textField.text, confirmPassword.characters.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: confirmpasswordField)
            return
        }
        guard password == confirmPassword else {
            self.showGlobalAlert(title: "Error", message: "Passwords don't match")
            return
        }
        self.resetButton.showPreloader(show: true)
        let params = resetParams ?? [String: String]()
        TPPResetPasswordRequest(password: password, otherParams: params).send().subscribe(onNext: { (response) in
            if let user = response.user {
                BGDidLoginEvent(user: user).send()
            }
        }, onError: {[weak self] (error) in
            self?.showTPPAlert(error: error)
            self?.resetButton.showPreloader(show: false)
        }).addDisposableTo(self.bag)
    }

}
