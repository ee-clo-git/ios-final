//
//  TPPPostActivitySurveyRequest.swift
//  TPP
//
//  Created by Mihails Tumkins on 27/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import Moya
import RxSwift

class TPPPostActivitySurveyRequest: TPPBaseRequest {
    override var requestPath: String { return "v1/user_activities" }
    override var requestMethod: Moya.Method { return Moya.Method.post }

    required init(activityId: Int, answers: [Int: SurveyAnswer]) {
        var params: [String : Any] = [
            "activity_id": activityId,
            "content_type": "survey"]

        var attributes = [[String : Any]]()

        for (qid, answer) in answers {
            switch answer {
            case .multiple(let values):
                attributes.append([
                    "question_id": qid,
                    "answer_options_attributes": values.map { return ["option_id": $0.id] },
                    "question_type": answer.rawValue
                    ])
            case .single(let value):
                if let optionId = value.id {
                    attributes.append([
                        "question_id": qid,
                        "option_id": optionId,
                        "question_type": answer.rawValue
                        ])
                }
            case .text(let value):
                attributes.append([
                    "question_id": qid,
                    "description": value,
                    "question_type": answer.rawValue
                    ])
            }
        }
        params["answers_attributes"] = attributes
        super.init(params: params)
    }

    func send() -> Observable<ActivityCreateResponseDO> {
        return super.send() as Observable<ActivityCreateResponseDO>
    }
}
