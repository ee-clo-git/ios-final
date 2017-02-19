//
//  TPPGetCurrentUserRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 09/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class TPPGetCurrentUserRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/users/me" }
    override var requestMethod: Moya.Method { return .get }

    func send() -> Observable<RegisterResponseDO> {
        return super.send() as Observable<RegisterResponseDO>
    }
}
