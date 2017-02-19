//
//  RewardDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 06/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import ObjectMapper

enum RewardType {
    case card
    case charity
}

struct RewardDO: Mappable {

    var brandName: String?
    var rewardDescription: String?
    var bigImageUrl: String?
    var smallImageUrl: String?
    var items: [RewardItemDO]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        brandName <- map["brandName"]
        rewardDescription <- map["description"]
        bigImageUrl <- map["imageUrls.300w-326ppi"]
        smallImageUrl <- map["imageUrls.200w-326ppi"]
        items <- map["items"]
    }

    func getType() -> RewardType {
        let val = (brandName?.lowercased() == "amazon.com" || brandName?.lowercased() == "target")
        return val ? .card : .charity
    }
}

enum RedeemType {
    case reward, vip
}

protocol RedeemableItem {
    func redeemName() -> String?
    func redeemDescription() -> String?
    func redeemImageUrl() -> String?
    func redeemId() -> String?
    func redeemType() -> RedeemType
}

extension RewardDO: RedeemableItem {
    func redeemName() -> String? {
        return items?.first?.rewardName
    }
    func redeemDescription() -> String? {
        return rewardDescription
    }
    func redeemImageUrl() -> String? {
        return self.bigImageUrl
    }
    func redeemId() -> String? {
        return items?.first?.utid
    }
    func redeemType() -> RedeemType {
        return .reward
    }
}
