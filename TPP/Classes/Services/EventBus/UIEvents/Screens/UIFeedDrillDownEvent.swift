//
//  UIFeedDrillDownEvent.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit

class UIFeedDrillDownEvent: UIEventBusEvent {
    typealias EventResult = UIFeedDrillDownEvent
    let type: FeedItemType
    init(type: FeedItemType) {
        self.type = type
    }
}
