//
//  RewardsVC.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class RewardsVC: SegmentedPagerTabStripViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rewardsLabel: UILabel!

    @IBOutlet weak var fGiftBackground: UIView!
    @IBOutlet weak var fGiftLabel: UILabel!

    @IBOutlet weak var fVipBackground: UIView!
    @IBOutlet weak var fVipLabel: UILabel!

    @IBOutlet weak var fCharityBackground: UIView!
    @IBOutlet weak var fCharityLabel: UILabel!

    private let bag = DisposeBag()
    private let selectedIndex = Variable<Int>(0)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.text = UserService.shared.user.value?.fullName()

        self.navigationController?.navigationBar.shadowImage = UIImage()

        UserService.shared.user.asObservable().subscribe(onNext: {[weak self] (user) in
            self?.rewardsLabel.text = self?.rewardsString()
        }).addDisposableTo(bag)

        setupFakeViews(for: 0, animated: false)
        self.selectedIndex.asObservable()
            .skip(1)
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (index) in
            self?.setupFakeViews(for: index, animated: true)
        }).addDisposableTo(self.bag)
    }

    func setupFakeViews(for index: Int, animated: Bool = true) {

        let activeBgFn = { (view: UIView?) in
            view?.backgroundColor = .white
            view?.layer.borderWidth = 0
        }

        let inactiveBgFn = { (view: UIView?) in
            view?.backgroundColor = .mainBackground
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.white.cgColor
        }

        let activeLabelFn = { (label: UILabel? ) in label?.textColor = .mainBackground }
        let inactiveLabelFn = { (label: UILabel? ) in label?.textColor = .white }

        let animationDuration = 0.2
        let cornerRadius: CGFloat = 40.0

        for (k, view) in [fGiftBackground, fVipBackground, fCharityBackground].enumerated() {
            view?.layer.cornerRadius = cornerRadius
            if k == index {
                animated ? UIView.animate(withDuration: animationDuration, animations: { activeBgFn(view) }) : activeBgFn(view)
            } else {
                animated ? UIView.animate(withDuration: animationDuration, animations: { inactiveBgFn(view) }) : inactiveBgFn(view)
            }
        }

        for (k, label) in [fGiftLabel, fVipLabel, fCharityLabel].enumerated() {
            if let vc = pageViewControllers[k] as? PageTitle {
                label?.text = vc.getPageTitle()
                if k == index {
                    animated ? UIView.animate(withDuration: animationDuration, animations: { activeLabelFn(label) }) : activeLabelFn(label)
                } else {
                    animated ? UIView.animate(withDuration: animationDuration, animations: { inactiveLabelFn(label) }) : inactiveLabelFn(label)
                }
            }
        }
    }

    private func rewardsString() -> String {
        let points = UserService.shared.user.value?.rewardsCount ?? 0
        return "$\(points)"
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return pageViewControllers
    }

    @IBAction func onSettingsTap(_ sender: Any) {
        let vc: SettingsVC = UIStoryboard(storyboard: .Settings).instantiateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    lazy var pageViewControllers: [UIViewController] = {
        let storyboard = UIStoryboard(storyboard: .Rewards)
        let vc1: RewardsCashCardsVC = storyboard.instantiateViewController()
        vc1.rewardType = .card

        let vc2: RewardsVIPVC = storyboard.instantiateViewController()

        let vc3: RewardsCashCardsVC = storyboard.instantiateViewController()
        vc3.rewardType = .charity

        return [vc1, vc2, vc3]
    }()

    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex)
        if fromIndex != toIndex {
            self.selectedIndex.value = toIndex
        }
    }
}
