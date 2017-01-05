//
//  QuestionTableViewDataSource.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/30.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

protocol QuestionTableViewDataSource: UITableViewDataSource {

    var tableView : UITableView? { get set }
    weak var viewController : QuestionViewController! { get set }
    func reloadData(success: SimpleClosure?, failure: SimpleClosure?)
    func clearData();
}
