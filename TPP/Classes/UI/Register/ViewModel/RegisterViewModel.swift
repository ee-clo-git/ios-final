//
//  RegisterViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 22/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import RxSwift
import Moya_ObjectMapper

class RegisterViewModel: BaseViewModel {

    let disposeBag = DisposeBag()

    func register(email: String, password: String) {
        self.isLoading.value = true

        let utid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let request = TPPRegisterRequest(email: email, firstName: "", lastName: "", phone: "", password: password, utid: utid)

        request.send().subscribe { [weak self] event -> Void in
            self?.isLoading.value = false
            switch event {
            case .next(_):
                self?.completionHandler?()
            case .error(let error):
                self?.errorHandler?(error)
            default:
                break
            }
        }.addDisposableTo(disposeBag)
    }

    func termsURL() -> URL? {
        return URL(string: termsURLString)
    }
}
