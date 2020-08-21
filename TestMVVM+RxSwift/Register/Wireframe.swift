//
//  Wireframe.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/12.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol Wrieframe{
    func promptFor<Action: CustomStringConvertible>(_ title: String, _ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

class DefaultWireframe: Wrieframe{
    static let shared = DefaultWireframe()
    
    private static func rootViewController() -> UIViewController {
        // cheating, I know
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    func promptFor<Action>(_ title: String, _ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> where Action : CustomStringConvertible {
        return Observable.create { (observer) -> Disposable in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: cancelAction.description, style: .cancel, handler: { (_) in
                observer.on(.next(cancelAction))
            }))
            for action in actions{
                alertVC.addAction(UIAlertAction(title: action.description, style: .default, handler: { (_) in
                    observer.on(.next(action))
                }))
            }
            
            DefaultWireframe.rootViewController().present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                alertVC.dismiss(animated: false, completion: nil)
            }
        }
    }
}
