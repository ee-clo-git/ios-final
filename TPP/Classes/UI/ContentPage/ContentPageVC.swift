//
//  ContentPageVC.swift
//  TPP
//
//  Created by Igors Nemenonoks on 22/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import AVKit
import SafariServices
import MBProgressHUD

class ContentPageVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vidCont: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityButton: ButtonWithPreloader!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    internal var player: AVPlayer?
    internal var playStarted = false
    internal var prevViewHeight: CGFloat = 0

    var viewModel: ContentPageVCViewModel?

    var timer: Timer?

    internal lazy var progressHud: MBProgressHUD = {
        let mb = MBProgressHUD.showAdded(to: self.view, animated: true)
        mb.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        mb.mode = .annularDeterminate
        mb.label.text = "Uploading ..."
        return mb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateItemData()

        self.navigationController?.hidesBarsWhenVerticallyCompact = true

        if let url = self.viewModel?.item.content?.url {
            if self.viewModel?.item.content?.type == .photo {
                self.loader.stopAnimating()
               if self.viewModel?.item.type == .view {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        self?.submitActivityWithType()
                    }
                }
            } else {
                self.playVideo(url)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(checkVideoTime), userInfo: nil, repeats: true)
            }
        } else {
            self.loader.stopAnimating()
        }

        self.addHandlers()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTimer()
    }

    private func addHandlers() {
        self.viewModel?.itemUpdateHandler = {[weak self] in
            self?.updateItemData()
        }
    }

    private func updateItemData() {
        if let item = self.viewModel?.item.content {
            self.titleView.text = item.name
            self.descLabel.attributedText = item.attributedDescription()

            if let activityTitle = self.viewModel?.socialTitle() ?? self.viewModel?.activityTitle {
                self.activityButton.setTitle(activityTitle, for: .normal)
                self.typeLabel.text = activityTitle
            } else {
                self.activityButton.isHidden = true
                self.typeLabel.isHidden = true
            }
            if let image = self.viewModel?.iconImageName {
                self.titleImageView.image = UIImage(named: image)
            }
            //self.likeButton.setImage(UIImage(named: (item.likedByMe == true ? "ico_like_active" : "ico_like")), for: .normal)
            //self.likeButton.setTitle((item.likedByMe == true ? "Unlike" : "Like"), for: .normal)
        }
    }

    @IBAction func onCLoseTap(_ sender: Any) {
        self.onDismiss()
    }

    @objc private func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onActionTap(_ sender: Any) {
        createUserActivity()
    }

    func submitActivityWithType() {

        var popupImageName = self.viewModel?.item.type?.popupImageName
        if let contentType = self.viewModel?.item.content?.type, self.viewModel?.item.type == .view {
            popupImageName = ActivityType(rawValue: contentType.rawValue)?.popupImageName ?? popupImageName
        }

        self.viewModel?.submitActivityWithType(errorHandler: { [weak self] (error) in
            self?.showTPPAlert(error: error)
            self?.progressHud.hide(animated: true)
        }, completionHandler: { [weak self] in
            TPPLoadActivityListEvent().send()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.showActivityCompletedAlert(popupImageName: popupImageName, shouldDismiss: false, showRewards: false)
            }
        })
    }

    func createUserActivity() {
        if let activityType = self.viewModel?.item.activityType() {
            TPPCreateUserActivityEvent(target: self, type: activityType, progress: {[weak self] in
                if self?.progressHud.superview == nil, let strongSelf = self {
                    self?.progressHud = MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
                }
                self?.progressHud.progress = Float($0)
                }, error: { [weak self] error in
                    self?.showTPPAlert(error: error)
                    self?.progressHud.hide(animated: true)
                }, completion: { [weak self] response in
                    UIShowRewardsEvent().send()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self?.showActivityCompletedAlert(popupImageName: self?.viewModel?.item.type?.popupImageName)
                    }
                    self?.progressHud.hide(animated: true)
            }).send()
        }
    }

    private func showActivityCompletedAlert(popupImageName: String?, shouldDismiss: Bool = true, showRewards: Bool = true) {
        self.showTPPIconAlert(title: "Thank You", message: "We just put $1 in your wallet!", action: "OK", image: popupImageName, completion: {[weak self] (action) in

            if shouldDismiss {
                self?.dismiss(animated: true, completion: nil)
            }
            if showRewards {
                UIShowRewardsEvent().send()
            }
        })
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let svc = SFSafariViewController(url:URL)
        self.present(svc, animated: true, completion: nil)
        return false
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let horizontal: Bool = size.width > size.height
        self.scrollViewTopConstraint.constant = horizontal ? 8 : 60
        if self.viewModel?.item.content?.type == .photo {
            self.collectionViewHeightConstraint.constant = horizontal ? size.height : self.prevViewHeight
        } else if self.viewModel?.item.content?.type == .video {
            self.collectionViewHeightConstraint.constant = horizontal ? size.height : self.view.frame.width/16*9
        }
        coordinator.animate(alongsideTransition: { (_) in
            self.closeButton.alpha = horizontal ? 0 : 1
            self.moreButton.alpha = horizontal ? 0 : 1
            self.activityButton.alpha = horizontal ? 0 : 1
            self.view.layoutIfNeeded()
        }) { (_) in
            self.collectionView.reloadData()
        }
    }

    @IBAction func didTapShare(_ sender: UIButton) {

        var items = [String]()
        if let url = self.viewModel?.item.content?.url { items.append(url) }
        if let about = self.viewModel?.item.content?.fbContent { items.append(about) }

        if !items.isEmpty {
            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            vc.popoverPresentationController?.sourceView = sender
            self.present(vc, animated: true, completion: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//video
extension ContentPageVC {
    @objc internal func checkVideoTime() {
        if let currentItem = self.player?.currentItem {
            let curTime = CMTimeGetSeconds(player!.currentTime())
            let duration = CMTimeGetSeconds(currentItem.asset.duration)
            if curTime/duration > 0.5 {
                self.removeTimer()
                self.viewModel?.trackWatch()

                if self.viewModel?.item.type == .view {
                    self.submitActivityWithType()
                }
            }

            if currentItem.status == .readyToPlay && self.playStarted == false {
                self.playStarted = true
                self.player?.play()
            }
        }
    }

    internal func playVideo(_ videoUrl: String) {
        self.collectionViewHeightConstraint.constant = self.view.frame.width/16*9
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

        if let videoURL = URL(string: videoUrl) {
            print(videoUrl)
            self.loader.stopAnimating()
            let player = AVPlayer(url: videoURL)
            let av = AVPlayerViewController()
            av.player = player
            av.view.frame = self.vidCont.bounds
            self.addChildViewController(av)
            self.vidCont.addSubview(av.view)
            av.didMove(toParentViewController: self)
            self.vidCont.isHidden = false
            self.player = player
        }

    }

    internal func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

extension ContentPageVC {
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

extension ContentPageVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.photos().count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.photos().count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ContentPageImageCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ContentPageImageCell {
            cell.delegate = self
            if let model = self.viewModel?.photos()[indexPath.row] {
                cell.configure(with: model)
            }
        }
    }
}

extension ContentPageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension ContentPageVC: ContentImageDownloadDelegate {
    func didDownload(image: UIImage) {
        guard self.view.frame.width < self.view.frame.height else {
            //do not resize
            return
        }
        self.collectionViewHeightConstraint.constant = ceil(image.size.height/image.size.width*self.view.bounds.width)
        self.prevViewHeight = self.collectionViewHeightConstraint.constant
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .allowUserInteraction, animations: {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func onError(error: Error) {
        self.showTPPAlert(error: error)
    }

}
