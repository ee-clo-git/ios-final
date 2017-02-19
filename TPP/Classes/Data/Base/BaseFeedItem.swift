//
//  BaseFeedItem.swift
//  MoheganSun
//
//  Created by Igors Nemenonoks on 08/09/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

protocol BaseFeedItem {
    var id: Int? {get set}
    func baseTitle() -> String?
    func baseSubTitle() -> String?
    func baseDate() -> String?
    func baseDuration() -> String?
    func baseImage() -> String?
    func attributedDescription() -> NSAttributedString?
    func entityName() -> String
    func baseCommentsCount() -> Int
    func checkedIn() -> Bool
}

extension BaseFeedItem {
    func baseCommentsCount() -> Int {
        return 0
    }

    func checkedIn() -> Bool {
        return false
    }
}
