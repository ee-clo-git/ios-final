//
//  LocationDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper
import MapKit

protocol Location {
    var name: String? {get set}
    var address: String? {get set}
    var latitude: Double? {get set}
    var longitude: Double? {get set}
    var imageName: String {get}
    var image: UIImage {get}
}

struct LocationDO: Mappable, Location {

    var id: Int?
    var name: String?
    var address: String?
    var foursquareId: String?
    var latitude: Double?
    var longitude: Double?
    var activities: [ActivityDO]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        address <- map["address"]
        foursquareId <- map["foursquare_id"]
        latitude <- map["lat"]
        longitude <- map["long"]
        activities <- map["activities"]
    }

    var imageName: String {
        return self.activities?.first?.type?.imageName ?? ""
    }

    var popupImageName: String {
        return self.activities?.first?.type?.popupImageName ?? ""
    }

    var popupImage: UIImage {
        return UIImage(named: self.popupImageName)!
    }

    var image: UIImage {
        return UIImage(named: self.imageName)!
    }
}

extension Location {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = self.latitude, let longitude = self.longitude else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
