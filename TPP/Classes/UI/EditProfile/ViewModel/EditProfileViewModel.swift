//
//  EditProfileViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 17/02/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper

class EditProfileViewModel: BaseViewModel {

    let disposeBag = DisposeBag()
    let user = UserService.shared.user

    func update(email: String) {
        self.update(params: ["email": email])
    }

    private func update(params: [String: Any]) {
        guard let user = UserService.shared.user.value else { return }
        let request = TPPUpdateUserRequest(user: user, params: params)
        self.isLoading.value = true

        request.send().subscribe { [weak self] event -> Void in
            self?.isLoading.value = false
            switch event {
            case .next(let response):
                if let user = response.user {
                    BGDidRefreshEvent(user: user).send()
                }
                self?.completionHandler?()
            case .error(let error):
                self?.errorHandler?(error)
            default:
                break
            }
            }.addDisposableTo(disposeBag)
    }
}
