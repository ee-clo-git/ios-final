//
//  NSURLResponseUtils.swift
//  TPP
//
//  Created by Mihails Tumkins on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import Foundation

extension URLResponse {
    func header(key: String) -> Any? {
        return (self as? HTTPURLResponse)?.allHeaderFields[key]
    }
}
