//
//  TPPPostActivityCommentRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPPostActivityCommentRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/user_activities" }
    override var requestMethod: Moya.Method { return Moya.Method.post }

    required init(activityId: Int, comment: String) {
        let params: [String : Any] = [
            "activity_id": activityId,
            "body": comment,
            "content_type": "comment"]
        super.init(params: params)
    }

    func send() -> Observable<ActivityCreateResponseDO> {
        return super.send() as Observable<ActivityCreateResponseDO>
    }
}
