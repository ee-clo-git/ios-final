//
// Created by Igors Nemenonoks on 17/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import UIKit

class TPPNC: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = .navigationTint
        navigationBar.barTintColor = .mainBackground
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIColor.navbarShadow.image(of: CGSize(width: 1, height: 1))

        navigationBar.titleTextAttributes = [
            NSFontAttributeName:UIFont.mainBoldFontWithSize(size: 16)!,
            NSForegroundColorAttributeName:UIColor.navigationTitle]
        navigationBar.isTranslucent = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
}
