//
//  VIPExperience.swift
//  TPP
//
//  Created by Igors Nemenonoks on 09/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import ObjectMapper

struct VIPExperience: Mappable {
    var name: String?
    var text: String?
    var imageUrl: String?
    var id: Int?
    var cost: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        text <- map["description"]
        imageUrl <- map["thumb"]
        id <- map["id"]
        cost <- map["cost"]
    }
}

extension VIPExperience: RedeemableItem {
    func redeemName() -> String? {
        return name
    }
    func redeemDescription() -> String? {
        return text
    }
    func redeemImageUrl() -> String? {
        return imageUrl
    }
    func redeemId() -> String? {
        if let id = id {
            return String(id)
        }
        return nil
    }
    func redeemType() -> RedeemType {
        return .vip
    }
}
