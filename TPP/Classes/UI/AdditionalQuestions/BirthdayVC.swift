//
//  BirthdayVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 27/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Device

class BirthdayVC: UIViewController, PKeyboardObservable {

    let disposeBag = DisposeBag()

    internal var keyboardNotificationsObserver = EventBusObserver()

    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: ButtonWithPreloader!

    let viewModel = AdditionalQuestionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()

        if let birthday = viewModel.getBirthday() {
            updateDateLabelAndTextArea(input: birthday)
        }
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

        textField.delegate = self

        textField.rx.text.asObservable().subscribe(onNext: {[weak self] (val) in
            self?.updateDateLabelAndTextArea(input: val)
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

    private func updateDateLabelAndTextArea(input: String?) {
        let result = viewModel.formatTextAreaInput(input: input)
        dateLabel.text = result
        updateTextAreaInput(input: result)
    }

    private func updateTextAreaInput(input: String) {
        textField.text = viewModel.formatForTextField(input: input)
    }

    private func showNext() {
        textField.resignFirstResponder()
        performSegue(withIdentifier: String.className(GenderVC.self), sender: self)
    }

    @IBAction func didTapNext(_ sender: Any) {
        guard let birthday = textField.text, birthday.characters.count == 10 else {
            ViewAnimationsUtils.shakeView(view: self.dateLabel)
            ViewAnimationsUtils.shakeView(view: self.textField)
            return
        }

        viewModel.updateBirthday(birthday: birthday)
    }

    @IBAction func didTapClose(_ sender: Any) {
        UIShowTutorialScreenEvent(.transitionCrossDissolve).send()
    }
}

extension BirthdayVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if text.characters.count >= 10 && string.isEmpty == false {
                return false
            }
        }
        return true
    }
}
