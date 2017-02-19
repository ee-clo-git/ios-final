//
//  ContentDO.swift
//  TPP
//
//  Created by Igors Nemenonoks on 22/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

struct ContentDO: Mappable {

    var id: Int?
    var name: String?
    var url: String?
    var description: String?
    var contentType: String?
    var postedDate: Date?
    var likesCount: Int?
    var commentsCount: Int?
    var likedByMe: Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        url <- map["url"]
        description <- map["description"]
        contentType <- map["content_type"]
        likesCount <- map["likes_count"]
        commentsCount <- map["comments_count"]
        likedByMe <- map["liked_by_me"]
    }

    mutating func updateLike(like: Bool, likesCount: Int) -> ContentDO {
        self.likedByMe = like
        self.likesCount = likesCount
        return self
    }

    mutating func updateCommentsCount(count: Int) -> ContentDO {
        self.commentsCount = count
        return self
    }
    mutating func incrementCommentsCount() -> ContentDO {
        self.commentsCount = (self.commentsCount ?? 0)+1
        return self
    }
}

extension ContentDO: BaseFeedItem {

    func baseTitle() -> String? {
        return self.name
    }
    func baseSubTitle() -> String? {
        return nil
    }
    func baseDate() -> String? {
        return nil
    }

    func baseDuration() -> String? {
        return nil
    }

    func baseImage() -> String? {
        return self.url
    }
    func attributedDescription() -> NSAttributedString? {
        if var about = self.description {
            do {
                let font = UIFont.mainFontWithSize(size: 14)!
                about = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color:#FFFFFF;}</style>\(about)"
                let str = try NSAttributedString(data: about.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes:nil)
                return str
            } catch {
                print(error)
            }
        }
        return nil
    }

    func entityName() -> String {
        return "content"
    }

    func baseCommentsCount() -> Int {
        return self.commentsCount ?? 0
    }
}
