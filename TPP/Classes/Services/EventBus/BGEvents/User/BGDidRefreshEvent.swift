//
//  BGDidRefreshEvent.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Foundation

class BGDidRefreshEvent: BGEventBusEvent {
    typealias EventResult = BGDidRefreshEvent

    var user: UserDO
    init(user: UserDO) {
        self.user = user
    }

}
