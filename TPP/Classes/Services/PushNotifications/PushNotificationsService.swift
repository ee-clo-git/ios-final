//
//  PushNotificationsService.swift
//  TPP
//
//  Created by Igors Nemenonoks on 28/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import AirshipKit

class PushNotificationsService: PubSubSubscriberProtocol, EventBusObservable {
    static let shared = PushNotificationsService()
    var eventBusObserver = EventBusObserver()

    private var lastAps: [AnyHashable : Any]?

    func registerForEvents() {
        let config = UAConfig.default()
        UAirship.takeOff(config)

        self.handleBGEvent { (event: BGDidLoginEvent) in

            DispatchQueue.main.async {
                self.setupAirship(user: event.user)
            }

            if let lastAps = self.lastAps {
                self.handle(userInfo: lastAps)
            }
        }
    }

    func setupAirship(user: UserDO) {
        UAirship.namedUser().identifier = user.email

        let identifiers = UAirship.shared().analytics.currentAssociatedDeviceIdentifiers()

        // Add a custom identifier
        if let gender = user.gender {
            identifiers.setIdentifier(gender.rawValue, forKey:"gender")
        }
        if let zip = user.zip {
            identifiers.setIdentifier(zip, forKey:"zip")
        }
        if let ethnicity = user.ethnicity {
            identifiers.setIdentifier(ethnicity.rawValue, forKey:"ethnicity")
        }
        if let hhi = user.hhi {
            identifiers.setIdentifier(String(hhi.rawValue), forKey:"hhi")
        }
        if let maritalStatus = user.maritalStatus {
            identifiers.setIdentifier(String(maritalStatus.rawValue), forKey:"maritalStatus")
        }
        if let presenceOfChildren = user.presenceOfChildren {
            identifiers.setIdentifier(String(presenceOfChildren.rawValue), forKey:"presenceOfChildren")
        }

        // Associate the identifiers
        UAirship.shared().analytics.associateDeviceIdentifiers(identifiers)
    }

    func handle(userInfo: [AnyHashable : Any]) {
        guard UserService.shared.user.value != nil else {
            self.lastAps = userInfo
            return
        }
        UIShowFeedEvent().send()
        if let feedTypeString = userInfo["content_type"] as? String, let feedType = FeedItemType(rawValue: feedTypeString) {
            UIFeedDrillDownEvent(type: feedType).send()
        }
        self.lastAps = nil
    }
}
