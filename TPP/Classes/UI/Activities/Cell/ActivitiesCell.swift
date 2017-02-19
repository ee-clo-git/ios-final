//
//  ActivitiesCell.swift
//  TPP
//
//  Created by Mihails Tumkins on 29/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import UICircularProgressRing

class ActivitiesCell: UITableViewCell, Reusable {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var expirationImage: UIImageView!
    @IBOutlet weak var expirationLabel: UILabel!

    let loading = Variable<Bool>(false)
    let progress = Variable<CGFloat>(0)
    private let bag = DisposeBag()

    private lazy var loadingView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        v.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        v.alpha = 0
        return v
    }()

    private lazy var activityIndicator: UICircularProgressRingView = {
        let a = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        a.fontColor = .mainViolet
        a.fontSize = 12
        a.maxValue = 100.0
        a.outerRingColor = .separator
        a.innerRingColor = .mainViolet
        a.outerRingWidth = 1
        a.innerRingWidth = 2
        return a
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        roundedView.clipsToBounds = true
        roundedView.layer.borderWidth = 1.0
        roundedView.layer.borderColor = UIColor.separator.cgColor
        roundedView.layer.cornerRadius = 4.0

        self.loading.asObservable().skip(1).subscribe(onNext: { [weak self] (isLoading) in
            self?.showPreloader(isLoading)
        }).addDisposableTo(bag)

        self.progress.asObservable().skip(1).subscribe(onNext: {[weak self] aProgress in
            self?.activityIndicator.setProgress(value: aProgress, animationDuration: 0.1)
        }).addDisposableTo(bag)
    }

    func configure(with activity: ActivityDO) {
        titleLabel.text = activity.content?.name ?? activity.name

        if let count = activity.questionsCount {
            questionsLabel.alpha = 1.0
            questionsLabel.text = "\(count) questions"
        } else if let count = activity.questions?.count {
            questionsLabel.alpha = 1.0
            questionsLabel.text = "\(count) questions"
        } else if let about = activity.content?.attributedDescription()?.string {
            questionsLabel.alpha = 1.0
            questionsLabel.text = about
        } else {
            questionsLabel.alpha = 0.0
        }
        if activity.type == .view {
            if let contentType = activity.content?.type {
                typeImage.image = UIImage(named: ActivityType(rawValue: contentType.rawValue)?.iconImageName ?? "")
            }
        } else {
            typeImage.image = UIImage(named: activity.type?.iconImageName ?? "")
        }

        typeImage.contentMode = .scaleAspectFit
    }

    private func showPreloader(_ loading: Bool) {
        guard (self.loadingView.alpha == 0 && loading == true) || (self.loadingView.alpha == 1 && loading == false) else {
            return
        }

        self.loadingView.alpha = loading ? 0 : 1
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = loading ? 1 : 0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.loadingView.alpha = 0
    }
}
