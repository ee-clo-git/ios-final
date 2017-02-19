//
//  TPPRedeemVipRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 11/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPRedeemVipRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/vip_experiences/\(redeemId)/redeem" }
    override var requestMethod: Moya.Method { return .post }

    let redeemId: String

    init(redeemId: String) {
        self.redeemId = redeemId
        super.init()
    }
    func send() -> Observable<RedeemRewardResponseDO> {
        return super.send() as Observable<RedeemRewardResponseDO>
    }
}
