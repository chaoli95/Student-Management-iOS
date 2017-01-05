//
//  AdminTableViewDelegate.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/2.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

class AdminTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?
    weak var viewController : QuestionViewController!
    
    let adminArray = ["删除用户", "重置用户", "查看班级", "发送全体通知"]
    var deleteController: UIAlertController?
    var resetController: UIAlertController?
    var searchController: UIAlertController?
    var userManager = UserManager()
    
    override init() {
        super.init()
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let deleteDone = UIAlertAction(title: "确定", style: .default) { [unowned self] (action) in
            "请稍候".showLoadingHUD()
            self.userManager.deleteUser(By: (self.deleteController?.textFields?[0].text)!, success: { (code, message) in
                if code == 200 {
                    message.showSuccessHUD()
                } else {
                    message.showErrorHUD()
                }
                }, failure: { (error) in
                    "网络连接有问题".showErrorHUD()
            })
        }
        
        self.deleteController = UIAlertController(title: "请输入要删除的用户编号", message: nil, preferredStyle: .alert)
        self.deleteController?.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "请输入学号/编号"
        })
        self.deleteController?.addAction(cancelAction)
        self.deleteController?.addAction(deleteDone)
        
        let resetDone = UIAlertAction(title: "确定", style: .default) { [unowned self] (action) in
            "请稍候".showLoadingHUD()
            self.userManager.resetUser(By: (self.resetController?.textFields?[0].text)!, success: { (code, message) in
                if code == 200 {
                    message.showSuccessHUD()
                } else {
                    message.showErrorHUD()
                }
                }, failure: { (error) in
                    "网络连接有问题".showErrorHUD()
            })
        }
        
        self.resetController = UIAlertController(title: "请输入要重置的用户编号", message: "密码将重置为000000", preferredStyle: .alert)
        self.resetController?.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "请输入学号/编号"
        })
        self.resetController?.addAction(cancelAction)
        self.resetController?.addAction(resetDone)
        
        let searchDone = UIAlertAction(title: "确定", style: .default) { [unowned self] (action) in
            self.viewController.performSegue(withIdentifier: "showSelectionFromAdmin", sender: self.searchController?.textFields?[0].text)
        }
        
        self.searchController = UIAlertController(title: "请输入名称以搜索", message: nil, preferredStyle: .alert)
        self.searchController?.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "请输入班级名称"
        })
        self.searchController?.addAction(cancelAction)
        self.searchController?.addAction(searchDone)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminCell")
        cell?.textLabel?.text = adminArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.viewController.present(self.deleteController!, animated: true, completion: nil)
        case 1:
            self.viewController.present(self.resetController!, animated: true, completion: nil)
        case 2:
            self.viewController.present(self.searchController!, animated: true, completion: nil)
        case 3:
            self.viewController.performSegue(withIdentifier: "addQuestionOrPost", sender: nil)
        default:
            break
        }
    }

}
