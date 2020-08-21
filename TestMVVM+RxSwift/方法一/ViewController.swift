//
//  ViewController.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/8.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var validationButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var viewModel:  SayHelloViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputs = SayHelloViewModel.Input(name: textField.rx.text.orEmpty.asObservable() , validate: validationButton.rx.tap.asObservable())
        viewModel = SayHelloViewModel(input: inputs)
        bindViewModel()
    }

    func bindViewModel(){
        viewModel?.output
            .greeting.drive(resultLabel.rx.text).disposed(by: disposeBag)
    }
}

