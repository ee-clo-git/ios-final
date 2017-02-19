//
//  SurveyViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 02/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper

enum SurveyAnswer {
    case multiple(values: [OptionDO])
    case single(value: OptionDO)
    case text(value: String)

    var rawValue: String {
        switch self {
        case .multiple(_):
            return "multiple"
        case .single(_):
            return "single choice"
        case .text(_):
            return "text"
        }
    }
}

class SurveyViewModel: BaseViewModel {

    let disposeBag = DisposeBag()
    let activity: ActivityDO
    var activityCompletionHandler: ((ActivityCreateResponseDO) -> Void)?

    var currentQuestionIndex: Int = 0

    var answers = [Int: SurveyAnswer]()

    let colors: [UIColor] = [
        UIColor(red:0.38, green:0.30, blue:0.62, alpha:1.00),
        UIColor(red:0.56, green:0.78, blue:0.29, alpha:1.00),
        UIColor(red:0.41, green:0.86, blue:0.87, alpha:1.00),
        UIColor(red:0.98, green:0.67, blue:0.11, alpha:1.00),
        UIColor(red:0.21, green:0.53, blue:0.78, alpha:1.00)
    ]

    init(activity: ActivityDO) {
        self.activity = activity
    }

    func pageTitle() -> String? {
        return String(format: "%i/%i", currentQuestionIndex + 1, activity.questions!.count)
    }

    func questionTitle() -> String? {
        guard activity.questions?.indices.contains(currentQuestionIndex) == true, let question = activity.questions?[currentQuestionIndex] else {
            return nil
        }
        return question.description
    }

    func questionAnswers() -> [OptionDO]? {
        if let question: QuestionDO = activity.questions?[currentQuestionIndex], let type = question.type {
            switch type {
            case .multiple, .single:
                return question.options
            default:
                break
            }
        }
        return nil
    }

    func nextQuestionType() -> QuestionType? {
        let index = currentQuestionIndex + 1
        guard activity.questions?.indices.contains(index) == true, let question = activity.questions?[index] else {
            return nil
        }
        return question.type
    }

    func currentQuestionType() -> QuestionType? {
        guard activity.questions?.indices.contains(currentQuestionIndex) == true, let question = activity.questions?[currentQuestionIndex] else {
            return nil
        }
        return question.type
    }

    func answer(value: String) {
        guard let question: QuestionDO = activity.questions?[currentQuestionIndex],
              let questionId = question.id,
              question.type == .text else { return }
        self.answers[questionId] = SurveyAnswer.text(value: value)
    }

    func answer(indexes: [Int]) {
        guard let question: QuestionDO = activity.questions?[currentQuestionIndex],
              let questionId = question.id,
              let options = question.options,
              question.type == .multiple else { return }

        let values = indexes.map { return options[$0] }
        self.answers[questionId] = SurveyAnswer.multiple(values: values)
    }

    func answer(index: Int) {
        guard let question: QuestionDO = activity.questions?[currentQuestionIndex],
              let questionId = question.id,
              let options = question.options,
              question.type == .single else { return }
        self.answers[questionId] = SurveyAnswer.single(value: options[index])
    }

    func randomColor() -> UIColor {
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[index]
    }

    func submit() {
        if let activityId = activity.id {
            self.isLoading.value = true

            TPPPostActivitySurveyRequest(activityId: activityId, answers: answers)
                .send()
                .subscribe {[weak self] (event) in
                    self?.isLoading.value = false
                    switch event {
                    case .next(let activity):
                        self?.activityCompletionHandler?(activity)
                        self?.completionHandler?()
                    case .error(let error):
                        self?.errorHandler?(error)
                    default:
                        break
                    }
                }.addDisposableTo(self.disposeBag)
        }
    }
}
