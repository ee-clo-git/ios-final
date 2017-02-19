//
//  TPPRegisterRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPRegisterRequest: TPPBaseRequest {
    override var requestPath: String { return "auth" }
    override var requestMethod: Moya.Method { return .post }

    init(email: String,
         firstName: String,
         lastName: String,
         phone: String,
         password: String,
         utid: String) {
        let params = ["email": email,
                      "first_name": firstName,
                      "last_name": lastName,
                      "phone": phone,
                      "password": password,
                      "utid": utid]
        super.init(params: params)
    }

    func send() -> Observable<RegisterResponseDO> {
        return super.send() as Observable<RegisterResponseDO>
    }
}
