//
//  TPPPostPhotoActivityRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 05/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPPostPhotoActivityRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/user_activities" }
    override var requestMethod: Moya.Method { return .post }

    let data: Data

    var errorHandler: ((Swift.Error) -> Void)?
    var progressHandler: ((Double) -> Void)?
    var completionHandler: ((ActivityCreateResponseDO) -> Void)?

    init(activityId: Int, data: Data) {
        self.data = data
        let params: [String : Any] = [
            "activity_id": activityId,
            "content_type": "photo"]
        super.init(params: params)
    }

    override var requestTask: Task {
        let formData = MultipartFormData(provider: .data(self.data), name: "file", fileName: "photo.jpg", mimeType: "image/jpg")
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
