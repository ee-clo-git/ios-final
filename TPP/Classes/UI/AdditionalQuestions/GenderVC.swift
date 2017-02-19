//
//  GenderVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 27/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
import Device

class GenderVC: UIViewController, PKeyboardObservable {

    let disposeBag = DisposeBag()

    internal var keyboardNotificationsObserver = EventBusObserver()

    @IBOutlet weak var questionLabelBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var femaleButton: ButtonWithPreloader!
    @IBOutlet weak var femaleButtonLabel: UILabel!
    @IBOutlet weak var femaleButtonTick: UIImageView!

    @IBOutlet weak var maleButton: ButtonWithPreloader!
    @IBOutlet weak var maleButtonLabel: UILabel!
    @IBOutlet weak var maleButtonTick: UIImageView!

    @IBOutlet weak var nextButton: ButtonWithPreloader!

    let viewModel = AdditionalQuestionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        if Device.isSmallerThanScreenSize(.screen4Inch) {
            questionLabelBottomConstraint.constant = 120
        }

        [(femaleButton, femaleButtonLabel, femaleButtonTick), (maleButton, maleButtonLabel, maleButtonTick)].forEach { button, label, tick in
            self.configure(button: button, label: label, tick: tick)
        }

        addHandlers()

        if let gender = viewModel.user.value?.gender {
            switch gender {
            case .male:
                setGender(with: maleButton)
            case .female:
                setGender(with: femaleButton)

            }
        }
    }

    internal func addHandlers() {
        [femaleButton, maleButton].forEach { button in
            button.addTarget(self, action: #selector(self.handleTap(_:)), for: .touchUpInside)
        }

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

    private func configure(button: UIView, label: UILabel, tick: UIImageView) {
        button.backgroundColor = UIColor.white.withAlphaComponent(0.24)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        tick.alpha = 0.0
    }

    internal func handleTap(_ sender: ButtonWithPreloader) {
        setGender(with: sender)
    }

    internal func setGender(with sender: ButtonWithPreloader) {
        [(femaleButton, femaleButtonLabel, femaleButtonTick), (maleButton, maleButtonLabel, maleButtonTick)].forEach { button, label, tick in
            if button.isEqual(sender) {
                UIView.animate(withDuration: 0.2) {
                    button.backgroundColor = .white
                    label.textColor = self.view.backgroundColor
                    tick.alpha = 1.0
                }
                if let genderString = label.text?.lowercased(), let gender = Gender(rawValue: genderString) {
                    self.viewModel.selectedGender = gender
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    button.backgroundColor = UIColor.white.withAlphaComponent(0.24)
                    label.textColor = UIColor.white.withAlphaComponent(0.7)
                    tick.alpha = 0.0
                }
            }
        }
    }

    private func showNext() {
        performSegue(withIdentifier: String.className(ZipCodeVC.self), sender: self)
    }

    @IBAction func didTapNext(_ sender: Any) {
        guard viewModel.selectedGender != nil else {
            ViewAnimationsUtils.shakeView(view: self.femaleButton)
            ViewAnimationsUtils.shakeView(view: self.maleButton)
            return
        }
        viewModel.updateGender()
    }

    @IBAction func didTapClose(_ sender: Any) {
        UIShowTutorialScreenEvent(.transitionCrossDissolve).send()
    }

}
