//
// Created by Igors Nemenonoks on 12/10/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import ObjectMapper

struct SimpleResponseDO: Mappable {
    var code: Int?
    var message: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
