//
//  ResetPasswordVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 13/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//
import UIKit
import Device
import RxSwift

class ResetPasswordVC: UIViewController, PKeyboardObservable, PTextFieldsNextFocus {

    internal var keyboardNotificationsObserver = EventBusObserver()
    @IBOutlet weak var resetButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailField: TPPLoginField!
    internal let bag = DisposeBag()
    @IBOutlet weak var resetButton: ButtonWithPreloader!

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
    }

    internal func addHandlers() {
        onKeyboardAppear {[weak self] (rect) in
            self?.resetButtonBottomConstraint.constant = rect.height + 20
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        onKeyboardDissappear {[weak self] in
            self?.resetButtonBottomConstraint.constant = 20
            self?.layoutFieldsWithoutAnimation()
            self?.view.layoutIfNeeded()
        }

        addNextButtonForTextFields(textFields: [emailField.textField])
    }

    private func layoutFieldsWithoutAnimation() {
        UIView.performWithoutAnimation {
            self.emailField.layoutIfNeeded()
        }
    }

    @IBAction func didTapReset(_ sender: Any) {
        guard let email = self.emailField.text, email.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.emailField)
            return
        }
        self.resetButton.showPreloader(show: true)
        TPPForgotPasswordRequest(email: email).send().subscribe(onNext: {[weak self] (_) in
            self?.openMagicLink()
            self?.resetButton.showPreloader(show: false)
        }, onError: {[weak self] (error) in
            self?.showTPPAlert(error: error)
            self?.resetButton.showPreloader(show: false)
        }).addDisposableTo(self.bag)
    }

    internal func openMagicLink() {
        let vc: MagicLinkVC = UIStoryboard(storyboard: .Login).instantiateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension URL {
    func getKeyVals() -> [String:String]? {
        var results = [String:String]()
        if let keyValues = self.query?.components(separatedBy: "&") {
            if keyValues.isEmpty == false {
                for pair in keyValues {
                    let kv = pair.components(separatedBy: "=")
                    if kv.count > 1 {
                        results.updateValue(kv[1], forKey: kv[0])
                    }
                }
            }
        }
        return results
    }
}
