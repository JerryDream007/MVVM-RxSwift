//
//  LoginViewController.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/11.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userTipLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTipLabel: UILabel!
    
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var confirmTipLabel: UILabel!
    
    @IBOutlet weak var registeredButton: UIButton!
    
    var viewModel: RegisterViewModel?
    let bag =  DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernameObservable = userTextField.rx.text.orEmpty.asObservable()
        let passwordObservable = passwordTextField.rx.text.orEmpty.asObservable()
        let confirmObservable = confirmTextField.rx.text.orEmpty.asObservable()
        let signupObservable = registeredButton.rx.tap.asObservable()

        let input = RegisterViewModel.Input(
            username: usernameObservable,
            password: passwordObservable,
            repeatedPassword: confirmObservable,
            signupTaps: signupObservable)

        let dependency = RegisterViewModel.Dependency(
            API: GithubService.sharedValidationService.API,
            validationService: GithubService.sharedValidationService,
            wireframe: DefaultWireframe.shared)

        viewModel = RegisterViewModel(input: input, dependency: dependency)
//        viewModel?.output.signupEnable.subscribe(onNext: { [weak self] (valid) in
//            self?.registeredButton.isEnabled = valid
//            self?.registeredButton.alpha = valid ? 1.0 : 0.5
//        }).disposed(by: bag)

        viewModel?.output.usernameValid.bind(to: userTipLabel.rx.validationResult).disposed(by: bag)
        viewModel?.output.passwordValid.bind(to: passwordTipLabel.rx.validationResult).disposed(by: bag)
        viewModel?.output.repeatedPasswordValid.bind(to: confirmTipLabel.rx.validationResult).disposed(by: bag)
        viewModel?.output.tapedSignIn.subscribe(onNext: { (result) in
            print("result = \(result.description)")
        }).disposed(by: bag)
        
        
        let second = GithubService.sharedValidationService.API.usernameAvailable("123456song123")
        let registerObservable = Observable.combineLatest(registeredButton.rx.tap, second).flatMap { (_,isValidate) -> Observable<Result<String,Error>> in
            if isValidate{
                print("用户名有效")
                return GithubService.sharedValidationService.API.signup("123", password: "123456").map { (isSuccess) -> Result<String,Error> in
                    return isSuccess ? Result.success("注册成功") : Result.failure(SampleError())
                }.catchError { (error) -> Observable<Result<String, Error>> in
                    Observable.just(Result.failure(error))
                }
            }else{
                print("用户名无效")
                return Observable.just(Result<String,Error>.failure(SampleError()))
            }
        }
        registerObservable.subscribe(onNext: { (result) in
            switch result{
            case .success(let string):
                print("注册成功，没有异常-\(string)")
            case .failure(let error):
                print("注册失败，出现异常了 = \(error)")
            }
        }, onError: { (error) in
            
        }).disposed(by: bag)    
    }
    
    
    @IBAction func onClickRegisterButton(_ sender: Any) {
        print("点击了RegisterButton")
    }
}


class SampleError: Error{
    
}
