//
// Created by Igors Nemenonoks on 12/02/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation

class BGApplicationDidBecomeActiveEvent: BGEventBusEvent {

    typealias EventResult = BGApplicationDidBecomeActiveEvent

    var fromBackground: Bool = false
    var backgroundTime: TimeInterval?

    init(fromBackground: Bool) {
        self.fromBackground = fromBackground
    }

    init(fromBackground: Bool, backgroundTime: TimeInterval) {
        self.fromBackground = fromBackground
        self.backgroundTime = backgroundTime
    }

}
