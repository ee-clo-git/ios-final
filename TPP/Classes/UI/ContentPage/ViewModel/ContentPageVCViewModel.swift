//
// Created by Igors Nemenonoks on 12/10/16.
// Copyright (c) 2016 Chili. All rights reserved.
//

import Foundation
import RxSwift

class ContentPageVCViewModel {

    let item: ActivityDO
    var itemUpdateHandler:(() -> Void)?
    var activityTitle: String? {
        return item.type?.actionTitle()
    }
    var iconImageName: String {
        guard let type = item.content?.type else {
            return "title_icon_game"
        }
        switch type {
        case .video:
            return "title_icon_video"
        case .survey:
            return "title_icon_survey"
        case .photo:
            return "title_icon_photo"
        case .social:
            return "title_icon_socal"
        }
    }

    var activityWithTypeSubmited = false

    let disposeBag = DisposeBag()

    func socialTitle() -> String? {
        guard let type = item.socialType else { return nil }
        switch type {
        case .facebook:
            return "Share"
        case .twitter:
            return "Follow"
        }
    }

    init(item: ActivityDO) {
        self.item = item
        self.addHandlers()

        /*if let id = item?.id {
            BGTrackViewEvent(type: "content", id: id).send()
        }*/
    }

    func trackWatch() {
        /*if let id = self.item?.id {
            BGTrackWatchEvent(type: "content", id: id).send()
        }*/
    }

    private func addHandlers() {
        /*
        UIEventBus.sharedInstance.rac_handleClass(UIItemUpdatedEvent.className, target: self) {[weak self] object in
            if let handler = self?.itemUpdateHandler{
                handler()
            }
        }
        UIEventBus.sharedInstance.rac_handleClass(UINewCommentSentEvent.className, target: self) {[weak self] object in
            if let event = object as? UINewCommentSentEvent {
                if self?.item?.id == event.id && self?.item?.entityName() == event.entity{
                    self?.item = self?.item?.incrementCommentsCount()
                    if let handler = self?.itemUpdateHandler {
                        handler()
                    }
                }
            }
        }*/
    }

    func like(handler:(_ error: NSError?) -> Void) {
        /*
        if let id = self.item?.id {
            let likedByMe = self.item?.likedByMe == true
            let apiMethod = likedByMe ? APIConfig.APIUrls.unlike : APIConfig.APIUrls.like
            let request = APIRequest(path: apiMethod, params: ["entity": "content", "id": id])
            request.post {[weak self] (response: Response<LikeResponseDO, NSError>) in
                if response.result.error == nil{
                    self?.updateItem(!likedByMe, likesCount:response.result.value?.likesCount)
                }
                handler(error:response.result.error)
            }
            self.request = request
        }
         */
    }

    private func updateItem(like: Bool, likesCount: Int?) {
        /*
        if let likesCount = likesCount{
            if let item = self.item?.updateLike(like, likesCount: likesCount){
                self.item = item
                UIItemUpdatedEvent(type: "content", itemId: item.id!, likesCount: item.likesCount, likedByMe: item.likedByMe).send()
            }
        }
        */
    }

    func photos() -> [String] {
        var items = [String]()
        if let content = item.content?.url, item.content?.type == .photo {
            items.append(content)
        }
        if let photos = item.content?.photos {
            items = photos.map({ $0["url"]! })
        }
        return items
    }

    func submitActivityWithType(errorHandler: ((Error) -> Void)?, completionHandler: (() -> Void)?) {
        guard let activityId = item.id, let type = item.type, activityWithTypeSubmited == false else { return }

        self.activityWithTypeSubmited = true

        TPPPostActivityTypeRequest(activityId: activityId, type: type)
            .send()
            .subscribe { [weak self] (event) in
                switch event {
                case .next(_):
                    completionHandler?()
                case .error(let error):
                    self?.activityWithTypeSubmited = false
                    errorHandler?(error)
                default:
                    break
                }
        }.addDisposableTo(disposeBag)
    }
}
