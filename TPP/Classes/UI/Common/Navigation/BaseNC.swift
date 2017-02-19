//
// Created by Igors Nemenonoks on 04/08/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import UIKit

class BaseNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let vc = self.topViewController {
            return vc.supportedInterfaceOrientations
        }
        return [.portrait]
    }

    override var shouldAutorotate: Bool {
        if let vc = self.topViewController {
            return vc.shouldAutorotate
        }
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
