//
//  RewardDetailsViewModel.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import RxSwift

class RewardDetailsViewModel: BaseViewModel {
    let reward: RedeemableItem
    let bag = DisposeBag()

    init(reward: RedeemableItem) {
        self.reward = reward
    }

    func rewardName() -> String? {
        return self.reward.redeemName()
    }

    func text() -> NSAttributedString? {
        if var about = self.reward.redeemDescription() {
            do {
                let font = UIFont.mainFontWithSize(size: 14)!
                about = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color:#000000;}</style>\(about)"
                let str = try NSAttributedString(data: about.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                                 options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes:nil)
                return str
            } catch {
                print(error)
            }
        }
        return nil
    }

    func redeem(completion: ((String?) -> Void)?) {
        self.isLoading.value = true
        guard let utid = self.reward.redeemId(), let name = self.reward.redeemName() else {
            return
        }
        switch self.reward.redeemType() {
        case .reward:
            TPPRedeemRequest(redeemId: utid, name: name).send().subscribe(onNext: {[weak self] (response) in
                self?.isLoading.value = false
                if let user = response.user {
                    BGDidRefreshEvent(user: user).send()
                }
                completion?(response.message)
                }, onError: {[weak self] (error) in
                    self?.isLoading.value = false
                    self?.errorHandler?(error)
            }).addDisposableTo(self.bag)
        case .vip:
            TPPRedeemVipRequest(redeemId: utid).send().subscribe(onNext: {[weak self] (response) in
                self?.isLoading.value = false
                if let user = response.user {
                    BGDidRefreshEvent(user: user).send()
                }
                completion?(response.message)
                }, onError: {[weak self] (error) in
                    self?.isLoading.value = false
                    self?.errorHandler?(error)
            }).addDisposableTo(self.bag)
        }
    }
}
