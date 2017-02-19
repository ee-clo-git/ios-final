//
//  TutorialNC.swift
//  TPP
//
//  Created by Mihails Tumkins on 09/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit
import AirshipKit
import CoreLocation

protocol TutorialVCDelegate: class {
    func enableLocationServices()
    func enableNotifications()
    func present(screen: TutorialStoryboard)
}

enum TutorialStoryboard: String {
    case welcome = "TutorialWelcomeVC"
    case location = "TutorialLocationVC"
    case notifications = "TutorialNotificationsVC"

    func getViewController() -> UIViewController? {
        return UIStoryboard(storyboard: .Tutorial).instantiateViewController(withIdentifier: self.rawValue)
    }

    func getTutorialPage() -> Int {
        switch self {
        case .welcome:
            return 0
        case .location:
            return 0
        case .notifications:
            return 1
        }
    }
}

class TutorialNC: BaseNC {

    var pageControl: TutorialPageControl!
    var locationService = LocationService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl = TutorialPageControl(numberOfPages: 2)
        navigationBar.addSubview(pageControl)

        pageControl.snp.makeConstraints({ (make) in
            make.centerX.equalTo(navigationBar)
            make.centerY.equalTo(navigationBar)
            make.height.equalTo(3)
            make.width.equalTo(35)
        })

        present(screen: .location, animated: false)
    }

    func present(screen: TutorialStoryboard, animated: Bool = true) {
        if let vc = screen.getViewController() {
            pushViewController(vc, animated: animated)
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTutorial))
            pageControl.setCurrentPage(page: screen.getTutorialPage(), animated: true)
            pageControl.alpha = screen == .welcome ? 0 : 1.0
        }
    }

    func skipTutorial() {
        UIShowMainScreenEvent().send()
    }
}

extension TutorialNC: TutorialVCDelegate {
    func enableLocationServices() {
        if locationService.isAuthorized() {
            self.present(screen: .notifications, animated: true)
        } else {
            locationService.delegate = self
            locationService.authorize()
        }
    }

    func enableNotifications() {
        UAirship.push().notificationOptions = [.alert, .badge, .sound]
        UAirship.push().userPushNotificationsEnabled = true

        UIShowMainScreenEvent().send()
    }

    func present(screen: TutorialStoryboard) {
        self.present(screen: screen, animated: true)
    }
}

extension TutorialNC: LocationServiceDelegate {
    func authFailed(with status: CLAuthorizationStatus) {
        self.present(screen: .notifications, animated: true)
    }
    func authSuccess(with status: CLAuthorizationStatus) {
        self.present(screen: .notifications, animated: true)
    }
    func didUpdateLocation(location: CLLocation) {}
}
