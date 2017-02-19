//
//  OptionDO.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

struct OptionDO: Mappable {

    var id: Int?
    var description: String?
    var questionId: Int?

    init?(map: Map) {

    }

    init(id: Int?, description: String?, questionId: Int?) {
        self.id = id
        self.description = description
        self.questionId = questionId
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        questionId <- map["question_id"]
    }
}
