//
//  ZipCodeVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 27/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Device

class ZipCodeVC: UIViewController, PKeyboardObservable {

    let disposeBag = DisposeBag()

    internal var keyboardNotificationsObserver = EventBusObserver()

    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: ButtonWithPreloader!

    let viewModel = AdditionalQuestionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()

        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 3.0
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5.0, 0, 0)
        textField.text = viewModel.user.value?.zip
    }

    override func viewWillAppear(_ animated: Bool) {
        self.textField.becomeFirstResponder()
        super.viewWillAppear(animated)
    }

    internal func addHandlers() {

        var smallOffset: CGFloat = 100
        var bigOffset: CGFloat = 165

        if Device.isSmallerThanScreenSize(.screen4Inch) {
            smallOffset = 50
            bigOffset = 120
        }
        questionLabelBottomConstraint.constant = bigOffset

        onKeyboardAppear {[weak self] rect in
            self?.nextButtonBottomConstraint.constant = rect.height
            self?.questionLabelBottomConstraint.constant = smallOffset
            self?.view.layoutIfNeeded()
        }

        onKeyboardDissappear {[weak self] in
            self?.nextButtonBottomConstraint.constant = 0
            self?.questionLabelBottomConstraint.constant = bigOffset
            self?.view.layoutIfNeeded()
        }

        textField.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {[weak self] (val) in
            self?.textField.resignFirstResponder()
        }).addDisposableTo(disposeBag)

        viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] (val) in
            self?.nextButton.showPreloader(show: val)
        }).addDisposableTo(disposeBag)

        viewModel.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }

        viewModel.completionHandler = {[weak self] in
            self?.showNext()
        }
    }

    private func showNext() {
        textField.resignFirstResponder()
        UIShowTutorialScreenEvent(.transitionCrossDissolve).send()
    }

    @IBAction func didTapNext(_ sender: Any) {
        guard let zipCode = textField.text, zipCode.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.textField)
            return
        }
        viewModel.updateZipCode(zipCode: zipCode)
    }

    @IBAction func didTapClose(_ sender: Any) {
        UIShowTutorialScreenEvent(.transitionCrossDissolve).send()
    }
}
