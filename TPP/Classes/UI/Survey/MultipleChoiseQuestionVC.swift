//
//  MultipleChoiseQuestionVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 02/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import SnapKit
import Device
import RxSwift

class MultipleChoiseQuestionVC: UIViewController, SurveyQuestion {

    var viewModel: SurveyViewModel?
    weak var delegate: SurveyDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: ButtonWithPreloader!

    var buttons: [ButtonWithCheckMark]?

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.addSubview(titleLabel)

        var topOffset = 165.0
        if Device.isSmallerThanScreenSize(.screen4Inch) {
            topOffset = 100.0
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topOffset)
            make.width.equalTo(self.view).offset(-60)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }

        addHandlers()
    }

    internal func addHandlers() {
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
    }

    func configure() {
        // TODO remove
        view.backgroundColor = viewModel?.randomColor()

        nextButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)

        navigationItem.title = viewModel?.pageTitle()
        titleLabel.text = viewModel?.questionTitle()

        if let answers = viewModel?.questionAnswers() {
            buttons = answers.map({ option in
                let button = ButtonWithCheckMark()
                button.activeTextColor = view.backgroundColor
                button.setTitle(option.description, for: .normal)
                button.addTarget(self, action: #selector(self.didTapAnswer(_:)), for: .touchUpInside)
                return button
            })

            if let buttons = self.buttons {
                let stackView = UIStackView(arrangedSubviews: buttons)
                stackView.distribution = .fillEqually
                stackView.spacing = 3.0
                stackView.axis = .vertical

                scrollView.addSubview(stackView)

                buttons.forEach({ button in
                    button.snp.makeConstraints({ (make) in
                        make.height.equalTo(48)
                        make.left.equalTo(self.view).offset(30)
                        make.right.equalTo(self.view).offset(-30)
                    })
                })

                stackView.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
                    make.left.equalTo(self.view).offset(30)
                    make.right.equalTo(self.view).offset(-30)
                    make.bottom.equalTo(-10)
                })
            }
        }

    }

    internal func didTapAnswer(_ sender: ButtonWithCheckMark) {
        sender.isChecked = !sender.isChecked
    }

    @IBAction func didTapNext(_ sender: Any) {
        let notChecked = buttons?.filter { $0.isChecked == true }.isEmpty
        if notChecked == true {
            buttons?.forEach { ViewAnimationsUtils.shakeView(view: $0) }
            return
        }
        saveAnswer()
    }

    internal func saveAnswer() {
        var selectedIndexes = [Int]()
        guard let buttons = self.buttons else { return }
        for (index, button) in buttons.enumerated() {
            if button.isChecked {
                selectedIndexes.append(index)
            }
        }
        viewModel?.answer(indexes: selectedIndexes)
        delegate?.didTapNext()
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        if Device.isSmallerThanScreenSize(.screen4Inch) {
            label.font = UIFont.mainBoldFontWithSize(size: 29)
        } else {
            label.font = UIFont.mainBoldFontWithSize(size: 36)
        }
        return label
    }()
}
