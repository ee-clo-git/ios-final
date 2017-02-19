//
//  SettingsQuestionsVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import Eureka

class SettingsQuestionsVC: FormViewController {

    let viewModel = AdditionalQuestionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        form = self.aboutSection() +++ self.detailsSection()
    }

    private func aboutSection() -> Section {
        return Section(self.viewModel.sectionTitles[0])
            <<< DateRow() {
                $0.value = self.viewModel.getBirthDate() ?? Date()
                $0.title = self.viewModel.rowTitles[0]
                }.onChange {
                    if let date = $0.value { self.viewModel.updateBirthday(date: date) }
                }

            <<< ActionSheetRow<String>() {
                $0.title = self.viewModel.rowTitles[3]
                $0.selectorTitle = self.viewModel.rowTitles[3]
                $0.options = self.viewModel.genderOptions
                $0.value = self.viewModel.user.value?.gender?.rawValue.capitalized ?? nil
                }.onChange {
                    self.viewModel.updateGender(value: $0.value)
                }

            <<< ZipCodeRow() {
                $0.title = self.viewModel.rowTitles[6]
                if let zip = self.viewModel.user.value?.zip {
                    $0.value = zip
                }
                }.cellSetup { cell, row in
                    cell.textField.textColor = .gray
                }.cellUpdate { cell, row in
                    cell.textField.textColor = .gray
                }.onChange {
                    if let zipCode = $0.value {
                        self.viewModel.updateZipCode(zipCode: zipCode)
                    }
                }
    }

    private func detailsSection() -> Section {
        return Section(self.viewModel.sectionTitles[1])
            <<< ActionSheetRow<String>() {
                $0.title = self.viewModel.rowTitles[5]
                $0.selectorTitle = self.viewModel.rowTitles[5]
                $0.options = self.viewModel.ethnicityOptions
                $0.value = self.viewModel.user.value?.ethnicity?.rawValue ?? nil
                }.onChange {
                    self.viewModel.updateEthnicity(value: $0.value)
            }

            <<< ActionSheetRow<String>() {
                $0.title = self.viewModel.rowTitles[1]
                $0.selectorTitle = self.viewModel.rowTitles[1]
                $0.options = self.viewModel.hhiOptions
                $0.value = self.viewModel.user.value?.hhi?.textValue ?? nil
                }.onChange {
                    self.viewModel.updateHHI(value: $0.value)
            }

            <<< ActionSheetRow<String>() {
                $0.title = self.viewModel.rowTitles[2]
                $0.selectorTitle = self.viewModel.rowTitles[2]
                $0.options = self.viewModel.maritalOptions
                $0.value = self.viewModel.user.value?.maritalStatus?.rawValue.capitalized ?? nil
                }.onChange {
                    self.viewModel.updateMaritalStatus(value: $0.value)
            }

            <<< ActionSheetRow<String>() {
                $0.title = self.viewModel.rowTitles[4]
                $0.selectorTitle = self.viewModel.rowTitles[4]
                $0.options = self.viewModel.childrenOptions
                $0.value = self.viewModel.user.value?.presenceOfChildren?.textValue ?? nil
                }.onChange {
                    self.viewModel.updateChildren(value: $0.value)
            }
    }
}
