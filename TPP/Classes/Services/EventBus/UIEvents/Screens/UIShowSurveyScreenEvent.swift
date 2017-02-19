//
//  UIShowSurveyScreenEvent.swift
//  TPP
//
//  Created by Mihails Tumkins on 02/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Foundation

class UIShowSurveyScreenEvent: UIEventBusEvent {
    typealias EventResult = UIShowSurveyScreenEvent

    let activity: ActivityDO
    var completionHandler: ((ActivityCreateResponseDO) -> Void)?
    var errorHandler: ((Error) -> Void)?

    init(_ activity: ActivityDO,
         errorHandler: ((Error) -> Void)?,
         completion: ((ActivityCreateResponseDO) -> Void)?) {
        self.activity = activity
        self.errorHandler = errorHandler
        self.completionHandler = completion
    }
}
