//
//  TPPUpdateUserRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPUpdateUserRequest: TPPBaseRequest {
    let user: UserDO
    override var requestPath: String { return String(format: "v1/users/%i", self.user.id!) }
    override var requestMethod: Moya.Method { return .put }

    init(user: UserDO, params: [String : Any]?) {
        self.user = user
        super.init(params: params)
    }

    func send() -> Observable<RegisterResponseDO> {
        return super.send() as Observable<RegisterResponseDO>
    }
}
