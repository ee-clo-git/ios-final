//
// Created by Igors Nemenonoks on 25/06/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation

class BGNetworkReachabilityChangedEvent: BGEventBusEvent {

    typealias EventResult = BGNetworkReachabilityChangedEvent

    var reachable: Bool

    init(reachable: Bool) {
        self.reachable = reachable
        super.init()
    }
}
