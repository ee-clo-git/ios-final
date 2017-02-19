//
//  SettingsVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 12/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit

class SettingsVC: UIViewController {

    internal let viewModel = SettingsViewModel()
    @IBOutlet weak var tableView: UITableView!

    @IBAction func didTapLogout(_ sender: Any) {
        BGDidLogoutEvent().send()
    }
}

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        return section.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let model = viewModel.sections[indexPath.section].items[indexPath.row]
        cell.configure(for: model)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].name
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = UIFont.mainBoldFontWithSize(size: 13)
            headerView.textLabel?.textColor = .settingsHeaderText
        }
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        switch item.type {
        case .password:
            performSegue(withIdentifier: String.className(ChangePasswordVC.self), sender: self)
        case .profile:
            performSegue(withIdentifier: String.className(EditProfileVC.self), sender: self)
        case .privacy(let urlString), .terms(let urlString):
            if let url = URL(string: urlString) {
                self.openUrl(url: url)
            }
        default:
            break
        }
    }
}
