//
//  RedeemRewardResponseDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 11/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import ObjectMapper

struct RedeemRewardResponseDO: Mappable {
    var code: Int?
    var message: String?
    var user: UserDO?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        user <- map["data.user"]
    }
}
