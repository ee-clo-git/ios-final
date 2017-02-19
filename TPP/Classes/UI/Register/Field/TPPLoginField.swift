//
//  TPPLoginField.swift
//  TPP
//
//  Created by Igors Nemenonoks on 09/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class TPPLoginField: UIView {

    @IBInspectable var titleLabelText: String?
    @IBInspectable var textFieldText: String?

    @IBInspectable var isSecure: Bool = false
    @IBInspectable var capitalized: Bool = false
    @IBInspectable var isEmail: Bool = false

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = self.titleLabelText
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        return titleLabel
    }()

    lazy var textField: TPPTextField = {
        let textField = TPPTextField()
        textField.insets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        textField.autocapitalizationType = self.capitalized ? .sentences : .none
        textField.autocorrectionType = .no
        textField.text = self.textFieldText
        textField.isSecureTextEntry = self.isSecure
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.tintColor = .white
        textField.textColor = .white
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        if self.isEmail {
            textField.keyboardType = .emailAddress
        }
        return textField
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.textField.borderStyle = .none
        self.addSubview(textField)
        self.addSubview(titleLabel)

        layoutConstraints()
        addHandlers()
    }

    func layoutConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.bottom.equalTo(-8)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }
    }

    func addHandlers() {
        let _ = self.textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: {[weak self] in
            self?.focus(focused:true)
        })

        let _ = self.textField.rx.controlEvent(.editingDidEnd).subscribe(onNext: {[weak self] in
            self?.focus(focused:false)
        })
    }

    func focus(focused: Bool) {
        self.textField.backgroundColor = focused ? .white : .clear
        self.textField.textColor = focused ? .mainViolet : .white
        self.textField.tintColor = focused ? .mainViolet : .white
        _ = focused ? textField.becomeFirstResponder() : textField.resignFirstResponder()
    }
}

extension TPPLoginField : TPPValidatedFieldProtocol {
    var text: String? {
        return self.textField.text
    }

    func set(text: String) {
        self.textField.text = text
        self.focus(focused: !text.isEmpty)
    }
}
