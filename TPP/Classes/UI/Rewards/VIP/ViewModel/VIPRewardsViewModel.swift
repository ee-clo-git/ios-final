//
//  VIPRewardsViewModel.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift

struct VIPItem {
    let title: String
    let imageUrl: String
}

class VIPRewardsViewModel: BaseViewModel {
    let items = Variable<[VIPExperience]>([])
    let bag = DisposeBag()

    func loadData() {
        self.isLoading.value = true
        TPPVipRequest().send().subscribe {[weak self] event in
            self?.isLoading.value = false
            switch event {
            case .next(let response):
                self?.items.value = response.items ?? []
            case .error(let error):
                self?.errorHandler?(error)
            default:
                break
            }
            }.addDisposableTo(self.bag)
    }
}
