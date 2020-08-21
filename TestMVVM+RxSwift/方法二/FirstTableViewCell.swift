//
//  FirstTableViewCell.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/8.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SayHelloViewModelBindable {
    var bag: DisposeBag {get}
    func bind(to viewModel: SayHelloViewModel2)
}

class FirstTableViewCell: UITableViewCell, SayHelloViewModelBindable{

    @IBOutlet weak var textField: UITextField!
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to viewModel: SayHelloViewModel2){
        textField.rx.text.orEmpty.bind(to: viewModel.input.name).disposed(by: bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class SecondTableViewCell: UITableViewCell,SayHelloViewModelBindable {

    
    @IBOutlet weak var validationButton: UIButton!
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to viewModel: SayHelloViewModel2){
        validationButton.rx.tap.bind(to: viewModel.input.validate).disposed(by: bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class ThirdTableViewCell: UITableViewCell,SayHelloViewModelBindable {

    @IBOutlet weak var resultLabel: UILabel!
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to viewModel: SayHelloViewModel2){
        viewModel.output.greeting.drive(resultLabel.rx.text).disposed(by: bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
