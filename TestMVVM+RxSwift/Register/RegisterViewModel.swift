//
//  LoginViewModel.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/11.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelProcol {
    associatedtype Input
    associatedtype Output
    var output: Output { get }
}

class RegisterViewModel{
    
    var output: Output
    
    struct Input{
        var username: Observable<String>
        let password: Observable<String>
        let repeatedPassword: Observable<String>
        let signupTaps: Observable<Void>
    }
    
    struct Output{
        let usernameValid: Observable<ValidationResult>
        let passwordValid: Observable<ValidationResult>
        let repeatedPasswordValid: Observable<ValidationResult>
        let signupEnable: Observable<Bool>                          //注册是否可点击
        let tapedSignIn: Observable<ValidationResult>               //点击了注册
    }
    
    struct Dependency{
        let API: GitHubAPI
        let validationService: GitHubValidationService
        let wireframe: Wrieframe
    }
    
    init(input: Input, dependency: Dependency){
        let usernameValid =  input.username.flatMapLatest { username -> Observable<ValidationResult> in
            return dependency.validationService.validateUsername(username).observeOn(MainScheduler.instance).catchErrorJustReturn(ValidationResult.failed(message: "连接服务器错误"))
        }.share(replay: 1)
        
        let passwordValid = input.password.map { (password) -> ValidationResult in
            return dependency.validationService.validatePassword(password)
        }.share(replay: 1)
        
        let repeatedPasswordValid = Observable.combineLatest(input.password, input.repeatedPassword) { (password,repeatedPassword) -> ValidationResult in
            return dependency.validationService.validateRepeatedPassword(password, repeatedPassword: repeatedPassword)
        }.share(replay: 1)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password){ (username,password) -> (String,String) in
            return (username: username, password: password)
        }
                
        let tapedSignIn = input.signupTaps.withLatestFrom(usernameAndPassword).flatMapLatest { (arg) -> Observable<Bool> in
            
            let (username, password) = arg
            return dependency.API.signup(username, password: password).map{ (flag) in
                return flag
            }
        }.flatMap { (isSuccess) -> Observable<ValidationResult> in
            let result = isSuccess ? ValidationResult.ok(message: "注册成功") : ValidationResult.failed(message: "注册失败")
            return dependency.wireframe.promptFor("注册结果", result.description , cancelAction: "OK", actions: []).map { _ in
                return result
            }.observeOn(MainScheduler.instance).catchErrorJustReturn(.failed(message: ""))
        }
        
        let signupEnable = Observable.combineLatest(usernameValid, passwordValid, repeatedPasswordValid) { (username,password,repeatPassword) -> Bool in
            return username.isValid && password.isValid && repeatPassword.isValid
        }.startWith(false)
        
        
        self.output = Output(usernameValid: usernameValid, passwordValid: passwordValid, repeatedPasswordValid: repeatedPasswordValid, signupEnable: signupEnable, tapedSignIn: tapedSignIn)
    }
    
}
