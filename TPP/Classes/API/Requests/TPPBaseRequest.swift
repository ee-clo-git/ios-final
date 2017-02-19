//
//  TPPBaseRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//
import RxSwift
import Moya

import ObjectMapper
import Moya_ObjectMapper

class TPPBaseRequest {
    var requestMethod: Moya.Method { return .get }
    var requestPath: String { return "" }
    var requestParams: [String : Any]?
    var requestTask: Moya.Task { return .request }
    var forceHeaders: [String: String]?

    var responseHandler: ((Response) -> Void)?

    init(params: [String : Any]? = nil) {
        self.requestParams = params
    }

    init() {}

    func request() -> Observable<Response> {
        return TPPApiProvider.shared.request(self)
    }

    func send<T: Mappable>() -> Observable<T> {
        return self.request()
            .filterTPPSuccessfulStatusCodes()
            .map { [weak self] response in
                self?.responseHandler?(response)
                return response
            }
            .mapObject(T.self)
    }
}
