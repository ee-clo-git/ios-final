//
//  LoopScene.swift
//  TPP
//
//  Created by Mihails Tumkins on 01/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import SpriteKit
import AVFoundation

class LoopScene: SKScene {

    private var player: AVPlayer!
    private var video: SKVideoNode!

    override func didMove(to view: SKView) {

        if let viewBackgroundColor = view.backgroundColor {
            self.backgroundColor = viewBackgroundColor
        }

        setupIntro()
    }

    func setupIntro() {
        guard let fileUrl = Bundle.main.url(forResource: "01_main", withExtension: "mov") else { return }
        player = nil

        player = AVPlayer(url: fileUrl)
        video = SKVideoNode(avPlayer: player)

        video.size = size
        video.position = CGPoint(x: frame.midX, y: frame.midY )
        video.zPosition = -1
        video.alpha = 0
        addChild(video)
        video.play()
        video.run(SKAction.fadeIn(withDuration: 0.5))
        NotificationCenter.default.addObserver(self, selector: #selector(afterIntro),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }

    func afterIntro() {
        setupLoop()
    }

    func setupLoop() {
        guard let fileUrl = Bundle.main.url(forResource: "02_loop", withExtension: "mov") else { return }

        // remove prev observer
        NotificationCenter.default.removeObserver(self)

        player = AVPlayer(url: fileUrl)
        video = SKVideoNode(avPlayer: player)

        video.size = size
        video.position = CGPoint(x: frame.midX, y: frame.midY )
        video.zPosition = -1
        addChild(video)
        video.play()
        NotificationCenter.default.addObserver(self, selector: #selector(afterLoop),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }

    func afterLoop() {
         guard let currentItem = player.currentItem else { return }
         currentItem.seek(to: kCMTimeZero)
         player.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
