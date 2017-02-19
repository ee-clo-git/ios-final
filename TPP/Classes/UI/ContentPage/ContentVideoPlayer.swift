//
//  ContentVideoPlayer.swift
//  MoheganSun
//
//  Created by Igors Nemenonoks on 04/10/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import AVKit

class ContentVideoPlayer: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var shouldAutorotate: Bool {
        return true
    }

}
