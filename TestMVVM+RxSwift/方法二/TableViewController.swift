//
//  TableViewController.swift
//  TestMVVM+RxSwift
//
//  Created by 宋澎 on 2020/8/8.
//  Copyright © 2020 宋澎. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let CellIDs = ["FirstCell","ThirdCell","SecondCell"]
    let viewModel = SayHelloViewModel2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellIDs.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: CellIDs[indexPath.row], for: indexPath)
        (cell as? SayHelloViewModelBindable)?.bind(to: viewModel)
        return cell
    }
}
