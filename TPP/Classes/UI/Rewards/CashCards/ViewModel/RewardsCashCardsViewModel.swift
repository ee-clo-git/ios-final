//
//  RewardsCashCardsViewModel.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift

class RewardsCashCardsViewModel: BaseViewModel {
    let items = Variable<[RewardDO]>([])
    let bag = DisposeBag()

    func loadData(rewardType: RewardType) {
        self.isLoading.value = true
        TPPGetRewardsRequest().send().subscribe {[weak self] event in
            self?.isLoading.value = false
            switch event {
            case .next(let response):
                self?.items.value = response.items?.filter { $0.getType() == rewardType } ?? []
            case .error(let error):
                self?.errorHandler?(error)
            default:
                break
            }
            }.addDisposableTo(self.bag)
    }
}
