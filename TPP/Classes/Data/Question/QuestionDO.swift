//
//  QuestionDO.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

enum QuestionType: String {
    case multiple = "multiple"
    case text = "text"
    case single = "single choice"
}

struct QuestionDO: Mappable {

    var id: Int?
    var type: QuestionType?
    var description: String?
    var activityId: String?
    var options: [OptionDO]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        type <- map["question_type"]
        description <- map["description"]
        activityId <- map["activity_id"]
        options <- map["options"]
    }
}
