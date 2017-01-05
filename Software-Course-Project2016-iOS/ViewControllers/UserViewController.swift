//
//  UserViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import Alamofire

class UserViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var alertController: UIAlertController?
    
    let titles = [["修改密码", "我的信息", "我的问题"], ["退出登录"]]
    let teacherTitles = [["修改密码", "我的信息"], ["退出登录"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatarButton.layer.masksToBounds = true
        self.avatarButton.layer.cornerRadius = 33
        self.avatarButton.backgroundColor = UIColor.orange
        
        self.alertController = UIAlertController(title: "请先登录", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        self.alertController?.addAction(cancelAction)
        let doneAction = UIAlertAction(title: "确定", style: .default) { (action) in
            self.performSegue(withIdentifier: "showLogin", sender: nil)
        }
        self.alertController?.addAction(doneAction)

        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userName = UserDefaults.standard.string(forKey: UserNameKey) {
            let startIndex = userName.index(userName.startIndex, offsetBy: 1)
            let firstStr = userName.substring(to: startIndex)
            self.nameLabel.text = firstStr.pinyin
        }
        self.showLoginAlert()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoginAlert() -> Bool {
        if UserDefaults.standard.object(forKey: UserCookieKey) == nil {
            self.present(self.alertController!, animated: true, completion: nil)
            return true
        }
        return false
    }

    @IBAction func avatarButtonPressed(_ sender: AnyObject) {
        if UserDefaults.standard.object(forKey: UserCookieKey) == nil {
            self.performSegue(withIdentifier: "showLogin", sender: nil)
        }
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.integer(forKey: UserIdentityKey) != 1 {
            return self.teacherTitles[section].count
        }
        return self.titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell")
        if UserDefaults.standard.integer(forKey: UserIdentityKey) != 1 {
            cell?.textLabel?.text = teacherTitles[indexPath.section][indexPath.row]
        } else {
            cell?.textLabel?.text = titles[indexPath.section][indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.showLoginAlert() {
            return
        }
        if indexPath.section == 1 {
            UserDefaults.standard.removeObject(forKey: UserNameKey)
            UserDefaults.standard.removeObject(forKey: DefaultClassKey)
            UserDefaults.standard.removeObject(forKey: UserObjectIdKey)
            UserDefaults.standard.removeObject(forKey: UserCookieKey)
            UserDefaults.standard.removeObject(forKey: UserIdentityKey)
            for cookie in Alamofire.SessionManager.default.session.configuration.httpCookieStorage!.cookies! {
                Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.deleteCookie(cookie)
            }
            self.nameLabel.text = ""
            self.tableView.reloadData()
        } else {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "changePwd", sender: nil)
            } else if indexPath.row == 1 {
                self.performSegue(withIdentifier: "showMessage", sender: nil)
            } else {
                self.performSegue(withIdentifier: "showMyQuestion", sender: nil)
            }
        }
    }
}
