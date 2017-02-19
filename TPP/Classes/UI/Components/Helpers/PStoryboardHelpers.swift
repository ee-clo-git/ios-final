//
//  PStoryboardHelpers.swift
//  Hippo
//
//  Created by Igors Nemenonoks on 29/11/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    enum Storyboard: String {
        case Main
        case Login
        case Feed
        case Rewards
        case Settings
        case Activities
        case Survey
        case Tutorial
        case AdditionalQuestions
        case TPPAlert
    }

    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T {
        let storyBoardId = String(describing: T.self)
        let optionalViewController = self.instantiateViewController(withIdentifier: storyBoardId)

        guard let viewController = optionalViewController as? T  else {
            fatalError("Couldn’t instantiate view controller with identifier \(storyBoardId) ")
        }

        return viewController
    }

    func instantiateInitialViewController<T: UIViewController>() -> T {
        let optionalViewController = self.instantiateInitialViewController()
        guard let viewController = optionalViewController as? T  else {
            fatalError("Couldn’t instantiate initial view controller")
        }
        return viewController
    }
}
