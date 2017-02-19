//
// Created by Igors Nemenonoks on 16/11/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import ObjectMapper

enum Gender: String {
    case male = "male"
    case female = "female"
}

enum Ethnicity: String {
    case african = "African American"
    case indian = "American Indian"
    case asian = "Asian"
    case hispanic = "Hispanic"
    case white = "White"
}

enum ChildOption: Int {
    case zero = 0, one = 1, two, threeOrFour, moreThanFour

    var textValue: String {
        switch self {
        case .zero:
            return "0"
        case .one:
            return "1"
        case .two:
            return "2"
        case .threeOrFour:
            return "3-4"
        case .moreThanFour:
            return "4+"
        }
    }
    static func fromString(string: String) -> ChildOption? {
        switch string {
        case "0":
            return .zero
        case "1":
            return .one
        case "2":
            return .two
        case "3-4":
            return .threeOrFour
        case "4+":
            return .moreThanFour
        default:
            return nil
        }
    }
}

enum HouseholdIncome: Int {
    case under25 = 1
    case under35 = 2
    case under50 = 3
    case under75 = 4
    case under99 = 5
    case under150 = 6
    case above150 = 7

    var textValue: String {
        switch self {
        case .under25:
            return "< $25K"
        case .under35:
            return "$25K to $35K"
        case .under50:
            return "$35K to $50K"
        case .under75:
            return "$50K to $75K"
        case .under99:
            return "$75K to $100K"
        case .under150:
            return "$100K to $150K"
        case .above150:
            return "> $150K"
        }
    }

    static func fromString(string: String) -> HouseholdIncome? {
        switch string {
        case "< $24K":
            return .under25
        case "$25K to $35K":
            return .under35
        case "$35K to $50K":
            return .under50
        case "$50K to $75K":
            return .under75
        case "$75K to $100K":
            return .under99
        case "$100K to $150K":
            return .under150
        case "> $150K":
            return .above150
        default:
            return nil
        }
    }
}

enum MaritalStatus: String {
    case single
    case married
    case separated
    case widowed
    case divorced
}

struct UserDO: Mappable {
    var id: Int?
    var uid: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var birthday: String?
    var hhi: HouseholdIncome?
    var gender: Gender?
    var ethnicity: Ethnicity?
    var presenceOfChildren: ChildOption?
    var maritalStatus: MaritalStatus?
    var zip: String?
    var token: String?
    var client: String?
    var rewardsCount: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        uid <- map["uid"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        phone <- map["phone"]
        birthday <- map["birthday"]
        hhi <- map["hhi"]
        gender <- map["gender"]
        ethnicity <- map["ethnicity"]
        presenceOfChildren <- map["presence_of_children"]
        maritalStatus <- map["marital_status"]
        zip <- map["zip"]
        token <- map["token"]
        client <- map["client"]
        rewardsCount <- map["rewards_amount"]
	}

    func fullName() -> String {
        var str = self.firstName ?? nil
        if self.lastName != nil {
            str = str == nil ? self.lastName : "\(str!) \(lastName!)"
        }
        return str ?? ""
    }
}
