//
//  LocationSenderService.swift
//  TPP
//
//  Created by Igors Nemenonoks on 13/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class LocationSenderService: PubSubSubscriberProtocol {

    static let shared = LocationSenderService()
    private var lastLocation: CLLocation?
    private let bag = DisposeBag()

    func registerForEvents() {
        LocationService.shared.lastLocation.asObservable()
            .skip(1)
            .subscribe(onNext: {[weak self] (location) in
                self?.sendLocationToServer(location)
            }).addDisposableTo(self.bag)
    }

    fileprivate func sendLocationToServer(_ location: CLLocation?) {

        guard UserService.shared.user.value != nil else { return }

        guard let location = location else {
            return
        }
        if let lastLoc = self.lastLocation, fabs(location.coordinate.distance(to: lastLoc.coordinate)) < 10 {
            return
        }
        self.lastLocation = location
        TPPSendLocationRequest(latitude: location.coordinate.latitude,
                               longitude: location.coordinate.longitude)
            .send()
            .subscribe(onNext: { (response) in
                print(response)
            })
            .addDisposableTo(self.bag)
    }
}
