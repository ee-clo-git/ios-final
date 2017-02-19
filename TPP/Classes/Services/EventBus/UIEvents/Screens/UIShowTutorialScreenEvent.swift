//
// Created by Igors Nemenonoks on 17/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import UIKit

class UIShowTutorialScreenEvent: UIEventBusEvent {
    typealias EventResult = UIShowTutorialScreenEvent

    let transition: UIViewAnimationOptions

    init(_ transition: UIViewAnimationOptions) {
        self.transition = transition
    }
}
