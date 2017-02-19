//
//  VIPExperienceResponse.swift
//  TPP
//
//  Created by Igors Nemenonoks on 09/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import ObjectMapper

struct VIPExperienceResponse: Mappable {

    var code: Int?
    var items: [VIPExperience]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        items <- map["data.vip_experiences"]
    }
}
