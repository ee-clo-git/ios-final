//
//  TPPSendLocationRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 13/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPSendLocationRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/users/me/location" }
    override var requestMethod: Moya.Method { return Moya.Method.put }

    required init(latitude: Double, longitude: Double) {
        super.init(params: ["current_lat": latitude, "current_long": longitude])
    }

    func send() -> Observable<SimpleResponseDO> {
        return super.send() as Observable<SimpleResponseDO>
    }
}
