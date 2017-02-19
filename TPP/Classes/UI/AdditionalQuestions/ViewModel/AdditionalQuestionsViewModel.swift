//
//  AdditionalQuestionsViewModel.swift
//  TPP
//
//  Created by Mihails Tumkins on 28/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import RxSwift
import Moya
import Moya_ObjectMapper

class AdditionalQuestionsViewModel: BaseViewModel {

    static let yearMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    let hhiOptions = [
        HouseholdIncome.under25.textValue,
        HouseholdIncome.under35.textValue,
        HouseholdIncome.under50.textValue,
        HouseholdIncome.under75.textValue,
        HouseholdIncome.under99.textValue,
        HouseholdIncome.under150.textValue,
        HouseholdIncome.above150.textValue
    ]

    let maritalOptions = [
        MaritalStatus.single.rawValue.capitalized,
        MaritalStatus.married.rawValue.capitalized,
        MaritalStatus.separated.rawValue.capitalized,
        MaritalStatus.widowed.rawValue.capitalized,
        MaritalStatus.divorced.rawValue.capitalized
    ]

    let genderOptions = [
        Gender.male.rawValue.capitalized,
        Gender.female.rawValue.capitalized
    ]

    let ethnicityOptions = [
        Ethnicity.african.rawValue,
        Ethnicity.indian.rawValue,
        Ethnicity.asian.rawValue,
        Ethnicity.hispanic.rawValue,
        Ethnicity.white.rawValue
    ]

    let childrenOptions = [
        ChildOption.zero.textValue,
        ChildOption.one.textValue,
        ChildOption.two.textValue,
        ChildOption.threeOrFour.textValue,
        ChildOption.moreThanFour.textValue
    ]

    let sectionTitles = [
        "About",
        "Details"
    ]

    let rowTitles = [
        "Birthday",
        "Household Income",
        "Marital Status",
        "Gender",
        "Number of Children",
        "Ethnicity",
        "Zip Code"
    ]

    let disposeBag = DisposeBag()

    var selectedGender: Gender?

    let user = UserService.shared.user

    func updateBirthday(birthday: String) {
        self.update(params: ["birthday": formatBirthdayForSending(birthday: birthday)])
    }

    func updateGender() {
        if let gender = selectedGender {
            self.update(params: ["gender": gender.rawValue])
        }
    }

    func updateGender(value: String?) {
        guard let value = value?.lowercased(), let gender = Gender(rawValue: value) else { return }
        self.selectedGender = gender
        self.update(params: ["gender": gender.rawValue])
    }

    func updateZipCode(zipCode: String) {
        self.update(params: ["zip": zipCode])
    }

    func updateEthnicity(value: String?) {
        guard let value = value, let ethnicity = Ethnicity(rawValue: value) else { return }
        self.update(params: ["ethnicity": ethnicity.rawValue])
    }

    func updateHHI(value: String?) {
        guard let value = value, let income = HouseholdIncome.fromString(string: value)  else { return }
        self.update(params: ["hhi": income.rawValue])
    }

    func updateChildren(value: String?) {
        guard let value = value, let income = ChildOption.fromString(string: value)  else { return }
        self.update(params: ["presence_of_children": income.rawValue])
    }

    func updateMaritalStatus(value: String?) {
        guard let value = value?.lowercased(), let status = MaritalStatus(rawValue: value) else { return }
        self.update(params: ["marital_status": status.rawValue])
    }

    func updateBirthday(date: Date) {
        let birthday = AdditionalQuestionsViewModel.yearMonthDayFormatter.string(from: date)
        self.update(params: ["birthday": birthday])
    }

    func updatePassword(currentPassword: String, newPassword: String) {
        self.update(params: ["old_password": currentPassword, "password": newPassword, "password_confirmation": newPassword ])
    }

    private func update(params: [String: Any]) {
        guard let user = UserService.shared.user.value else { return }
        let request = TPPUpdateUserRequest(user: user, params: params)
        self.isLoading.value = true

        request.send().subscribe { [weak self] event -> Void in
            self?.isLoading.value = false
            switch event {
            case .next(let response):
                if let user = response.user {
                    BGDidRefreshEvent(user: user).send()
                }
                self?.completionHandler?()
            case .error(let error):
                self?.errorHandler?(error)
            default:
                break
            }
        }.addDisposableTo(disposeBag)
    }

    func getBirthday() -> String? {
        guard let birthday = user.value?.birthday else { return nil }
        return formatBirthdayFromUser(birthday: birthday)
    }

    func getBirthDate() -> Date? {
        if let birthday = user.value?.birthday {
            let date = AdditionalQuestionsViewModel.yearMonthDayFormatter.date(from: birthday)
            return date
        }
        return nil
    }

    // MM/DD/YYYY -> YYYY-MM-DD
    private func formatBirthdayForSending(birthday: String) -> String {
        let arr = birthday.components(separatedBy: "/")
        let formattedBirthDay = String(format:"%@-%@-%@", arr[2], arr[0], arr[1])
        return formattedBirthDay
    }

    // YYYY-MM-DD -> MM/DD/YYYY
    private func formatBirthdayFromUser(birthday: String) -> String {
        let arr = birthday.components(separatedBy: "-")
        let formattedBirthDay = String(format:"%@/%@/%@", arr[1], arr[2], arr[0])
        return formattedBirthDay
    }

    func formatForTextField(input: String) -> String {
        let emptyString = ""
        let sepCharacter: Character = "/"
        var output = input.replacingOccurrences(of: "MM", with: emptyString)
        output = output.replacingOccurrences(of: "DD", with: emptyString)
        output = output.replacingOccurrences(of: "YYYY", with: emptyString)

        while output.characters.last == sepCharacter {
            output = output.substring(to: output.index(before: output.endIndex))
        }
        return output
    }

    func formatTextAreaInput(input: String?) -> String {
        guard var input = input else {
            return "MM/DD/YYYY"
        }

        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let currentYear =  components.year

        var monthString = "MM"
        var dayString = "DD"
        var yearString = "YYYY"

        input = input.replacingOccurrences(of: "/", with: "", options: NSString.CompareOptions.literal, range:nil)

        let newMonthString = input.substring(with: 0..<2)
        let newDayString = input.substring(with: 2..<4)
        let newYearString = input.substring(with: 4..<8)

        if let month = Int(newMonthString) {
            if month <= 12 {
                monthString = newMonthString
            }
        }

        if let day = Int(newDayString) {
            if day <= 31 {
                dayString = newDayString
            }
        }

        var modNewYearString = ""
        if newYearString.isEmpty == false && newYearString.characters.count < 4 {
            let first = newYearString.substring(with: 0..<1)
            if first == "2" {
                modNewYearString = newYearString + (newYearString.characters.count == 1 ? "000" : (newYearString.characters.count == 2 ? "00" : "0"))
            }
            if first == "1" {
                modNewYearString = newYearString + (newYearString.characters.count == 1 ? "900" : (newYearString.characters.count == 2 ? "00" : "0"))
            }
        } else {
            modNewYearString = newYearString
        }

        if let year = Int(modNewYearString) {
            if year >= 1900 && year < (currentYear! - 18) {
                yearString = newYearString
            }
        }

        return String(format:"%@/%@/%@", monthString, dayString, yearString)
    }
}
