//
//  SettingsCell.swift
//  TPP
//
//  Created by Mihails Tumkins on 12/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit

class SettingsCell: UITableViewCell, Reusable {
    override func awakeFromNib() {
        super.awakeFromNib()

        self.addSubview(border)
        border.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(1/UIScreen.main.scale)
        })
    }

    func configure(for model: SettingsItem) {
        self.accessoryType = .disclosureIndicator
        self.textLabel?.textColor = UIColor.settingsText
        self.textLabel?.textAlignment = .left

        switch model.type {
        case .profile, .password, .privacy(_), .terms(_), .about:
            self.textLabel?.text = model.name
            self.backgroundColor = .white
        case .version(let version):
            self.accessoryType = .none
            self.textLabel?.textAlignment = .center
            self.backgroundColor = .clear
            self.textLabel?.text = "\(model.name): \(version)"
        }
    }

    lazy var border: UIView = {
        let border = UIView(frame: CGRect.zero)
        border.backgroundColor = UIColor.separator
        return border
    }()
}
