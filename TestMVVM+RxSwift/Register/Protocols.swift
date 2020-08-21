//
//  Protocols.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/12.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ValidationResult{
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

enum SignupState{
    case signedUp(signedUp: Bool)
}

enum RetryResult{
    case retry
    case cancel
}

protocol GitHubAPI{
    func usernameAvailable(_ username: String) -> Observable<Bool>
    func signup(_ username: String,  password: String) -> Observable<Bool>
}

protocol GitHubValidationService{
    func validateUsername(_ username: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

extension ValidationResult{
    var isValid: Bool{
        switch self{
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case .validating:
            return "validating ..."
        case let .failed(message):
            return message
        }
    }
}

extension RetryResult: CustomStringConvertible{
    var description: String{
        switch self{
        case .retry:
            return "Retry"
        case .cancel:
            return "Cancel"
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    static let errorColor = UIColor.red
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return ValidationColors.errorColor
        }
    }
}

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
