//
//  MessageViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/2.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var messages: [Message]?
    var sender: [String: User] = [String: User]()
    var dataLoaded = 0
    var userManager = UserManager()
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadData()
        self.rightBarView.touchEndedBlock { [unowned self] (view) in
            self.performSegue(withIdentifier: "sendMessage", sender: nil)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.integer(forKey: UserIdentityKey) != 1 {
            self.navigationController?.navigationBar.addSubview(self.rightBarView)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UserDefaults.standard.integer(forKey: UserIdentityKey) != 1 {
            self.rightBarView.removeFromSuperview()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadData() {
        self.userManager.getMessage(success: { (code, message, msgs) in
            if code == 200 {
                self.messages = msgs
                self.reloadSender()
            }
            }) { (error) in
                
        }
    }
    
    func reloadSender() {
        for msg in self.messages! {
            self.userManager.selectUserInfo(userId: msg.senderId, success: { (code, message, user) in
                self.sender[msg.senderId] = user
                self.dataLoaded += 1
                if self.dataLoaded == self.messages?.count {
                    self.tableView.reloadData()
                }
                }, failure: { (error) in
                    
            })
        }
    }
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageTableViewCell
        cell.textField.text = self.messages![indexPath.row].content
        let dateFormate = "yyyy年MM月dd日"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormate
        cell.timeLabel.text = dateFormatter.string(from: self.messages![indexPath.row].date)
        let senderId = self.messages![indexPath.row].senderId
        if self.sender[senderId!]!.identity == 0 {
            cell.nameLabel.text = "【管理员】" + (self.sender[senderId!]!.userName)!
        } else if self.sender[senderId!]!.identity == 2 {
            cell.nameLabel.text = "【老师】" + (self.sender[senderId!]!.userName)!
        } else {
            cell.nameLabel.text = (self.sender[senderId!]!.userName)!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
}
