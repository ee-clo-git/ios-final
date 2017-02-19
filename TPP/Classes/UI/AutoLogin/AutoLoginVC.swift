//
// Created by Igors Nemenonoks on 23/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AutoLoginVC: UIViewController {

    private var loginViewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        UserService.shared.restoreCredentials {[weak self] (userCredentials) in
            if let credentials = userCredentials, let password = userCredentials?.password {
                self?.loginViewModel.login(email: credentials.email,
                                           password: password)
            } else if let token = FBSDKAccessToken.current() {
                self?.loginViewModel.login(facebookToken: token.tokenString)
            } else {
                UIShowLoginScreenEvent(.transitionCrossDissolve).send()
            }
        }

        self.addHandlers()
    }

    internal func addHandlers() {
        self.loginViewModel.errorHandler = {error in
            if error != nil {
                UIShowLoginScreenEvent(.transitionCrossDissolve).send()
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
