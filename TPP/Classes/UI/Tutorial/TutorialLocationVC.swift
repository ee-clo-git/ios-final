//
//  TutorialLocationVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 09/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Device

class TutorialLocationVC: UIViewController {

    weak var delegate: TutorialVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self.navigationController as? TutorialVCDelegate
    }

    @IBAction func didTapAddLocation(_ sender: Any) {
        delegate?.enableLocationServices()
    }
}
