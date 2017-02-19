//
//  TPPActivityService.swift
//  TPP
//
//  Created by Mihails Tumkins on 30/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import RxSwift
import ImagePicker
import STPopup
import AVFoundation
import Photos
import FBSDKShareKit
import TwitterKit

class TPPActivityService: NSObject, PubSubSubscriberProtocol, EventBusObservable {

    static let shared = TPPActivityService()
    internal var eventBusObserver = EventBusObserver()
    internal let disposeBag = DisposeBag()

    private var rootWindow: UIWindow? {
        return UIApplication.shared.delegate?.window!
    }

    let videoActivities = Variable<[ActivityDO]>([])
    let photoActivities = Variable<[ActivityDO]>([])
    let surveyActivities = Variable<[ActivityDO]>([])
    let socialActivities = Variable<[ActivityDO]>([])

    var isLoading = Variable(false)
    var error = Variable<Error?>(nil)

    var selectedActivityId: Int?

    var completionHandler: ((ActivityCreateResponseDO) -> Void)?
    var errorHandler: ((Error) -> Void)?
    var progressHandler: ((Double) -> Void)?

    var lastSocialUserActivityEvent: TPPCreateUserActivityEvent?

    func registerForEvents() {

        self.handleUIEvent {[weak self] (event: TPPLoadActivityListEvent) in
            self?.loadActivityList()
            BGUpdateUserEvent().send()
        }
        self.handleBGEvent {[weak self] (event: BGDidLoginEvent) in
            self?.loadActivityList()
        }

        self.handleUIEvent {[weak self] (event: TPPCreateUserActivityEvent) in

            switch event.type {
            case .photo(let activityId), .video(let activityId):
                self?.selectedActivityId = activityId
                self?.progressHandler = event.progressHandler
                self?.errorHandler = event.errorHandler
                self?.completionHandler = event.completionHandler
                Configuration.mediaTypes = .video(activityId) == event.type ? [.video] : [.image]
                let imagePickerController = ImagePickerController()
                imagePickerController.imageLimit = 1
                imagePickerController.delegate = self
                event.target.present(imagePickerController, animated: true, completion: nil)
            case .social(let activity):
                self?.lastSocialUserActivityEvent = event
                guard let socialType = activity.socialType else { return }
                switch socialType {
                case .facebook:
                    self?.shareFacebookActivity(event: event)
                case .twitter:
                    self?.twitterFollow(event: event)
                    break
                }

            case .survey(let activity):
                UIShowSurveyScreenEvent(activity,
                                        errorHandler: event.errorHandler,
                                        completion: event.completionHandler).send()
            case .comment(let activity):
                let vc: ActivityActionCommentVC = UIStoryboard(storyboard: .Activities).instantiateViewController()
                vc.viewModel = {
                    let vm = ActivityActionCommentViewModel(activity: activity)
                    vm.completionHandler = event.completionHandler
                    vm.errorHandler = event.errorHandler
                    vm.progressHandler = event.progressHandler
                    return vm
                }()
                self?.showPopup(vc, on: event.target)
            }
        }
    }

    private func loadActivityList() {
        let request = TPPActivitiesListRequest()
        isLoading.value = true
        request.send().subscribe { [weak self] event -> Void in
            self?.isLoading.value = false
            switch event {
            case .next(let response):
                if let activities = response.surveys {
                    self?.surveyActivities.value = activities
                }
                if let activities = response.photos {
                    self?.photoActivities.value = activities
                }
                if let activities = response.videos {
                    self?.videoActivities.value = activities
                }
                if let activities = response.social {
                    self?.socialActivities.value = activities
                }
            case .error(let error):
                self?.error.value = error
            default:
                break
            }
        }.addDisposableTo(disposeBag)
    }

    private func showPopup(_ aVc: UIViewController, on containerVc: UIViewController) {
        let popup = STPopupController(rootViewController: aVc)
        popup.containerView.layer.cornerRadius = 8
        popup.containerView.tintColor = UIColor.mainViolet
        popup.present(in: containerVc)
    }
}

extension TPPActivityService {
    internal func twitterFollow(event: TPPCreateUserActivityEvent) {
        switch event.type {
        case .social(let activity):
            if let socialLink = activity.socialLink {
                Twitter.sharedInstance().logIn { [weak self] session, error in
                    if session != nil {
                        self?.follow(link: socialLink, userId: session?.userID)
                    } else {
                        if error != nil {
                            self?.lastSocialUserActivityEvent?.errorHandler?(error!)
                        }
                        self?.lastSocialUserActivityEvent = nil
                    }
                }
            } else if let socialText = activity.socialText {
                let composer = TWTRComposer()
                composer.setText(socialText)
                composer.show(from: event.target) {[weak self] result in
                    if result == .done {
                        self?.lastSocialUserActivityEvent?.completionHandler?(nil)
                    }
                }
            }
        default:
            break
        }
    }

