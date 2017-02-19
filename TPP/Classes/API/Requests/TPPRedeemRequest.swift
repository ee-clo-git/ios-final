//
//  TPPRedeemRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPRedeemRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/rewards/redeem" }
    override var requestMethod: Moya.Method { return .post }

    init(redeemId: String, name: String) {
        super.init(params: [
            "utid": redeemId,
            "name": name
            ])
    }
    func send() -> Observable<RedeemRewardResponseDO> {
        return super.send() as Observable<RedeemRewardResponseDO>
    }
}
