//
//  GithubService.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/17.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GithubService: GitHubValidationService{
    let API: GitHubAPI
    static let sharedValidationService = GithubService(API: GitHubDefaultAPI.sharedAPI)
    init (API: GitHubAPI) {
        self.API = API
    }
    
    let minPasswordCount = 5
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty{
            return .just(.empty)
        }
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字或者字母"))
        }
        
        let loadingValue = ValidationResult.validating
        return API.usernameAvailable(username).map { available -> ValidationResult in
            if available{
                return  .ok(message: "用户名有效")
            }else{
                return  .failed(message: "用户名已经存在")
            }
        }.startWith(loadingValue)
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码必须大于 \(minPasswordCount) 个字符")
        }
        return .ok(message: "密码是可用的")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
        if repeatedPassword == password {
            return .ok(message: "密码确认成功")
        }else {
            return .failed(message: "两次密码输入不一致")
        }
    }
}

class GitHubDefaultAPI : GitHubAPI {
    let URLSession: Foundation.URLSession

    static let sharedAPI = GitHubDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )

    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        // this is ofc just mock, but good enough
        
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return self.URLSession.rx.response(request: request)
            .map { pair in
                return pair.response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    func signup(_ username: String, password: String) -> Observable<Bool> {
        // this is also just a mock
        let signupResult = arc4random() % 5 == 0 ? false : true
        
        return Observable.just(signupResult)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}

extension String {
    var URLEscaped: String {
       return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
