//
//  LocationService.swift
//  TPP
//
//  Created by Mihails Tumkins on 21/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol LocationServiceDelegate: class {
    func authFailed(with status: CLAuthorizationStatus)
    func authSuccess(with status: CLAuthorizationStatus)
    func didUpdateLocation(location: CLLocation)
}

class LocationService: NSObject, PubSubSubscriberProtocol, EventBusObservable {
    weak var delegate: LocationServiceDelegate?

    static let shared = LocationService()
    var eventBusObserver = EventBusObserver()

    var manager: CLLocationManager = CLLocationManager()
    let lastLocation = Variable<CLLocation?>(nil)
    fileprivate let bag = DisposeBag()

    init(desiredAccuracy: Double = 1.0, distanaceFilter: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters) {
        super.init()

        manager.desiredAccuracy = distanaceFilter
        manager.distanceFilter = desiredAccuracy
        manager.delegate = self
    }

    func registerForEvents() {
        self.handleBGEvent {[weak self] (event: BGDidLoginEvent) in
            if self?.isAuthorized() == true {
                DispatchQueue.main.async {
                    self?.startUpdating()
                }
            }
        }
    }

    func authorize() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.authSuccess(with: status)
        case .restricted, .denied:
            delegate?.authFailed(with: status)
        }
        self.startUpdating()
    }

    func isAuthorized() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        }
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { (location) in
            self.lastLocation.value = location
            self.delegate?.didUpdateLocation(location: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            delegate?.authSuccess(with: status)
        } else {
            delegate?.authFailed(with: status)
        }
    }
}
