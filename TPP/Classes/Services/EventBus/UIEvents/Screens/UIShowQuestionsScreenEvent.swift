//
//  UIShowQuestionsScreenEvent.swift
//  TPP
//
//  Created by Mihails Tumkins on 28/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

class UIShowQuestionsScreenEvent: UIEventBusEvent {
    typealias EventResult = UIShowQuestionsScreenEvent

    let transition: UIViewAnimationOptions

    init(_ transition: UIViewAnimationOptions) {
        self.transition = transition
    }
}
