//
//  RegisterVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 08/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Device

class RegisterVC: UIViewController, PKeyboardObservable, PTextFieldsNextFocus {

    internal var keyboardNotificationsObserver = EventBusObserver()

    @IBOutlet weak var registerButton: ButtonWithPreloader!
    @IBOutlet weak var registerLabelBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var emailField: TPPLoginField!
    @IBOutlet weak var passwordField: TPPLoginField!
    @IBOutlet weak var confirmField: TPPLoginField!

    var viewModel = RegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        termsButton.titleLabel?.textAlignment = .center
        addHandlers()
    }

    internal func addHandlers() {
        onKeyboardAppear {[weak self] (rect) in

            let constant = Device.size() == .screen3_5Inch ? rect.height - 40 : rect.height
            self?.registerLabelBottomConstraint.constant = constant
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        onKeyboardDissappear {[weak self] in
            self?.registerLabelBottomConstraint.constant = 8
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        addNextButtonForTextFields(textFields: [
            emailField.textField,
            passwordField.textField,
            confirmField.textField])

        viewModel.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }

        viewModel.completionHandler = {[weak self] in
            self?.showMagicLink()
        }

        _ = self.viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] (val) in
            self?.registerButton.showPreloader(show: val)
        })
    }

    private func layoutFieldsWithoutAnimation() {
        UIView.performWithoutAnimation {
            self.emailField.layoutIfNeeded()
            self.passwordField.layoutIfNeeded()
            self.confirmField.layoutIfNeeded()
        }
    }

    private func showMagicLink() {
        guard let email = self.emailField.text, email.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.emailField)
            return
        }
        guard let password = self.passwordField.text, password.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.passwordField)
            return
        }
        let vc: MagicLinkVC = UIStoryboard(storyboard: .Login).instantiateViewController()
        vc.userData = (email: email, password: password)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTapRegister(_ sender: Any) {

        guard let email = self.emailField.text, email.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.emailField)
            return
        }
        guard let password = self.passwordField.text, password.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.passwordField)
            return
        }
        guard let confirm = self.confirmField.text, confirm.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.confirmField)
            return
        }
        guard confirm == password else {
            self.showTPPAlert(title: "Error", message: "Passwords don't match", action: "OK", completion: nil)
            return
        }

        viewModel.register(email: email, password: password)
    }
    @IBAction func didTapTerms(_ sender: Any) {
        guard let url = viewModel.termsURL() else { return }
        self.openUrl(url: url)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
