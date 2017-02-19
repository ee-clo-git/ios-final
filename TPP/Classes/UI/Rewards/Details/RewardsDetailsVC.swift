//
//  RewardsDetailsVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift

class RewardsDetailsVC: UIViewController {

    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: TPPLabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var redeemButton: ButtonWithPreloader!

    var buttonName: String = "Enter to Win"

    var viewModel: RewardDetailsViewModel?
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.viewModel?.rewardName()
        self.descriptionTextView.attributedText = self.viewModel?.text()
        priceLabel.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        if let urlStr = self.viewModel?.reward.redeemImageUrl(), let url = URL(string: urlStr) {
            self.detailsImage.kf.setImage(with: url)
        }
        self.redeemButton.setTitle(self.buttonName, for: .normal)
        self.addHandlers()
    }

    private func addHandlers() {
        self.viewModel?.isLoading.asObservable().subscribe(onNext: {[weak self] (loading) in
            self?.redeemButton.showPreloader(show: loading)
        }).addDisposableTo(bag)

        self.viewModel?.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }
    }

    @IBAction func onCloseTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapRedeem(_ sender: Any) {

        guard UserService.shared.user.value?.email != nil else {
            self.showTPPAlert(message: "Please update your email in profile settings") { [weak self] in
                self?.showSettings()
            }
            return
        }

        self.viewModel?.redeem(completion: {[weak self] (message) in
            self?.showDoneAlert(message)
        })
    }

    private func showSettings() {
        let vc: SettingsVC = UIStoryboard(storyboard: .Settings).instantiateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showDoneAlert(_ message: String?) {
        guard let message = message else { return }
        self.showTPPAlert(title: "Done", message: message, completion: { [weak self] in
            _ = self?.navigationController?.popToRootViewController(animated: true)
            UIShowFeedEvent().send()
        })
    }
}

extension RewardsDetailsVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let svc = SFSafariViewController(url:URL)
        if #available(iOS 10.0, *) {
            svc.preferredBarTintColor = .mainViolet
            svc.preferredControlTintColor = .white
        }
        self.present(svc, animated: true, completion: nil)
        return false
    }
}
