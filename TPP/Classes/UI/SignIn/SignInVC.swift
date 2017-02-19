//
//  SignupVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 08/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Device

class SignInVC: UIViewController, PKeyboardObservable, PTextFieldsNextFocus {

    @IBOutlet weak var emailField: TPPLoginField!
    @IBOutlet weak var passwordField: TPPLoginField!
    @IBOutlet weak var signInButton: ButtonWithPreloader!
    @IBOutlet weak var stackViewCenterConstrain: NSLayoutConstraint!

    internal var keyboardNotificationsObserver = EventBusObserver()
    internal var viewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
    }

    internal func addHandlers() {

        let offset = UIScreen.main.bounds.height / 2 - 50

        onKeyboardAppear {[weak self] _ in
            self?.stackViewCenterConstrain.constant = -offset
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        onKeyboardDissappear {[weak self] in
            self?.stackViewCenterConstrain.constant = -120.0
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        addNextButtonForTextFields(textFields: [
            emailField.textField,
            passwordField.textField])

        viewModel.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }

        _ = self.viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] (val) in
            self?.signInButton.showPreloader(show: val)
        })

    }

    private func layoutFieldsWithoutAnimation() {
        UIView.performWithoutAnimation {
            self.emailField.layoutIfNeeded()
            self.passwordField.layoutIfNeeded()
        }
    }

    @IBAction func didTapSignIn(_ sender: Any) {

        guard let email = self.emailField.text, email.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.emailField)
            return
        }
        guard let password = self.passwordField.text, password.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.passwordField)
            return
        }

        viewModel.login(email: email, password: password)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
