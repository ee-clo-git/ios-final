//
//  ActivityActionCommentViewModel.swift
//  TPP
//
//  Created by Igors Nemenonoks on 30/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import Foundation
import RxSwift

class ActivityActionCommentViewModel: ActivityActionHandle {
    var completionHandler: ((ActivityCreateResponseDO) -> Void)?
    var errorHandler: ((Error) -> Void)?
    var progressHandler: ((Double) -> Void)?

    var dismissHandler: (() -> Void)?

    private(set) var isLoading = Variable(false)
    private let bag = DisposeBag()

    let activity: ActivityDO

    init(activity: ActivityDO) {
        self.activity = activity
    }

    func send(comment: String) {
        self.isLoading.value = true

        TPPPostActivityCommentRequest(activityId: activity.id!, comment: comment)
            .send()
            .subscribe {[weak self] (event) in
                self?.isLoading.value = false
                switch event {
                    case .next(let response):
                        self?.dismissHandler?()
                        TPPLoadActivityListEvent().send()
                        self?.completionHandler?(response)
                    case .error(let error):
                        self?.errorHandler?(error)
                    default:
                        break
                }
            }.addDisposableTo(self.bag)
    }
}
