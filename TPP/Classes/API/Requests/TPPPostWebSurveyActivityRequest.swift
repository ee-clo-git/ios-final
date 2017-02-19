//
//  TPPPostWebSurveyActivityRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 24/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPPostWebSurveyActivityRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/user_activities" }
    override var requestMethod: Moya.Method { return Moya.Method.post }

    required init(activityId: Int) {
        let params: [String : Any] = [
            "activity_id": activityId,
            "content_type": "survey"]
        super.init(params: params)
    }

    func send() -> Observable<ActivityCreateResponseDO> {
        return super.send() as Observable<ActivityCreateResponseDO>
    }
}
