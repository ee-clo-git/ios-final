//
//  LoginResponseDO.swift
//  TPP
//
//  Created by Mihails Tumkins on 27/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

struct LoginResponseDO: Mappable {
    var code: Int?
    var message: String?
    var user: UserDO?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        user <- map["data"]
    }
}
