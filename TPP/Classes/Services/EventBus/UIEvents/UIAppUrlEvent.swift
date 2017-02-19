//
//  UIAppUrlEvent.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit

class UIAppUrlEvent: UIEventBusEvent {
    typealias EventResult = UIAppUrlEvent
    var url: URL

    init(url: URL) {
        self.url = url
    }
}
