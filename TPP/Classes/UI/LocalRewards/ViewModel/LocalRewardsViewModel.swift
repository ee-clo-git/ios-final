//
//  LocalRewardsViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 14/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

extension ActivityType {

    var imageName: String {
        switch self {
        case .photo:
            return "photo_annotation_icon"
        case .video:
            return "video_annotation_icon"
        case .survey:
            return "survey_annotation_icon"
        case .social:
            return "selfie_annotation_icon"
        case .comment:
            return "survey_annotation_icon"
        default:
            return ""
        }
    }

    var popupImageName: String {
        switch self {
        case .photo:
            return "photo_popup_icon"
        case .video:
            return "video_popup_icon"
        case .survey:
            return "survey_popup_icon"
        case .social:
            return "selfie_popup_icon"
        case .comment:
            return "survey_popup_icon"
        default:
            return ""
        }
    }
}

class LocalRewardsViewModel: BaseViewModel, EventBusObservable {

    let bag = DisposeBag()
    let locations = Variable<[LocationDO]>([])
    let foursquareLocations = Variable<[FoursquareLocationDO]>([])
    let city = Variable<String>("")
    var eventBusObserver = EventBusObserver()
    private var lastLocation: CLLocationCoordinate2D?
    var cleanAnnotationsHandler:(() -> Void)?
    private let minDistanceToRelaodLocation: Double = 50

    override init() {
        super.init()
        self.handleUIEvent {[weak self] (event: TPPLoadActivityListEvent) in
            if let lastLocation = self?.lastLocation {
                self?.loadData(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
            }
        }
    }

    func loadData(latitude: Double, longitude: Double) {
        guard self.isLoading.value == false else {
            return
        }

        let loc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if let lastLoc = self.lastLocation, fabs(loc.distance(to: lastLoc)) < minDistanceToRelaodLocation {
            return
        }
        self.lastLocation = loc
        self.isLoading.value = true
        TPPLocationsRequest(latitude: latitude, longitude: longitude)
            .send().subscribe {[weak self] event in
                self?.isLoading.value = false
                switch event {
                    case .next(let response):
                        self?.cleanAnnotationsHandler?()
                        if let fsqLocations = response.foursquareLocations {
                            self?.foursquareLocations.value = fsqLocations
                        }
                        if let locations = response.locations {
                            self?.locations.value = locations
                        }
                    case .error(let error):
                        self?.errorHandler?(error)
                    default:
                        break
                }
            }.addDisposableTo(self.bag)
    }

    func getCurrentCity(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {[weak self](placemarks, error) -> Void in
            if let pl = placemarks?.first {
                if let city = pl.addressDictionary?["City"] as? String {
                    self?.city.value = city
                }
            }
        })
    }

    func refreshActivities() {
        if let loc = self.lastLocation {
            self.loadData(latitude: loc.latitude, longitude: loc.longitude)
        }
    }
}
extension CLLocationCoordinate2D {
    // In meteres
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
