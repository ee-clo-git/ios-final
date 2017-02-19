//
// Created by Igors Nemenonoks on 07/06/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit

class ButtonWithPreloader: UIButton {

    private var defaultColor: UIColor?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
        })
        self.defaultColor = self.titleColor(for: .normal)
        return indicator
    }()

    func showPreloader(show: Bool) {
        self.isUserInteractionEnabled = !show
        self.alpha = show ? 0.4 : 1.0
        if show {
            self.activityIndicator.startAnimating()
            self.setTitleColor(UIColor.clear, for: .normal)
        } else {
            self.setTitleColor(self.defaultColor, for: .normal)
            self.activityIndicator.stopAnimating()
        }
    }

    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.4
        }
    }

}
