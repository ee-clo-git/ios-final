//
//  ActivityActionCommentVC.swift
//  TPP
//
//  Created by Igors Nemenonoks on 30/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import STPopup
import Device
import UITextView_Placeholder
import RxSwift

class ActivityActionCommentVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: ButtonWithPreloader!

    var viewModel: ActivityActionCommentViewModel?
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Comment"
        self.textView.placeholder = self.viewModel?.activity.content?.name

        self.contentSizeInPopup = CGSize(width: 300, height: UIScreen.main.bounds.height - (Device.isLargerThanScreenSize(Size.screen4Inch) ? 340 : 300))

        self.addHandlers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.becomeFirstResponder()
    }

    private func addHandlers() {
        self.viewModel?.isLoading.asObservable().subscribe(onNext: {[weak self] (loading) in
            self?.sendButton.showPreloader(show: loading)
        }).addDisposableTo(self.bag)

        self.viewModel?.errorHandler = {[weak self] error in
            self?.showTPPAlert(error: error)
        }

        self.viewModel?.dismissHandler = {[weak self] in
            self?.dismiss()
        }
    }

    @IBAction func onSendTap(_ sender: Any) {

        guard let text = self.textView.text, text.isEmpty == false else {
            ViewAnimationsUtils.shakeView(view: self.textView)
            return
        }
        self.viewModel?.send(comment: text)
    }

    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    private func shareText() {
        let activityViewController = UIActivityViewController(activityItems: [self.textView.text], applicationActivities: nil)

        activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.copyToPasteboard]
        activityViewController.completionWithItemsHandler = {(activity, success, items, error) in
            if success == true {
                //self?.sendActivity()
            }
        }

        self.present(activityViewController, animated: true, completion: nil)
    }

}
