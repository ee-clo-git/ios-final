//
// Created by Igors Nemenonoks on 16/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class UIService: PubSubSubscriberProtocol, EventBusObservable {

    static let shared = UIService()
    internal var eventBusObserver = EventBusObserver()

    private var rootWindow: UIWindow? {
        return UIApplication.shared.delegate?.window!
    }

    func registerForEvents() {
        self.handleBGEvent {[weak self] (event: BGDidLoginEvent) in
            DispatchQueue.main.async {
                let key = StorageConfig.firstLogin
                if PrefrencesStorage.shared.restore(key: key) == true {
                    self?.showMainScreen()
                } else {
                    PrefrencesStorage.shared.store(true, key: key)
                    self?.showQuestionsScreen()
                }
            }
        }

        self.handleBGEvent {(event: BGDidLogoutEvent) in
            UIShowLoginScreenEvent(.transitionCrossDissolve).send()
        }

        self.handleUIEvent {[weak self] (event: UIShowTutorialScreenEvent) in
            self?.showTutorialScreen(event.transition)
        }

        self.handleUIEvent {[weak self] (event: UIShowMainScreenEvent) in
            self?.showMainScreen()
        }

        self.handleUIEvent {[weak self] (event: UIShowLoginScreenEvent) in
            self?.showLoginScreen(event.transition)
        }

        self.handleUIEvent {[weak self] (event: UIShowQuestionsScreenEvent) in
            self?.showQuestionsScreen()
        }

        self.handleUIEvent {[weak self] (event: UIShowSurveyScreenEvent) in
            self?.showSurvey(event)
        }
    }

    private func showTutorialScreen(_ transition: UIViewAnimationOptions = .transitionCrossDissolve) {
        if let rootWindow = self.rootWindow {
            let vc = UIStoryboard(storyboard: .Tutorial).instantiateInitialViewController()
            rootWindow.rootViewController = vc
            UIView.transition(with: rootWindow, duration: 0.5, options: transition, animations:nil, completion: nil)
        }
    }

    private func showQuestionsScreen() {
        if let rootWindow = self.rootWindow {
            let vc = UIStoryboard(storyboard: .AdditionalQuestions).instantiateInitialViewController()
            rootWindow.rootViewController = vc
            UIView.transition(with: rootWindow, duration: 0.5, options: .transitionFlipFromRight, animations:nil, completion: nil)
        }
    }

    private func showMainScreen() {
        if let rootWindow = self.rootWindow {
            let vc = UIStoryboard(storyboard: .Main).instantiateInitialViewController()
            rootWindow.rootViewController = vc
            UIView.transition(with: rootWindow, duration: 0.5, options: .transitionFlipFromRight, animations:nil, completion: nil)
        }
    }

    private func showLoginScreen(_ transition: UIViewAnimationOptions) {
        if let rootWindow = self.rootWindow {
            let vc = UIStoryboard(storyboard: .Login).instantiateViewController(withIdentifier: "LoginNC")
            rootWindow.rootViewController = vc
            UIView.transition(with: rootWindow, duration: 0.5, options: transition, animations:nil, completion: nil)
        }
    }

    private func showSurvey(_ event: UIShowSurveyScreenEvent) {
        let rootVc = self.rootWindow?.rootViewController?.presentedViewController ?? self.rootWindow?.rootViewController

        if let surveyUrl = event.activity.surveyLink {
            let vc = SurveyWebVC(url: URL(string: surveyUrl)!)!
            vc.modalPresentationCapturesStatusBarAppearance = true
            vc.activityCompletionHandler = event.completionHandler
            vc.activity = event.activity
            rootVc?.present(TPPNC(rootViewController: vc), animated: true, completion: nil)
            return
        }
        let vc: SurveyNC = UIStoryboard(storyboard: .Survey).instantiateInitialViewController()
        vc.viewModel = {
            let vm = SurveyViewModel(activity: event.activity)
            vm.activityCompletionHandler = event.completionHandler
            return vm
        }()
        rootVc?.present(vc, animated: true, completion: nil)

    }
}
