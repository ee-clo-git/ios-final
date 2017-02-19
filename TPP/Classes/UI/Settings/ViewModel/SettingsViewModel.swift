//
//  SettingsViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 12/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

let termsURLString = "http://tpp.frllive.com/terms_of_usage.pdf"
let privacyURLString = "http://tpp.frllive.com/privacy_policy.pdf"

enum SettingsType {
    case profile
    case password
    case privacy(String)
    case terms(String)
    case about
    case version(String)
}

struct SettingsItem {
    var name: String
    var type: SettingsType
}

struct SettingsSection {
    var name: String
    var items: [SettingsItem]
}

class SettingsViewModel: BaseViewModel {
    let sections = [
        SettingsSection(name: "ACCOUNT", items: [
            SettingsItem(name: "Edit Profile", type: .profile),
            SettingsItem(name: "Password", type: .password)
            ]),
        SettingsSection(name: "OTHER", items: [
            SettingsItem(name: "Privacy Policy", type: .privacy(privacyURLString)),
            SettingsItem(name: "Terms of Use", type: .terms(termsURLString)),
            //SettingsItem(name: "About", type: .about),
            SettingsItem(name: "Version", type: .version("1.0"))
            ])
    ]
}
