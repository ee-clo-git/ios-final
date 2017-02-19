//
//  TPPForgotPasswordRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class TPPForgotPasswordRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/forgot_password" }
    override var requestMethod: Moya.Method { return .post }

    init(email: String) {
        let params = [
            "email": email
        ]
        super.init(params: params)
    }

    func send() -> Observable<SimpleResponseDO> {
        return super.send() as Observable<SimpleResponseDO>
    }
}
