//
//  FoursquareLocationDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

struct FoursquareLocationDO: Mappable, Location {

    var name: String?
    var address: String?
    var foursquareId: String?
    var latitude: Double?
    var longitude: Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        address <- map["address"]
        foursquareId <- map["foursquare_id"]
        latitude <- map["lat"]
        longitude <- map["long"]
    }

    var imageName: String {
        return "foursquare_annotation_icon"
    }

    var image: UIImage {
        return UIImage(named: self.imageName)!
    }
}
