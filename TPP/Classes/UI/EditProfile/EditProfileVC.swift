//
//  EditProfileVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 13/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Device
import RxSwift

class EditProfileVC: UIViewController, PKeyboardObservable, PTextFieldsNextFocus {

    internal var keyboardNotificationsObserver = EventBusObserver()

    @IBOutlet weak var emailField: TPPValidatedField!

    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: ButtonWithPreloader!

    let disposeBag = DisposeBag()

    let viewModel = EditProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()

        if Device.size() == .screen3_5Inch {
            scrollViewTopConstraint.constant = 10
        }

        if let user = UserService.shared.user.value {
            emailField.textField.text = user.email
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

        viewModel.isLoading.asObservable().subscribe(onNext: { [weak self] (val) in
            self?.saveButton.showPreloader(show: val)
        }).addDisposableTo(disposeBag)

        viewModel.errorHandler = { [weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }

        viewModel.completionHandler = { [weak self] in

            self?.showTPPAlert(title: "Done", message: "Email changed") {
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func layoutFieldsWithoutAnimation() {
        UIView.performWithoutAnimation {
            self.emailField.layoutIfNeeded()
        }
    }

    @IBAction func didTapSave(_ sender: Any) {
        guard let email = self.emailField.text, email.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.emailField)
            return
        }

        viewModel.update(email: email)
    }
}
