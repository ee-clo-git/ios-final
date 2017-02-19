//
//  RewardsCashCardsVC.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import MBProgressHUD

class RewardsCashCardsVC: UICollectionViewController {

    internal let viewModel = RewardsCashCardsViewModel()
    internal let bag = DisposeBag()

    internal var loadingHud: MBProgressHUD?

    var rewardType: RewardType?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addHandlers()
        guard let rewardType = self.rewardType else { return }
        self.viewModel.loadData(rewardType: rewardType)
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
        let cell: CashCardsCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.set(item: self.viewModel.items.value[indexPath.row])
        return cell
    }
}

extension RewardsCashCardsVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: getPageTitle())
    }
}

extension RewardsCashCardsVC: PageTitle {
    func getPageTitle() -> String {
        var title = "Gift Cards"
        if self.rewardType == .charity {
            title = "Pay It Forward"
        }
        return title
    }
}

extension RewardsCashCardsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ceil((self.view.frame.width-60)/2)
        let height = CGFloat(ceilf(Float(width)/1.5625))
        return CGSize(width: width, height: height + 50)
    }
}

extension RewardsCashCardsVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: RewardsDetailsVC = UIStoryboard(storyboard: .Rewards).instantiateViewController()
        vc.viewModel = RewardDetailsViewModel(reward: self.viewModel.items.value[indexPath.row])
        vc.buttonName = self.rewardType == .card ? "Send My Gift Card" : "Give Now"
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
    }
}
