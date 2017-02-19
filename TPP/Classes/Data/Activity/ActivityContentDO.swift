//
//  ActivityContentDO.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import ObjectMapper

enum ActivityContentType: String {
    case video, photo, survey, social
}

struct ActivityContentDO: Mappable {
    var id: Int?
    var name: String?
    var url: String?
    var thumb: String?
    var type: ActivityContentType?
    var about: String?
    var twitterContent: String?
    var fbContent: String?
    var photos: [[String: String]]?

    var likesCount: Int?
    var commentsCount: Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        url <- map["url"]
        thumb <- map["thumb"]
        type <- map["content_type"]
        about <- map["about"]
        photos <- map["photos"]
        twitterContent <- map["twitter_content"]
        fbContent <- map["fb_content"]
    }
}

extension ActivityContentDO {
    func attributedDescription() -> NSAttributedString? {
        if var about = self.about {
            do {
                let font = UIFont.mainFontWithSize(size: 14)!
                about = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color:#CCCCCC;}</style>\(about)"
                let str = try NSAttributedString(data: about.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                                 options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes:nil)
                return str
            } catch {
                print(error)
            }
        }
        return nil
    }
}
