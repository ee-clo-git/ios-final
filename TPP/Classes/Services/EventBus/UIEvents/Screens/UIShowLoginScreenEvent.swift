//
//  UIShowLoginScreenEvent.swift
//  TPP
//
//  Created by Mihails Tumkins on 22/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

class UIShowLoginScreenEvent: UIEventBusEvent {
    typealias EventResult = UIShowLoginScreenEvent

    let transition: UIViewAnimationOptions

    init(_ transition: UIViewAnimationOptions) {
        self.transition = transition
    }
}
