//
//  ActivityCreateResponseDO.swift
//  TPP
//
//  Created by Mihails Tumkins on 30/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

struct ActivityCreateResponseDO: Mappable {
    var code: Int?
    var message: String?

    var id: Int?
    var userId: Int?
    var url: String?
    var thumb: String?
    var body: String?
    var completed: Bool?

    var activity: ActivityDO?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]

        id <- map["data.id"]
        userId <- map["data.user_id"]
        url <- map["data.url"]
        thumb <- map["data.thumb"]
        body <- map["data.body"]
        completed <- map["data.completed"]

        activity <- map["data.activity"]
    }
}
