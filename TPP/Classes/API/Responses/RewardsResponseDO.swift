//
//  RewardsResponseDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import ObjectMapper

struct RewardsResponseDO: Mappable {
    var code: Int?
    var items: [RewardDO]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        items <- map["data"]
    }
}
