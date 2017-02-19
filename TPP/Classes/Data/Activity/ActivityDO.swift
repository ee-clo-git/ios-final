//
//  ActivityDO.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

enum ActivityType: String {
    case survey
    case photo
    case video
    case social
    case comment
    case view = "none"

    func actionTitle() -> String? {
        switch self {
        case .survey:
            return "Take Survey"
        case .photo:
            return "Upload Photo"
        case .video:
            return "Upload Video"
        case .social:
            return "Share or Follow"
        case .comment:
            return "Comment"
        default:
            return nil
        }
    }

    var iconImageName: String {
        switch self {
        case .video:
            return "video_list_icon"
        case .survey:
            return "survey_list_icon"
        case .photo:
            return "photo_list_icon"
        case .social:
            return "social_list_icon"
        case .comment:
            return "survey_list_icon"
        default:
            return "survey_list_icon"
        }
    }
}

enum SocialType: String {
    case twitter
    case facebook
}

struct ActivityDO: Mappable {

    var id: Int?
    var type: ActivityType?
    var socialType: SocialType?
    var socialLink: String?
    var socialText: String?
    var eventId: Int?
    var rewardId: Int?
    var completed: Bool?
    var name: String?
    var surveyLink: String?
    var content: ActivityContentDO?
    var location: LocationDO?
    var questions: [QuestionDO]?
    var questionsCount: Int? // should be used only if surveyLink is present

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        socialType <- map["social_type"]
        socialLink <- map["social_link"]
        socialText <- map["social_text"]
        type <- map["activity_type"]
        eventId <- map["event_id"]
        name <- map["name"]
        rewardId <- map["reward_id"]
        content <- map["content"]
        location <- map["location"]
        questions <- map["questions"]
        completed <- map["completed"]
        surveyLink <- map["survey_link"]
        questionsCount <- map ["num_questions"]
    }

    func activityType() -> UserActivityType? {
        guard let activityId = self.id, let type = self.type else {
            return nil
        }
        switch type {
        case .photo:
            return .photo(activityId)
        case .social:
            return .social(self)
        case .video:
            return .video(activityId)
        case .survey:
            return .survey(self)
        case .comment:
            return .comment(self)
        default:
            return nil
        }
    }
}
