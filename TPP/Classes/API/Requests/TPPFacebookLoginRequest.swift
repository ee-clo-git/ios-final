//
//  TPPFacebookLoginRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 16/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPFacebookLoginRequest: TPPBaseRequest, LoginRequest {
    override var requestPath: String { return "auth/facebook" }
    override var requestMethod: Moya.Method { return .post }

    init(token: String) {
        let params = ["token": token]
        super.init(params: params)
    }

    func send() -> Observable<LoginResponseDO> {
        return super.send() as Observable<LoginResponseDO>
    }
}
