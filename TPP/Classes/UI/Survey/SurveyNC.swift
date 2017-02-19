//
//  SurveyNC.swift
//  TPP
//
//  Created by Mihails Tumkins on 02/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit

protocol SurveyDelegate: class {
    func didTapNext()
    func completed()
}

protocol SurveyQuestion: class {
    func configure()
}

class SurveyNC: BaseNC {

    var viewModel: SurveyViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = .navigationTint
        navigationBar.titleTextAttributes = [
            NSFontAttributeName:UIFont.mainBoldFontWithSize(size: 16)!,
            NSForegroundColorAttributeName:UIColor.navigationTitle]

        self.delegate = self
        self.next(type: viewModel?.currentQuestionType())
    }

    internal func presentMultipleChoise(viewModel: SurveyViewModel?, animated: Bool = false) {
        let storyboard = UIStoryboard(storyboard: .Survey)
        let vc: MultipleChoiseQuestionVC = storyboard.instantiateViewController()
        vc.delegate = self
        vc.viewModel = viewModel
        push(vc, animated: animated)
    }

    internal func presentSingleChoise(viewModel: SurveyViewModel?, animated: Bool = false) {
        let storyboard = UIStoryboard(storyboard: .Survey)
        let vc: SingleChoiseQuestionVC = storyboard.instantiateViewController()
        vc.delegate = self
        vc.viewModel = viewModel
        push(vc, animated: animated)
    }

    internal func presentTextInput(viewModel: SurveyViewModel?, animated: Bool = false) {
        let storyboard = UIStoryboard(storyboard: .Survey)
        let vc: TextInputQuestionVC = storyboard.instantiateViewController()
        vc.delegate = self
        vc.viewModel = viewModel
        push(vc, animated: animated)
    }

    private func push(_ viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: animated)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close_icon"), style: .plain, target: self, action: #selector(closeSurvey))
    }

    internal func closeSurvey() {
        self.dismiss(animated: true, completion: nil)
    }

    func next(type: QuestionType?) {
        if let type = type {
            switch type {
            case .multiple:
                presentMultipleChoise(viewModel: self.viewModel, animated: true)
            case .single:
                presentSingleChoise(viewModel: self.viewModel, animated: true)
            case .text:
                presentTextInput(viewModel: self.viewModel, animated: true)
            }
        } else {
            viewModel?.submit()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SurveyNC: SurveyDelegate {
    func didTapNext() {
        next(type: viewModel?.nextQuestionType())
    }

    func completed() {
        TPPLoadActivityListEvent().send()
        UIShowRewardsEvent().send()
        self.dismiss(animated: true, completion: nil)
    }
}

extension SurveyNC: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if let vc = viewController as? SurveyQuestion {
            if let prev = self.viewModel?.currentQuestionIndex {
                let next = self.viewControllers.count - 1
                self.viewModel?.currentQuestionIndex = next
                if next >= prev {
                    vc.configure()
                }
            }
        }
    }
}
