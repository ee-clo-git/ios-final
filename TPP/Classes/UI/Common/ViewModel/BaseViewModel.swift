//
// Created by Igors Nemenonoks on 15/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    private(set) var isLoading = Variable(false)
    var errorHandler: ((Error?) -> Void)?
    var completionHandler: (() -> Void)?
}
