//
//  TPPCreateUserActivityEvent.swift
//  TPP
//
//  Created by Mihails Tumkins on 30/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

enum UserActivityType {
    case photo(Int)
    case video(Int)
    case social(ActivityDO)
    case survey(ActivityDO)
    case comment(ActivityDO)
}

extension UserActivityType: Equatable { }
func == (lhs: UserActivityType, rhs: UserActivityType) -> Bool {
    switch (lhs, rhs) {
    case (let .video(activityId), let .video(activityId2)):
        return activityId == activityId2
    case (let .photo(activityId), let .photo(activityId2)):
        return activityId == activityId2
    case (let .social(activity), let .social(activity2)):
        return activity.id == activity2.id
    default:
        return false
    }
}

class TPPCreateUserActivityEvent: UIEventBusEvent {
    typealias EventResult = TPPCreateUserActivityEvent

    unowned var target: UIViewController
    let type: UserActivityType

    var progressHandler: ((Double) -> Void)?
    var errorHandler: ((Error) -> Void)?
    var completionHandler: ((ActivityCreateResponseDO?) -> Void)?

    init(target: UIViewController, type: UserActivityType,
         progress: ((Double) -> Void)? = nil,
         error: ((Error) -> Void)? = nil,
         completion: ((ActivityCreateResponseDO?) -> Void)? = nil) {
        self.target = target
        self.type = type
        self.progressHandler = progress
        self.errorHandler = error
        self.completionHandler = completion
        super.init()
    }
}
