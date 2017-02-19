//
//  ActivitiesViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper

class ActivitiesViewModel: BaseViewModel {

    var activities = Variable<[ActivityDO]>([])

    var type: FeedItemType?

    let disposeBag = DisposeBag()

    func loadActivityList() {
        TPPLoadActivityListEvent().send()
    }

    func addBindings() {
        if let type = self.type {
            switch type {
            case .video:
                TPPActivityService.shared.videoActivities.asObservable().bindTo(activities).addDisposableTo(disposeBag)
            case .photo:
                TPPActivityService.shared.photoActivities.asObservable().bindTo(activities).addDisposableTo(disposeBag)
            case .survey:
                TPPActivityService.shared.surveyActivities.asObservable().bindTo(activities).addDisposableTo(disposeBag)
            case .social:
                TPPActivityService.shared.socialActivities.asObservable().bindTo(activities).addDisposableTo(disposeBag)
            }
        }

        TPPActivityService.shared.isLoading.asObservable()
            .bindTo(self.isLoading)
            .addDisposableTo(disposeBag)

        TPPActivityService.shared.error.asObservable()
            .subscribe(onNext: { [weak self] error in self?.errorHandler?(error)})
            .addDisposableTo(disposeBag)

        activities.asObservable()
            .subscribe(onNext: { [weak self] _ in self?.completionHandler?()})
            .addDisposableTo(disposeBag)
    }
}
