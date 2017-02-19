//
// Created by Igors Nemenonoks on 16/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation

class BGDidLoginEvent: BGEventBusEvent {
    typealias EventResult = BGDidLoginEvent

    var user: UserDO
    var password: String?
    var facebookToken: String?

    init(user: UserDO, password: String? = nil, facebookToken: String? = nil) {
        self.user = user
        self.password = password
        self.facebookToken = facebookToken
    }

}
