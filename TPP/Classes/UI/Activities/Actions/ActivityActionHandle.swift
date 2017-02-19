//
//  ActivityActionHandle.swift
//  TPP
//
//  Created by Igors Nemenonoks on 30/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import Foundation

protocol ActivityActionHandle {
    var completionHandler: ((ActivityCreateResponseDO) -> Void)? { get set }
    var errorHandler: ((Error) -> Void)? { get set}
    var progressHandler: ((Double) -> Void)? { get set }
}
