//
//  SingleChoiseQuestionVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 03/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Foundation

class SingleChoiseQuestionVC: MultipleChoiseQuestionVC {

    override internal func didTapAnswer(_ sender: ButtonWithCheckMark) {
        buttons?.forEach { button in
            if button.isEqual(sender) {
                button.isChecked = true
            } else {
                button.isChecked = false
            }
        }
    }

    override internal func saveAnswer() {
        guard let buttons = self.buttons else { return }
        for (index, button) in buttons.enumerated() {
            if button.isChecked {
                viewModel?.answer(index: index)
            }
        }
        delegate?.didTapNext()
    }
}
