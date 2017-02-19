//
//  FeedVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 09/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift

class FeedVC: UIViewController, EventBusObservable {

    let viewModel = FeedViewModel()
    let bag = DisposeBag()
    var eventBusObserver = EventBusObserver()

    internal let refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.backgroundColor = .white
        r.tintColor = .mainViolet
        r.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return r
    }()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.bottom = 10
        tableView.addSubview(self.refreshControl)

        self.addHandlers()
    }

    private func addHandlers() {
        let videos = TPPActivityService.shared.videoActivities.asObservable()
        videos.subscribe(onNext: {[weak self] (observable) in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }).addDisposableTo(bag)

        self.handleUIEvent {[weak self] (event: UIShowFeedEvent) in
            if let count = self?.navigationController?.viewControllers.count, count > 1 {
                _ = self?.navigationController?.popToRootViewController(animated: false)
            }
        }

        self.handleUIEvent {[weak self] (event: UIFeedDrillDownEvent) in
            if let indexPath = self?.viewModel.indexPathFor(type: event.type), let strongSelf = self {
                self?.tableView(strongSelf.tableView, didSelectRowAt: indexPath)
            }
        }
        self.handleBGEvent {[weak self] (event: BGApplicationDidBecomeActiveEvent) in
            if event.fromBackground == true {
                DispatchQueue.main.async {
                    self?.viewModel.refresh()
                }
            }
        }
    }

    @IBAction func didTapSettings(_ sender: Any) {
        showSettings()
    }

    func showSettings() {
        let vc: SettingsVC = UIStoryboard(storyboard: .Settings).instantiateViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func onRefresh() {
        self.viewModel.refresh()
    }
}

extension FeedVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: viewModel.items[indexPath.row])
        cell.bubble.setTitle(String(viewModel.items[indexPath.row].itemsCount()), for: .normal)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: ActivitiesVC = UIStoryboard(storyboard: .Activities).instantiateViewController()
        vc.viewModel.type = viewModel.items[indexPath.row].type
        vc.title = viewModel.items[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedVC {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
