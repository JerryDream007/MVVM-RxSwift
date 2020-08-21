//
//  SayHelloViewModel.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/8.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var output: Output {get}
}

class SayHelloViewModel: ViewModelType{
    
    struct Input {
        let name: Observable<String>
        let validate: Observable<Void>
    }
        
    struct Output {
        let greeting: Driver<String>
    }
    
    let output: SayHelloViewModel.Output
    
    init(input: SayHelloViewModel.Input) {
        let greeting = input.name.map { (name) in
            if name.count < 5{
                return "请输入正确的姓名"
            }
            return "Hello \(name)"
        }.asDriver(onErrorJustReturn: "error")
        
        self.output = Output(greeting: greeting)
    }
}
