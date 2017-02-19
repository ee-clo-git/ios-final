//
//  TextInputQuestionVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 03/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Device
import GrowingTextViewHandler_Swift

class TextInputQuestionVC: UIViewController, SurveyQuestion, PKeyboardObservable {

    var viewModel: SurveyViewModel?
    weak var delegate: SurveyDelegate?

    let disposeBag = DisposeBag()

    internal var keyboardNotificationsObserver = EventBusObserver()

    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: ButtonWithPreloader!

    internal var textViewHandler: GrowingTextViewHandler?

    private var smallOffset: CGFloat = 100
    private var bigOffset: CGFloat = 165

    override func viewDidLoad() {
        super.viewDidLoad()

        if Device.isSmallerThanScreenSize(.screen4Inch) {
            smallOffset = 53
            bigOffset = 120
        }
        questionLabelBottomConstraint.constant = bigOffset

        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 3.0
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(5.0, 0, 0)

        if Device.isSmallerThanScreenSize(.screen4Inch) {
            questionLabel.font = UIFont.mainBoldFontWithSize(size: 29)
        }

        addHandlers()
    }

    func configure() {
        navigationItem.title = viewModel?.pageTitle()
        questionLabel.text = viewModel?.questionTitle()

        // TODO remove
        view.backgroundColor = viewModel?.randomColor()
        nextButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }

    internal func addHandlers() {

        onKeyboardAppear {[weak self] rect in
            self?.nextButtonBottomConstraint.constant = rect.height
            if let smallOffset = self?.smallOffset {
                self?.questionLabelBottomConstraint.constant = smallOffset
            }
            self?.view.layoutIfNeeded()
        }

        onKeyboardDissappear {[weak self] in
            self?.nextButtonBottomConstraint.constant = 0
            if let bigOffset = self?.bigOffset {
                self?.questionLabelBottomConstraint.constant = bigOffset
            }
            self?.view.layoutIfNeeded()
        }

        viewModel?.isLoading.asObservable().subscribe(onNext: {[weak self] (val) in
            self?.nextButton.showPreloader(show: val)
        }).addDisposableTo(disposeBag)

        viewModel?.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }

        viewModel?.completionHandler = {[weak self] in
            self?.delegate?.completed()
        }
        if Device.isLargerThanScreenSize(.screen4Inch) {
            self.textViewHandler = GrowingTextViewHandler(textView: self.textView, heightConstraint: textViewHeightConstraint)
            self.textViewHandler?.minimumNumberOfLines = 1
            self.textViewHandler?.maximumNumberOfLines = 5

            self.textView.delegate = self
        }
    }

    private func showNext() {
        textView.resignFirstResponder()
        UIShowTutorialScreenEvent(.transitionCrossDissolve).send()
    }

    @IBAction func didTapNext(_ sender: Any) {
        guard let answer = textView.text, answer.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.textView)
            return
        }
        viewModel?.answer(value: answer)
        delegate?.didTapNext()
    }
}

extension TextInputQuestionVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textViewHandler?.resizeTextView(true)
    }
}
