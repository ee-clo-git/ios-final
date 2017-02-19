//
//  TPPAlertVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 26/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import SnapKit

class TPPAlertVC: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    var completionHandler: (() -> Void)?

    var titleLabelText: String?
    var messageLabelText: String?
    var actionText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.0)

        roundedView.layer.cornerRadius = 6.0
        roundedView.layer.shadowColor = UIColor.black.cgColor
        roundedView.layer.shadowOffset = .zero
        roundedView.layer.shadowOpacity = 0.2
        roundedView.layer.shadowRadius = 4
        actionButton.layer.cornerRadius = 6.0

        titleLabel.text = titleLabelText
        messageLabel.text = messageLabelText
        actionButton.setTitle(actionText, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        roundedView.alpha = 0.0
        roundedView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)

        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            self.roundedView.alpha = 1.0
            self.roundedView.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }

    func configure(title: String, message: String, action: String) {
        titleLabelText = title
        messageLabelText = message
        actionText = action
    }

    @IBAction func didTapButton(_ sender: UIButton) {

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 2,
                       options: .allowUserInteraction,
                       animations: {
                        self.roundedView.alpha = 0.0001
                        self.roundedView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1)
                        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
                        self.view.layoutIfNeeded()
        }, completion: {[weak self] _ in
            self?.dismiss(animated: true, completion: {
                self?.completionHandler?()
            })
        })
    }
}
