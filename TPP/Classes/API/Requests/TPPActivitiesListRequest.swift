//
//  TPPActivitiesListRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPActivitiesListRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/activities" }
    override var requestMethod: Moya.Method { return .get }

    func send() -> Observable<ActivitiesListResponseDO> {
        return super.send() as Observable<ActivitiesListResponseDO>
    }
}
