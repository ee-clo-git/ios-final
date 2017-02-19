//
//  ButtonWithCheckMark.swift
//  TPP
//
//  Created by Mihails Tumkins on 03/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import SnapKit

class ButtonWithCheckMark: UIButton {

    var activeTextColor: UIColor?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        isChecked = false
        super.init(frame: .zero)
        self.addSubview(tick)
        tick.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(12)
            make.bottom.equalTo(self).offset(-15)
            make.right.equalTo(self).offset(-12)
        })

        self.setTitleColor(activeTextColor, for: .normal)
        self.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.24)
        self.layer.cornerRadius = 4.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4
    }

    lazy var tick: UIImageView = {
        let image = #imageLiteral(resourceName: "input_tick")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        return imageView
    }()

    var isChecked: Bool {
        didSet {

            if isChecked {
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = .white
                    self.setTitleColor(self.activeTextColor, for: .normal)
                    self.tick.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = UIColor.white.withAlphaComponent(0.24)
                    self.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
                    self.tick.alpha = 0.0
                }
            }
        }
    }

}
