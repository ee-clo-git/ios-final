//
//  LocationsResponseDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

struct LocationsResponseDO: Mappable {

    var locations: [LocationDO]?
    var foursquareLocations: [FoursquareLocationDO]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        locations <- map["data.locations"]
        foursquareLocations <- map["data.fsq_locations"]
    }
}
