//
//  LoginVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import RxSwift
import SpriteKit

class LoginVC: UIViewController {
    internal let loginManager = FBSDKLoginManager()
    internal let viewModel = SignInViewModel()

    @IBOutlet weak var fbButton: ButtonWithPreloader!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!

    @IBOutlet weak var firstSlogan: UILabel!
    @IBOutlet weak var secondSlogan: UILabel!
    @IBOutlet weak var thirdSlogan: UILabel!

    internal let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.isLoading.asObservable().subscribe(onNext: { [weak self] (val) in
            self?.fbButton.showPreloader(show: val)
        }).addDisposableTo(self.bag)

        addSloganShadows()
        addVideoBackground()
        hideUIElements()
        startInitialAnimation()
    }

    func addVideoBackground() {
        if let view = self.view as! SKView? {
            let scene = LoopScene()

            let bounds = UIScreen.main.bounds
            scene.size = CGSize(width: bounds.width, height: bounds.height)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }

    func addSloganShadows() {
        [firstSlogan, secondSlogan, thirdSlogan].forEach { (label) in
            label?.layer.shadowColor = UIColor.black.cgColor
            label?.layer.shadowOffset = CGSize(width: 0, height: 4)
            label?.layer.shadowRadius = 4
            label?.layer.shadowOpacity = 0.4
        }
    }

    func hideUIElements() {
        let views: [UIView] = [firstSlogan, secondSlogan, thirdSlogan, logoImage, fbButton, signUpButton, signInButton]
        views.forEach { (view) in
            view.alpha = 0.0
        }
    }

    func startInitialAnimation() {
        let views: [UIView] = [logoImage, fbButton, signUpButton, signInButton]

        UIView.performWithoutAnimation {
            view.layoutIfNeeded()
        }

        UIView.animateKeyframes(withDuration: 10,
                                delay: 5.0,
                                options: .calculationModeLinear,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.015, animations: {
                                        self.firstSlogan.alpha = 1.0
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.06, animations: {
                                        self.firstSlogan.alpha = 0.0
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                                        self.secondSlogan.alpha = 1.0
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
                                        self.secondSlogan.alpha = 0.0
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.65, relativeDuration: 0.1, animations: {
                                        self.thirdSlogan.alpha = 1.0
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.05, animations: {
                                        self.thirdSlogan.alpha = 0.0
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.05, animations: {
                                        views.forEach { (view) in view.alpha = 1.0 }
                                    })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func onFbTap(_ sender: Any) {
        guard FBSDKAccessToken.current() == nil else {
            self.doLoginFBUser()
            return
        }

        loginManager.logIn(withReadPermissions: ["email"], from: self) {[weak self] result, error in
            if let error = error {
                self?.showTPPAlert(error: error)
            } else {
                if result?.isCancelled == true {
                    //cancelled
                } else if let fbloginresult: FBSDKLoginManagerLoginResult = result,
                    fbloginresult.grantedPermissions.contains("email") {
                    self?.doLoginFBUser()
                }
            }
        }
    }

    internal func doLoginFBUser() {
        if let token = FBSDKAccessToken.current() {
            self.viewModel.login(facebookToken: token.tokenString)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
