//
// Created by Igors Nemenonoks on 12/02/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation

class BGEventBusEvent: PubSubEvent {

    typealias EventResult = BGEventBusEvent

    class func eventName() -> String {
        return String(describing: self)
    }

    func send() {
        BGEventBus.sharedInstance.send(event: self)
    }

    func event() -> BGEventBusEvent.EventResult {
        return self
    }
}
