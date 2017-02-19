//
//  ActivitiesListResponseDO.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

struct ActivitiesListResponseDO: Mappable {
    var code: Int?
    var message: String?
    var surveys: [ActivityDO]?
    var videos: [ActivityDO]?
    var photos: [ActivityDO]?
    var social: [ActivityDO]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        surveys <- map["data.activities.surveys"]
        videos <- map["data.activities.video_activities"]
        photos <- map["data.activities.photo_activities"]
        social <- map["data.activities.social_activities"]
    }
}
