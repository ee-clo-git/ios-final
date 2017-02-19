//
//  TPPGetRewardsRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class TPPGetRewardsRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/rewards" }
    override var requestMethod: Moya.Method { return Moya.Method.get }

    func send() -> Observable<RewardsResponseDO> {
        return super.send() as Observable<RewardsResponseDO>
    }
}
