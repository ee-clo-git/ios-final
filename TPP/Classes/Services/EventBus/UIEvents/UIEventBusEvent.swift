//
// Created by Igors Nemenonoks on 12/02/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation

class UIEventBusEvent: PubSubEvent {

    typealias EventResult = UIEventBusEvent

    class func eventName() -> String {
        return String(describing: self)
    }

    func send() {
        UIEventBus.sharedInstance.send(event:self)
    }

    func event() -> UIEventBusEvent.EventResult {
        return self
    }

}
