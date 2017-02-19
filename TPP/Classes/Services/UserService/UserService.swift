//
// Created by Igors Nemenonoks on 16/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import KeychainAccess

struct UserCredentials {
    let email: String
    let password: String?
}

class UserService: PubSubSubscriberProtocol, EventBusObservable {
    static let shared = UserService()

    private let keychainPasswordKey = "password"

    internal var eventBusObserver = EventBusObserver()
    internal let bag = DisposeBag()

    lazy private(set) var user: Variable<UserDO?> = {
        return Variable<UserDO?>(self.restoreUser())
    }()

    lazy private var keychain = {
        return Keychain(service: Bundle.main.bundleIdentifier!)
    }()
    fileprivate var credentials: UserCredentials?

    func registerForEvents() {

        self.handleBGEvent {[weak self] (event: BGDidLoginEvent) in
            self?.user.value = event.user
            if let email = event.user.email {
                self?.storeCredentials(UserCredentials(email: email, password: event.password))
            }
        }

        self.handleBGEvent {[weak self] (event: BGDidRefreshEvent) in

            var new = event.user
            if let old = self?.user.value {
                new.token = old.token
                new.client = old.client
                if let email = new.email, email != old.email {
                    PrefrencesStorage.shared.store(email, key: StorageConfig.emailKey)
                }
            }
            self?.user.value = new
        }

        self.handleBGEvent {[weak self] (event: BGDidLogoutEvent) in
            self?.logout()
        }

        self.handleBGEvent {[weak self] (event: BGUpdateUserEvent) in
            self?.reloadUser()
        }
    }

	func authorizationHeaders() -> [String: String] {
		var headers = [String: String]()
		if let token = self.user.value?.token {
            headers[APIConfig.kAccessToken] = token
		}
        if let client = self.user.value?.client {
            headers[APIConfig.kClient] = client
        }
        if let uid = self.user.value?.uid {
            headers["uid"] = uid
        }

        return headers
	}

    private func restoreUser() -> UserDO? {
        return nil
    }

    private func storeCredentials(_ credentials: UserCredentials) {
        if self.credentials != nil {
            return
        }
        DispatchQueue.global(qos: .default).async {
            do {
                PrefrencesStorage.shared.store(credentials.email, key: StorageConfig.emailKey)
                if let password = credentials.password {
                    try self.keychain.set(password, key: self.keychainPasswordKey)
                }
            } catch {
                //unable to save
                print("Unable to save")
            }
        }
    }

    private func logout() {
        self.user.value = nil
        self.credentials = nil
        try? self.keychain.remove(keychainPasswordKey)
    }

    func restoreCredentials(completion: @escaping (UserCredentials?) -> Void) {
        guard let email: String = PrefrencesStorage.shared.restore(key: StorageConfig.emailKey) else {
            completion(nil)
            return
        }
        DispatchQueue.global(qos: .default).async {
            do {
                let password = try self.keychain.get(self.keychainPasswordKey)

                if let pass = password {
                    let cred = UserCredentials(email: email, password: pass)
                    self.credentials = cred
                    completion(cred)
                } else {
                    completion(nil)
                }
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }

    private func reloadUser() {
        TPPGetCurrentUserRequest().send().subscribe { event -> Void in
            switch event {
                case .next(let response):
                    if let user = response.user {
                        BGDidRefreshEvent(user: user).send()
                    }
                default:
                    break
                }
            }.addDisposableTo(bag)
    }
}