    private func follow(link: String, userId: String?) {
        let screenName = link.components(separatedBy: "/").last
        let client = TWTRAPIClient(userID: userId)
        let statusesShowEndpoint = "https://api.twitter.com/1.1/friendships/create.json"
        let params = ["screen_name": screenName]
        var clientError: NSError?

        let request = client.urlRequest(withMethod: "POST", url: statusesShowEndpoint, parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { [weak self] (response, data, error) -> Void in
            if error != nil {
                self?.lastSocialUserActivityEvent?.errorHandler?(error!)
                self?.lastSocialUserActivityEvent = nil
            } else {
                self?.createSocialActivity()
            }
        }
    }

}

extension TPPActivityService {
    func createSocialActivity() {
        if let type = lastSocialUserActivityEvent?.type {
            switch type {
            case .social(let activity):
                guard let activityId = activity.id, let socialType = activity.socialType else { break }
                   _ = TPPPostSocialActivityRequest(activityId: activityId, type: socialType)
                        .send()
                        .subscribe {[weak self] (event) in
                            switch event {
                            case .next(_):
                                self?.lastSocialUserActivityEvent?.completionHandler?(nil)
                                TPPLoadActivityListEvent().send()
                            case .error(let error):
                                self?.lastSocialUserActivityEvent?.errorHandler?(error)
                            default:
                                break
                            }
                            self?.lastSocialUserActivityEvent = nil
                        }
            default:
                break
            }
        }
    }
}

extension TPPActivityService: FBSDKSharingDelegate {

    internal func shareFacebookActivity(event: TPPCreateUserActivityEvent) {
        switch event.type {
        case .social(let activity):

            let linkContent = FBSDKShareLinkContent()
            if let name = (activity.content?.fbContent ?? activity.content?.name) {
                linkContent.contentTitle = name
            }
            if let text = activity.socialText {
                linkContent.quote = text
            }
            if let socialLink = activity.socialLink {
                linkContent.contentURL = URL(string: socialLink)
            } else {
                linkContent.contentURL = URL(string: "https://www.facebook.com/epicenterexp/")
            }

            let dialog = FBSDKShareDialog()
            dialog.fromViewController = event.target
            dialog.shareContent = linkContent
            dialog.mode = .automatic
            dialog.delegate = self
            dialog.show()
        default:
            break
        }
    }

    func sharerDidCancel(_ sharer: FBSDKSharing!) {}

    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        if error != nil {
            lastSocialUserActivityEvent?.errorHandler?(error)
        }
        lastSocialUserActivityEvent = nil
    }

    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        if !results.isEmpty {
            self.createSocialActivity()
        } else {
            lastSocialUserActivityEvent = nil
        }
    }
}

extension TPPActivityService: ImagePickerDelegate {

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {}

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = images.first, let activityId = selectedActivityId {
            uploadImage(image: image, activityId: activityId)
        }
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, videos: [PHAsset]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let video = videos.first, let activityId = selectedActivityId {
            let imageManager = PHImageManager.default()
            let options = PHVideoRequestOptions()
            options.deliveryMode = .mediumQualityFormat
            imageManager.requestAVAsset(forVideo: video, options: options, resultHandler: {[weak self] (avAsset, _, _) in
                if let avAsset = avAsset {
                    let semaphore = DispatchSemaphore(value: 0)
                    self?.upload(video: avAsset, activityId: activityId, semaphore: semaphore)
                    _ = semaphore.wait(timeout: .distantFuture)
                }
            })
        }
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    private func uploadImage(image: UIImage, activityId: Int) {
        if let data = UIImageJPEGRepresentation(image, 0.9) {
            DispatchQueue.main.async {
                self.progressHandler?(0.001)
            }
            let request = TPPPostPhotoActivityRequest(activityId: activityId, data: data)

            request.progressHandler = { [weak self] progress in
                self?.progressHandler?(progress)
            }

            request.errorHandler = { [weak self] error in
                self?.errorHandler?(error)
            }

            request.completionHandler = { [weak self] response in
                TPPLoadActivityListEvent().send()
                self?.completionHandler?(response)
            }

            request.send()
        }
    }

    private func upload(video: AVAsset, activityId: Int, semaphore: DispatchSemaphore) {
        if let url = (video as? AVURLAsset)?.url {
            DispatchQueue.main.async {
                self.progressHandler?(0.001)
            }
            let fileName = video.fileName()
            let mime = video.mimeType()

            let request = TPPPostVideoActivityRequest(activityId: activityId,
                                                      videoURL: url,
                                                      fileName: fileName,
                                                      mime: mime)

            request.progressHandler = { [weak self] progress in
                self?.progressHandler?(progress)
            }

            request.errorHandler = { [weak self] error in
                self?.errorHandler?(error)
                semaphore.signal()
            }

            request.completionHandler = { [weak self] response in
                self?.completionHandler?(response)
                semaphore.signal()
                TPPLoadActivityListEvent().send()
            }

            request.send()
        }
    }
}

import MobileCoreServices

public extension AVAsset {
    func mimeType() -> String {
        if let urlAsset = self as? AVURLAsset {
            return urlAsset.url.mimeType()
        }
        return "application/octet-stream"
    }

    func fileName() -> String {
        if let urlAsset = self as? AVURLAsset {
            return urlAsset.url.lastPathComponent
        }
        return "file"
    }

    func calculateFileSize() -> Float {
        if let URLAsset = self as? AVURLAsset {
            var size: AnyObject?
            try? (URLAsset.url as NSURL).getResourceValue(&size, forKey: URLResourceKey.fileSizeKey)
            if let size = size as? NSNumber {
                return size.floatValue
            } else {
                return 0
            }
        } else if let _ = self as? AVComposition {
            var estimatedSize: Float = 0.0
            var duration: Float = 0.0
            for track in self.tracks {
                let rate = track.estimatedDataRate / 8.0
                let seconds = Float(CMTimeGetSeconds(track.timeRange.duration))
                duration += seconds
                estimatedSize += seconds * rate
            }
            return estimatedSize
        } else {
            return 0
        }
    }
}
public extension URL {
    func mimeType() -> String {
        let pathExtension = self.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}
