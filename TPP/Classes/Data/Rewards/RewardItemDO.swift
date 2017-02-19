//
//  RewardItemDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import ObjectMapper

struct RewardItemDO: Mappable {
    var utid: String?
    var rewardName: String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        utid <- map["utid"]
        rewardName <- map["rewardName"]
    }
}
