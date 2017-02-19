//
//  TPPApi.swift
//  TPP
//
//  Created by Mihails Tumkins on 22/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import RxSwift
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

extension TPPBaseRequest: TargetType {
    //var baseURL: URL { return URL(string: "https://tpp-api-test.herokuapp.com/api/")! }
    //var baseURL: URL { return URL(string: "http://ec2-54-210-39-112.compute-1.amazonaws.com/api/")! }
    var baseURL: URL { return URL(string: "http://api.epicenterexp.com/api/")! }

    var path: String {
        return self.requestPath
    }

    var method: Moya.Method {
        return self.requestMethod
    }

    var parameters: [String: Any]? {
        return self.requestParams
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }

    var sampleData: Data {
        let string = "{\"code\": 401, \"timestamp\": 1482408102,\"message\": \"Credentials Invalid\", \"data\": {}}"
        return string.data(using: .utf8)!
    }

    var task: Task {
        return self.requestTask
    }
}

let tppEncoding = TPPURLEncoding()

let endpointClosure = { (target: TPPBaseRequest) -> Endpoint<TPPBaseRequest> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    let headers = target.forceHeaders ?? UserService.shared.authorizationHeaders()
    let endpoint = defaultEndpoint
        .adding(newHTTPHeaderFields: headers)
        .adding(newParameterEncoding: tppEncoding)
    return endpoint
}

class TPPApiProvider {
    static let shared = RxMoyaProvider<TPPBaseRequest>(endpointClosure: endpointClosure,
                                                    plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
}

struct APIConfig {
    static let kAccessToken = "access-token"
    static let kClient = "client"
}
