//
//  TutorialPageControl.swift
//  TPP
//
//  Created by Mihails Tumkins on 09/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import SnapKit

class TutorialPageControl: UIView {
    private let numberOfPages: Int
    private let currentPage: Int

    private let spacing: CGFloat
    private let stackView: UIStackView

    private var pageViews = [UIView]()
    private var currentPageView: UIView

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(numberOfPages: Int, currentPage: Int = 0, spacing: CGFloat = 1.0) {
        guard numberOfPages > 0 else {
            fatalError("numberOfPages must be greater than 0")
        }

        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
        self.spacing = spacing

        for _ in 0..<numberOfPages {
            let view = UIView()
            view.backgroundColor = .white
            view.alpha = 0.5
            view.layer.cornerRadius = 2
            pageViews.append(view)
        }

        stackView = UIStackView(arrangedSubviews: pageViews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = spacing

        currentPageView = UIView()
        currentPageView.backgroundColor = .white
        currentPageView.alpha = 1.0
        currentPageView.layer.cornerRadius = 2
        currentPageView.frame = .zero

        super.init(frame: .zero)

        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(currentPageView)
    }

    func setCurrentPage(page: Int, animated: Bool = true) {
        guard pageViews.count > page else { return }

        let pageView = pageViews[page]
        if animated {
                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 1.0,
                               options: .curveEaseOut,
                               animations: { self.currentPageView.frame = pageView.frame })
        } else {
            currentPageView.frame = pageView.frame
        }
    }
}
