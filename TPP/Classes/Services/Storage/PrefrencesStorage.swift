//
// Created by Igors Nemenonoks on 12/02/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation

protocol PrefrenceStorable {
}

class PrefrencesStorage {
    static let shared = PrefrencesStorage()

    private let defaults = UserDefaults(suiteName: "group.com.boston.imagine")

    func remove(key: String) {
        self.defaults?.removeObject(forKey: key)
    }

    func store(_ value: PrefrenceStorable, key: String) {
        self.defaults?.set(value, forKey:key)
    }

    func restore<T>(key: String) -> T? where T: PrefrenceStorable {
        return self.defaults?.object(forKey: key) as! T?
    }
}

extension Int: PrefrenceStorable { }
extension String: PrefrenceStorable { }
extension Double: PrefrenceStorable { }
extension Float: PrefrenceStorable { }
extension Bool: PrefrenceStorable { }
