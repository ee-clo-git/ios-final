//
//  TPPIconAlertVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 03/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import SnapKit

class TPPIconAlertVC: TPPAlertVC {

    @IBOutlet weak var icon: UIImageView!

    var iconImageName: String?

    func configure(title: String, message: String, action: String, image: String?) {
        super.configure(title: title, message: message, action: action)
        iconImageName = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = self.iconImageName {
            icon.image = UIImage(named: name)
        }
    }
}
