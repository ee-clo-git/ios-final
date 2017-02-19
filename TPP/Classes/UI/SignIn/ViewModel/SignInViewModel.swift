//
//  SignInViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 22/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//
import RxSwift
import Moya
import Moya_ObjectMapper

class SignInViewModel: BaseViewModel {

    let disposeBag = DisposeBag()

    func login(email: String, password: String) {
        self.sendRequest(TPPLoginRequest(email: email, password: password), password: password)
    }

    func login(facebookToken: String) {
        self.sendRequest(TPPFacebookLoginRequest(token: facebookToken), fbToken: facebookToken)
    }

    func sendRequest(_ request: TPPBaseRequest, password: String? = nil, fbToken: String? = nil) {
        self.isLoading.value = true
        var token: String?
        var client: String?
        request.responseHandler = {
            token = $0.response?.header(key: APIConfig.kAccessToken) as? String
            client = $0.response?.header(key: APIConfig.kClient) as? String
        }

        (request as! LoginRequest).send().subscribe { [weak self] event -> Void in
            self?.isLoading.value = false
            switch event {
            case .next(let response):
                if var user = response.user {
                    user.token = token
                    user.client = client
                    BGDidLoginEvent(user: user, password: password, facebookToken: fbToken).send()
                }
            case .error(let error):
                self?.errorHandler?(error)
            default:
                break
            }
        }.addDisposableTo(disposeBag)
    }
}
