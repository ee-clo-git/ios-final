//
//  TPPVipRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 09/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class TPPVipRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/vip_experiences" }
    override var requestMethod: Moya.Method { return Moya.Method.get }

    func send() -> Observable<VIPExperienceResponse> {
        return super.send() as Observable<VIPExperienceResponse>
    }
}
