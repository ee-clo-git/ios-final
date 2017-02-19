//
//  TPPLoginRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

protocol LoginRequest {
    func send() -> Observable<LoginResponseDO>
}

class TPPLoginRequest: TPPBaseRequest, LoginRequest {
    override var requestPath: String { return "auth/sign_in" }
    override var requestMethod: Moya.Method { return .post }

    init(email: String, password: String) {
        let params = ["email": email, "password": password]
        super.init(params: params)
    }

    func send() -> Observable<LoginResponseDO> {
        return super.send() as Observable<LoginResponseDO>
    }
}
