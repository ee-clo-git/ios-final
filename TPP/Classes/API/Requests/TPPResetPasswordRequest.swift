//
//  TPPResetPasswordRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class TPPResetPasswordRequest: TPPBaseRequest {
    override var requestPath: String { return "auth/password" }
    override var requestMethod: Moya.Method { return .put }

    init(password: String, otherParams: [String: String]?) {
        let params = [
            "password": password,
            "password_confirmation": password
        ]
        super.init(params: params)
        if let otherParams = otherParams {
            var headers = otherParams
            headers["token-type"] = "Bearer"
            if let uid = headers["uid"] {
                headers["uid"] = uid.removingPercentEncoding!
            }
            self.forceHeaders = headers
        }
    }

    func send() -> Observable<LoginResponseDO> {
        return super.send() as Observable<LoginResponseDO>
    }
}
