//
//  TPPTabBarController.swift
//  TPP
//
//  Created by Mihails Tumkins on 09/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit

class TPPTabBarController: UITabBarController, EventBusObservable {

    var highlight: UIView!
    var eventBusObserver = EventBusObserver()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .white
        let size = CGSize(width: tabBar.frame.width / 3.0, height: tabBar.frame.height)
        let image = UIColor.mainViolet.image(of: size)
        highlight = UIImageView(image: image)
        highlight.contentMode = .scaleAspectFill
        highlight.autoresizingMask = .flexibleHeight
        tabBar.insertSubview(highlight, at: 0)
        moveHighlight(to: 0, animated: false)

        self.addHandlers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.items?.forEach {
            $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        }
    }

    private func addHandlers() {
        self.handleUIEvent {[weak self] (event: UIShowRewardsEvent) in
            self?.selectedIndex = 2
            self?.moveHighlight(to: 2, animated: true)
        }
        self.handleUIEvent {[weak self] (event: UIShowFeedEvent) in
            self?.selectedIndex = 0
            self?.moveHighlight(to: 0, animated: true)
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.index(of: item) else { return }
        moveHighlight(to: index, animated: true)

        //always show first screen for rewards
        if index == 2, let nc = self.viewControllers?[index] as? UINavigationController {
            if nc.viewControllers.count > 1 {
                nc.popToRootViewController(animated: false)
            }
        }
    }

    func moveHighlight(to index: Int, animated: Bool = true) {

        let third = tabBar.frame.width / 3.0

        let x = third * CGFloat(index) + third * 0.5 - highlight.frame.width * 0.5
        let y: CGFloat = 0

        if animated {
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 1.0,
                           options: .allowUserInteraction,
                           animations: {
                            self.highlight.frame.origin.x = x
                            self.highlight.frame.origin.y = y
            })
        } else {
            self.highlight.frame.origin.x = x
            self.highlight.frame.origin.y = y
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var shouldAutorotate: Bool {
        if let vc = self.selectedViewController {
            return vc.shouldAutorotate
        }
        return false
    }
}
