//
//  FeedViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 12/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

enum FeedItemType: String {
    case survey = "survey"
    case photo = "photo"
    case video = "video"
    case social = "social"

    var image: UIImage? {
        switch self {
        case .survey:
            return UIImage(named: "survey_icon")
        case .photo:
            return UIImage(named: "photo_icon")
        case .video:
            return UIImage(named: "video_icon")
        case .social:
            return UIImage(named: "social_icon")
        }
    }

    func getActivityType() -> ActivityType? {
        return ActivityType(rawValue: self.rawValue)
    }
}

struct FeedItem {
    var title: String?
    var description: String?
    var color: UIColor?
    var type: FeedItemType?
    var date: Date?

    func itemsCount() -> Int {
        guard let type = self.type else {
            return 0
        }
        switch type {
        case .survey:
            return TPPActivityService.shared.surveyActivities.value.count
        case .video:
            return TPPActivityService.shared.videoActivities.value.count
        case .photo:
            return TPPActivityService.shared.photoActivities.value.count
        case .social:
            return TPPActivityService.shared.socialActivities.value.count
        }
    }
}

class FeedViewModel {
    let items: [FeedItem] = [
        FeedItem(title: "Feedback",
                 description: "",
                 color: UIColor(red:0.21, green:0.53, blue:0.78, alpha:1.00),
                 type: .survey,
                 date: Date()),
        FeedItem(title: "Photo Content",
                 description: "",
                 color: UIColor(red:0.98, green:0.67, blue:0.11, alpha:1.00),
                 type: .photo,
                 date: Date()),
        FeedItem(title: "Video Content",
                 description: "",
                 color: UIColor(red:0.56, green:0.78, blue:0.29, alpha:1.00),
                 type: .video,
                 date: Date()),
        FeedItem(title: "Social",
                 description: "",
                 color: UIColor(red:0.35, green:0.51, blue:0.76, alpha:1.00),
                 type: .social,
                 date: Date())
        ]
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            TPPLoadActivityListEvent().send()
        }
    }

    func indexPathFor(type: FeedItemType) -> IndexPath? {
        for (index, item) in self.items.enumerated() {
            if item.type == type {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }
}
