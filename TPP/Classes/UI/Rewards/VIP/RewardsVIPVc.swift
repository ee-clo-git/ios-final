//
//  RewardsVIPVc.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import MBProgressHUD

protocol PageTitle {
    func getPageTitle() -> String
}

class RewardsVIPVC: UICollectionViewController {
    internal let viewModel = VIPRewardsViewModel()
    private let bag = DisposeBag()
    internal var loadingHud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addHandlers()
        self.viewModel.loadData()
    }

    private func addHandlers() {
        self.viewModel.items.asObservable().subscribe(onNext: {[weak self] (_) in
            self?.collectionView?.reloadData()
        }).addDisposableTo(self.bag)

        self.viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] (loading) in
            if loading {
                guard self?.loadingHud?.superview == nil, let strongSelf = self else {
                    return
                }
                let hud = MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
                hud.contentColor = .mainViolet
                self?.loadingHud = hud
            } else {
                self?.loadingHud?.hide(animated: true)
            }
        }).addDisposableTo(bag)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items.value.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VIPRewardCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.set(item: self.viewModel.items.value[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: RewardsDetailsVC = UIStoryboard(storyboard: .Rewards).instantiateViewController()
        vc.viewModel = RewardDetailsViewModel(reward: self.viewModel.items.value[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension RewardsVIPVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: getPageTitle())
    }
}

extension RewardsVIPVC: PageTitle {
    func getPageTitle() -> String {
        return "VIP Experience"
    }
}

extension RewardsVIPVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-30, height: 210)
    }
}
