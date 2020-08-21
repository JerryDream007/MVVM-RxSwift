//
//  SayHelloViewModel2.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/8.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelType2 {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}

class SayHelloViewModel2: ViewModelType2{
    let input: Input
    let output: Output
    
    struct Input {
        let name: AnyObserver<String>
        let validate: AnyObserver<Void>
    }
    struct Output {
        let greeting: Driver<String>
    }
    
    private let nameSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let validateSubject = PublishSubject<Void>()
    
    init() {
        let greeting = validateSubject.withLatestFrom(nameSubject).map { name in
            if name.count <= 5{
                return "用户名不能小于5"
            }
            return "Hello \(name)"
        }.asDriver(onErrorJustReturn: "error")
        
        self.output = Output(greeting: greeting)
        self.input = Input(name: nameSubject.asObserver(), validate: validateSubject.asObserver())
    }
}
