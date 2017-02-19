//
// Created by Igors Nemenonoks on 18/02/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {

    func showErrorAlert(error: Error) {
        self.showErrorAlertWithMessage(message: error.localizedDescription)
    }

    func showErrorAlertWithMessage(message: String?) {
        self.showGlobalAlert(title: "Error", message: message)
    }

    func showGlobalAlert(title: String?, message: String?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func showGlobalAlert(title: String?, message: String?, completion: (() -> Void)?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    func openUrl(url: URL, entersReaderIfAvailable: Bool = true) {
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: entersReaderIfAvailable)
        self.present(vc, animated: true)
    }
}

extension UIViewController {
    func showTPPAlert(title: String = "Error", message: String = "Something went wrong", action: String = "OK", completion: (() -> Void)? = nil) {
        let vc: TPPAlertVC = UIStoryboard(storyboard: .TPPAlert).instantiateViewController()
        vc.completionHandler = completion
        vc.configure(title: title, message: message, action: action)

        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false)
    }

    func showTPPIconAlert(title: String = "Error",
                          message: String = "Something went wrong",
                          action: String = "OK",
                          image: String? = "survey_popup_icon",
                          completion: (() -> Void)? = nil) {
        let vc: TPPIconAlertVC = UIStoryboard(storyboard: .TPPAlert).instantiateViewController()
        vc.completionHandler = completion
        vc.configure(title: title, message: message, action: action, image: image)

        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false)
    }

    func showTPPAlert(error: Error, completion: (() -> Void)? = nil) {
        self.showTPPAlert(message: error.localizedDescription, completion: completion)
    }
}
