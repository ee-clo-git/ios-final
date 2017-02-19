//
//  ActivitiesVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift
import DZNEmptyDataSet

class ActivitiesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let viewModel = ActivitiesViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        addHandlers()
        //viewModel.loadActivityList()
    }

    func addHandlers() {
        viewModel.addBindings()

        viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] (val) in
            val ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }).addDisposableTo(disposeBag)

        viewModel.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }

        viewModel.completionHandler = {[weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ActivitiesVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.isLoading.value ? 0 : viewModel.activities.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActivitiesCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: viewModel.activities.value[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var activity = viewModel.activities.value[indexPath.row]
        //todo remove
        if activity.type == .survey && activity.questions?.isEmpty == true && activity.surveyLink == nil {
            activity.surveyLink = "https://v2.decipherinc.com/survey/selfserve/21dc/170168"
        }
        if let activityType = activity.activityType(), activity.content == nil {

            if activity.type == .survey && activity.questions?.isEmpty == true && activity.surveyLink == nil {
                self.showTPPAlert(title: "Error", message: "Unable to load survey", action: "OK", completion: nil)
                return
            }

            TPPCreateUserActivityEvent(target: self, type: activityType, progress: nil, error: { [weak self] error in
                    self?.showTPPAlert(error: error)
                }, completion: { [weak self] response in
                    self?.showActivityCompletedAlert(popupImageName: activity.type?.popupImageName)
                    self?.viewModel.loadActivityList()
            }).send()
        } else if activity.content != nil {
            let vc: ContentPageVC = UIStoryboard(storyboard: .Feed).instantiateViewController()
            vc.viewModel = ContentPageVCViewModel(item: activity)
            self.present(vc, animated: true, completion: nil)
        }
    }

    private func showActivityCompletedAlert(popupImageName: String?) {
        self.showTPPIconAlert(title: "Thank You", message: "We just put $1 in your wallet!", action: "OK", image: popupImageName, completion: {[weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
            UIShowRewardsEvent().send()
        })
    }
}

extension ActivitiesVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No activities to complete",
                                  attributes: [NSFontAttributeName: UIFont.mainFontWithSize(size: 14)!, NSForegroundColorAttributeName: UIColor.mainViolet])
    }

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return self.viewModel.isLoading.value == false
    }
}
