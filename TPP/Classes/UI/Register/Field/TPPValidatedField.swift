//
//  TPPValidatedField.swift
//  TPP
//
//  Created by Mihails Tumkins on 07/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Device

protocol TPPValidatedFieldProtocol {
    var text: String? {get}
    func set(text: String)
}

class TPPValidatedField: UIView {

    @IBInspectable weak var icon: UIImage?

    @IBInspectable weak var textFieldColor: UIColor?
    @IBInspectable weak var bottomBorderColor: UIColor?

    @IBInspectable var titleLabelText: String?
    @IBInspectable var textFieldText: String?

    @IBInspectable var isSecure: Bool = false
    @IBInspectable var capitalized: Bool = false

    @IBInspectable var hasValidationIcon: Bool = true

    lazy var titleLabel: TPPLabel = {
        let titleLabel = TPPLabel()
        titleLabel.insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        titleLabel.text = self.titleLabelText
        titleLabel.textColor = .fieldLabelTextInactive
        titleLabel.isUserInteractionEnabled = true

        if Device.size() == .screen3_5Inch || Device.size() == .screen4Inch {
            titleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }

        return titleLabel
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = self.textFieldColor
        textField.autocapitalizationType = self.capitalized ? .sentences : .none
        textField.autocorrectionType = .no
        textField.text = self.textFieldText
        textField.isSecureTextEntry = self.isSecure
        textField.textAlignment = .right
        if Device.size() == .screen3_5Inch || Device.size() == .screen4Inch {
            textField.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        }
        return textField
    }()

    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.backgroundColor = self.textFieldColor
        iconView.alpha = 0.0001
        iconView.contentMode = .center
        iconView.image = self.icon
        iconView.isUserInteractionEnabled = true
        return iconView
    }()

    lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = self.bottomBorderColor
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        self.addSubview(textField)
        self.addSubview(titleLabel)
        if hasValidationIcon {
            self.addSubview(iconView)
        }
        self.addSubview(bottomBorder)

        layoutConstraints()
        addHandlers()
    }

    func layoutConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.left.equalTo(self.snp.left).offset(6)
        }
        if hasValidationIcon {
            iconView.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right)
                make.width.equalTo(32)
                make.bottom.equalTo(0)
                make.top.equalTo(0)
            }

            textField.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.right.equalTo(iconView.snp.left)
                make.left.equalTo(titleLabel.snp.right).offset(6).priority(500)
            }
        } else {
            textField.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                make.right.equalTo(-6)
                make.left.equalTo(titleLabel.snp.right).offset(6).priority(500)
            }
        }

        bottomBorder.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
    }

    func addHandlers() {
        let _ = self.textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: {[weak self] in
            self?.focus(focused:true)
        })

        let _ = self.textField.rx.controlEvent(.editingDidEnd).subscribe(onNext: {[weak self] in
            self?.focus(focused:false)
        })

        if hasValidationIcon {
            let _ = self.textField.rx.text.subscribe(onNext: {[weak self] (str) in
                if let str = str {
                    self?.iconView.alpha = str.isEmpty ? 0.0001 : 1.0
                }
            })
            let iconTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapField(_:)))
            iconView.addGestureRecognizer(iconTapRecognizer)
        }

        let titleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapField(_:)))
        titleLabel.addGestureRecognizer(titleTapRecognizer)
    }

    internal func didTapField(_ sender: UITapGestureRecognizer) {
        focus(focused: true)
    }

    func focus(focused: Bool) {
        self.titleLabel.backgroundColor = focused ? .fieldLabelBackgroundActive : .fieldLabelBackgroundInactive
        self.titleLabel.textColor = focused ? .fieldLabelTextActive : .fieldLabelTextInactive
        let _ = focused ? textField.becomeFirstResponder() : textField.resignFirstResponder()
    }
}

extension TPPValidatedField : TPPValidatedFieldProtocol {
    var text: String? {
        return self.textField.text
    }

    func set(text: String) {
        self.textField.text = text
        self.focus(focused: !text.isEmpty)
    }
}
