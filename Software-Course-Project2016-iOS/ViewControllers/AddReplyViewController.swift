//
//  AddReplyViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/1.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

enum AddType: Int {
    case addReply
    case addQuestion
    case addPost
    case addBroadcast
}

class AddReplyViewController: UIViewController {

    @IBOutlet weak var replyTextField: MultilineTextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var questionId: String?
    var classId: String?
    var classManager = ClassManager()
    var userManager = UserManager()
    var type: AddType?
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.red
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.addSubview(rightBarView)
        rightBarView.touchEndedBlock { [unowned self] (view) in
            if self.replyTextField.text.characters.count == 0 {
                return
            }
            "请稍候".showLoadingHUD()
            if self.type == .addReply {
                try! self.classManager.addReply(questionId: self.questionId!, replyContent: self.replyTextField.text, success: { (code, message) in
                    if code == 200 {
                        message.showSuccessHUD()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        message.showErrorHUD()
                    }
                    }, failure: { (error) in
                        "网络连接有问题".showErrorHUD()
                })
            } else if self.type == .addQuestion {
                try! self.classManager.addQuestion(by: self.classId!, questionContent: self.replyTextField.text, success: { (code, message) in
                    if code == 200 {
                        message.showSuccessHUD()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        message.showErrorHUD()
                    }
                    }, failure: { (error) in
                        "网络连接有问题".showErrorHUD()
                })
                
            } else if self.type == .addPost {
                try! self.classManager.addPost(by: self.classId!, post: self.replyTextField.text, success: { (code, message) in
                    if code == 200 {
                        message.showSuccessHUD()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        message.showErrorHUD()
                    }
                    }, failure: { (error) in
                        "网络连接有问题".showErrorHUD()
                })
            } else if self.type == .addBroadcast {
                self.userManager.broadcast(content: self.replyTextField.text, success: { (code, message) in
                    if code == 200 {
                        message.showSuccessHUD()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        message.showErrorHUD()
                    }
                    }, failure: { (error) in
                        "网络连接有问题".showErrorHUD()
                })
            }
            
        }

        NotificationCenter.default.addObserver(self, selector: #selector(AddReplyViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddReplyViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(self.rightBarView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.rightBarView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let frame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let height = frame.cgRectValue.height
        self.bottomConstraint.constant = height
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
//            self.tableView.scrollToRow(at: self.index, at: .top, animated: false)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
//            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
    }

}
