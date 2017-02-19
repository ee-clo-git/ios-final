//
//  MagicLinkVC.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import RxSwift

class MagicLinkVC: UIViewController, EventBusObservable {

    internal var eventBusObserver = EventBusObserver()
    var userData: (email: String, password: String)?
    private let viewModel = SignInViewModel()
    @IBOutlet weak var openMailButton: ButtonWithPreloader!
    internal let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addHandlers()
    }

    private func addHandlers() {
        self.handleUIEvent {[weak self] (event: UIAppUrlEvent) in
            self?.parse(url: event.url)
        }

        self.viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] (loading) in
            self?.openMailButton.showPreloader(show: loading)
        }).addDisposableTo(self.bag)

        self.viewModel.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }
    }

    private func parse(url: URL) {
        if url.host == "password_reset"{
            if let params = url.getKeyVals() {
                let vc: CreateNewPasswordVC = UIStoryboard(storyboard: .Login).instantiateViewController()
                vc.resetParams = params
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if let userData = self.userData {
            viewModel.login(email: userData.email, password: userData.password)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onMagicLinkTap(_ sender: Any) {
        let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.openURL(mailURL)
        }
    }
}
