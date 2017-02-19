//
//  TPPApiResponseValidation.swift
//  TPP
//
//  Created by Mihails Tumkins on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift

public enum ApiError: Swift.Error {
    case withMessage(message: String)
}

extension ApiError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .withMessage(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}

extension Response {

    func filter(statusCodes: ClosedRange<Int>) throws -> Response {
        guard statusCodes.contains(statusCode) else {
            var response: SimpleResponseDO?
            do {
                response = try self.mapObject(SimpleResponseDO.self)
            } catch {
                throw MoyaError.statusCode(self)
            }

            if let message = response?.message {
                throw ApiError.withMessage(message: message)
            } else {
                throw MoyaError.statusCode(self)
            }

        }
        return self
    }

    func filterTPPSuccessfulStatusCodes() throws -> Response {
        return try filter(statusCodes: 200...299)
    }
}

extension ObservableType where E == Response {

    func filterTPPSuccessfulStatusCodes() -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.filterTPPSuccessfulStatusCodes())
        }
    }
}
