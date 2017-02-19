//
//  ChangePasswordVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 12/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Device
import RxSwift

class ChangePasswordVC: UIViewController, PKeyboardObservable, PTextFieldsNextFocus {

    internal var keyboardNotificationsObserver = EventBusObserver()
    @IBOutlet weak var currentPasswordField: TPPValidatedField!
    @IBOutlet weak var newPasswordField: TPPValidatedField!
    @IBOutlet weak var confirmField: TPPValidatedField!
    @IBOutlet weak var saveButton: ButtonWithPreloader!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    var resetParams: [String:String]?
    private let bag = DisposeBag()

    private let viewModel = AdditionalQuestionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()

        if Device.size() == .screen3_5Inch {
            scrollViewTopConstraint.constant = 10
        }
    }

    internal func addHandlers() {
        onKeyboardAppear {[weak self] (rect) in
            self?.saveButtonBottomConstraint.constant = rect.height
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        onKeyboardDissappear {[weak self] in
            self?.saveButtonBottomConstraint.constant = 35
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        self.viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] (loading) in
            self?.saveButton.showPreloader(show: loading)
        }).addDisposableTo(self.bag)

        self.viewModel.completionHandler = {[weak self] in
            self?.showTPPAlert(title: "Updated", message: "Password is changed", action: "OK", completion: nil)
        }
        self.viewModel.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }

        addNextButtonForTextFields(textFields: [
            currentPasswordField.textField,
            newPasswordField.textField,
            confirmField.textField])
    }

    private func layoutFieldsWithoutAnimation() {
        UIView.performWithoutAnimation {
            self.currentPasswordField.layoutIfNeeded()
            self.newPasswordField.layoutIfNeeded()
            self.confirmField.layoutIfNeeded()
        }
    }

    @IBAction func didTapSave(_ sender: Any) {
        guard let currentPassword = self.currentPasswordField.text, currentPassword.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.currentPasswordField)
            return
        }
        guard let newPassword = self.newPasswordField.text, newPassword.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.newPasswordField)
            return
        }
        guard let confirmedPassword = self.confirmField.text, confirmedPassword.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.confirmField)
            return
        }

        self.saveButton.showPreloader(show: true)

        TPPResetPasswordRequest(password: newPassword, otherParams: nil).send().subscribe(onNext: {[weak self] (response) in
            self?.showTPPAlert(title: "Updated", message: "Password is changed", action: "OK", completion: nil)
            self?.saveButton.showPreloader(show: false)
        }, onError: {[weak self] (error) in
            self?.showTPPAlert(error: error)
            self?.saveButton.showPreloader(show: false)
        }).addDisposableTo(self.bag)
    }
}
