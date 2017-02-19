//
//  TPPPostVideoRequest.swift
//  TPP
//
//  Created by Igors Nemenonoks on 03/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import Moya
import Alamofire

class TPPPostVideoActivityRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/user_activities" }
    override var requestMethod: Moya.Method { return .post }

    let videoURL: URL
    let fileName: String
    let mime: String

    var errorHandler: ((Swift.Error) -> Void)?
    var progressHandler: ((Double) -> Void)?
    var completionHandler: ((ActivityCreateResponseDO) -> Void)?

    init(activityId: Int, videoURL: URL, fileName: String, mime: String) {
        self.videoURL = videoURL
        self.fileName = fileName
        self.mime = mime
        let params: [String : Any] = [
            "activity_id": activityId,
            "content_type": "video"]
        super.init(params: params)
    }

    override var requestTask: Task {
        let formData = MultipartFormData(provider: .file(self.videoURL),
                                         name: "file",
                                         fileName: self.fileName,
                                         mimeType: self.mime)
        return .upload(.multipart([formData]))
    }

    func send() {
        let provider = TPPApiProvider.shared
        let progressClosure: ProgressBlock = { [weak self] response in
            self?.progressHandler?(response.progress)
        }

        let progressCompletionClosure: Completion = { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let map = try response.mapObject(ActivityCreateResponseDO.self)
                    self?.completionHandler?(map)
                } catch {
                    self?.errorHandler?(MoyaError.statusCode(response))
                }
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
        provider.request(self, queue: DispatchQueue.main, progress: progressClosure, completion: progressCompletionClosure)
    }
}
