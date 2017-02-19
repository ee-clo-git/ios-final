//
//  TPPLocationsRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPLocationsRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/locations" }
    override var requestMethod: Moya.Method { return Moya.Method.get }

    required init(latitude: Double, longitude: Double) {
        super.init(params: ["lat": latitude, "long": longitude])
    }

    func send() -> Observable<LocationsResponseDO> {
        return super.send() as Observable<LocationsResponseDO>
    }
}
