//
//  EventPopup.swift
//  TPP
//
//  Created by Mihails Tumkins on 14/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit

protocol EventPopupDelegate: class {
    func didTapUnlock(activity: ActivityDO?)
    func didTapCancel()
}

class EventPopupVC: UIViewController {

    weak var delegate: EventPopupDelegate?
    internal var activity: ActivityDO?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(fade)
        view.addSubview(container)
        container.addSubviews([imageView, titleLabel, descriptionLabel, separator, unlockButton, cancelButton])
        descriptionLabel.addSubview(descriptionLabelIcon)

        layoutConstraints()
        addHandlers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fadeIn()
    }

    func fadeIn() {
        container.layer.transform = CATransform3DMakeScale(0, 0, 0)
        imageView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 40, 0), 0, 0, 0)
        titleLabel.layer.transform = CATransform3DMakeTranslation(0, -20, 0)
        descriptionLabel.layer.transform = CATransform3DMakeTranslation(0, -20, 0)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.fade.alpha = 1.0
                        self.container.alpha = 1.0
                        self.container.layer.transform = CATransform3DIdentity
        })

        UIView.animate(withDuration: 0.6,
                       delay: 0.2,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1.0,
                       options: .allowUserInteraction,
                       animations: {

                        self.imageView.alpha = 1.0
                        self.imageView.layer.transform = CATransform3DIdentity

                        self.titleLabel.alpha = 1.0
                        self.titleLabel.layer.transform = CATransform3DIdentity

                        self.descriptionLabel.alpha = 1.0
                        self.descriptionLabel.layer.transform = CATransform3DIdentity

                        self.separator.alpha = 1.0
                        self.unlockButton.alpha = 1.0
                        self.cancelButton.alpha = 1.0
        })
    }

    func fadeOut(_ completion: (() -> Void)?) {

        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1.0,
                       options: .beginFromCurrentState,
                       animations: {

                        self.imageView.alpha = 0.0
                        self.imageView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 40, 0), 0.0001, 0.0001, 0.0001)

                        self.titleLabel.alpha = 0.0
                        self.titleLabel.layer.transform = CATransform3DMakeTranslation(0, -20, 0)

                        self.descriptionLabel.alpha = 0.0
                        self.descriptionLabel.layer.transform = CATransform3DMakeTranslation(0, -20, 0)

                        self.separator.alpha = 0.0
                        self.unlockButton.alpha = 0.0
                        self.cancelButton.alpha = 0.0
        })

        UIView.animate(withDuration: 0.4,
                       delay: 0.2,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 1.0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.fade.alpha = 0.0
                        self.container.alpha = 0.0
                        self.container.layer.transform = CATransform3DMakeScale(0.0001, 0.0001, 0.0001)
        }) { _ in
            completion?()
        }
    }

    func layoutConstraints() {
        fade.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }

        container.snp.makeConstraints { make in
            make.left.equalTo(fade).offset(15)
            make.right.equalTo(fade).offset(-15)
            make.centerY.equalTo(fade.snp.centerY)
            make.height.equalTo(285)
        }

        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(container.snp.centerX)
            make.centerY.equalTo(container.snp.top).offset(15)
        }

        descriptionLabelIcon.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel.snp.centerY)
            make.left.equalTo(descriptionLabel.snp.left)
        }

        separator.snp.makeConstraints { make in
            make.centerX.equalTo(container.snp.centerX)
            make.centerY.equalTo(container.snp.centerY)
            make.height.equalTo(2)
            make.width.equalTo(55)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(separator.snp.top).offset(-8)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-8)
        }

        unlockButton.snp.makeConstraints { make in
            make.left.equalTo(container).offset(13)
            make.right.equalTo(container).offset(-13)
            make.height.equalTo(48)
            make.top.equalTo(separator.snp.bottom).offset(15)
        }

        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(unlockButton.snp.left)
            make.right.equalTo(unlockButton.snp.right)
            make.height.equalTo(unlockButton.snp.height)
            make.top.equalTo(unlockButton.snp.bottom).offset(15)
        }
    }

    func configure(with item: LocationDO) {
        titleLabel.text = item.name
        imageView.image = item.popupImage
        descriptionLabel.text = item.address
        self.activity = item.activities?.first
        if self.activity?.completed == true {
            self.unlockButton.setTitle("Completed", for: .normal)
            self.unlockButton.isEnabled = false
            self.unlockButton.backgroundColor = UIColor.lightGray
        }
    }

    func addHandlers() {
        unlockButton.addTarget(self, action: #selector(didTapUnlock), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        fade.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCancel)))
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selfie_popup_icon")
        imageView.contentMode = .center
        imageView.alpha = 0.0
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainBoldFontWithSize(size: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Survey"
        label.alpha = 0.0
        return label
    }()

    private lazy var descriptionLabel: TPPLabel = {
        let label = TPPLabel()
        label.font = UIFont.mainFontWithSize(size: 14)
        label.textColor = .popupText
        label.insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.alpha = 0.0
        return label
    }()

    private lazy var descriptionLabelIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location_pin")
        imageView.contentMode = .center
        imageView.alpha = 0.0
        return imageView
    }()

    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.alpha = 0.0
        return view
    }()

    private lazy var unlockButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .popupUnlockButton
        button.setTitle("Share Your Feedback", for: .normal)
        button.tintColor = .white
        button.cornerRadius = 6.0
        button.alpha = 0.0
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.borderWidth = 1.0
        button.borderColor = .popupCancelButton
        button.cornerRadius = 6.0
        button.backgroundColor = .white
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.popupCancelButton, for: .normal)
        button.tintColor = .popupCancelButton
        button.alpha = 0.0
        return button
    }()

    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6.0
        view.alpha = 0.0
        return view
    }()

    private lazy var fade: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.alpha = 0.0
        return view
    }()
}

extension EventPopupVC {
    func didTapUnlock() {
        delegate?.didTapUnlock(activity: self.activity)
    }
    func didTapCancel() {
        delegate?.didTapCancel()
    }
}
