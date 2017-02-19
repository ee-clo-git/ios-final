//
//  TPPPostSocialActivityRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 23/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPPostSocialActivityRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/user_activities" }
    override var requestMethod: Moya.Method { return Moya.Method.post }

    required init(activityId: Int, type: SocialType) {
        let params: [String : Any] = [
            "activity_id": activityId,
            "content_type": type.rawValue]
        super.init(params: params)
    }

    func send() -> Observable<ActivityCreateResponseDO> {
        return super.send() as Observable<ActivityCreateResponseDO>
    }
}
