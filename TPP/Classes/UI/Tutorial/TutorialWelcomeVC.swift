//
//  TutorialWelcomeVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 09/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Device

class TutorialWelcomeVC: UIViewController {

    weak var delegate: TutorialVCDelegate?

    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self.navigationController as? TutorialVCDelegate

        if Device.size() == .screen3_5Inch {
            titleLabelTopConstraint.constant = 20
        }
    }

    @IBAction func didTapNext(_ sender: Any) {
        delegate?.present(screen: .location)
    }
}
