//
//  SendMessageViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/2.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

class SendMessageViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginNameTextField: MultilineTextField!
    @IBOutlet weak var contentTextField: MultilineTextField!
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.red
        return view
    }()
    
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rightBarView.touchEndedBlock { [unowned self] (view) in
            if self.loginNameTextField.text.characters.count == 0 || self.contentTextField.text.characters.count == 0 {
                return
            }
            self.userManager.sendMessage(studentName: self.loginNameTextField.text, content: self.contentTextField.text, success: { (code, message) in
                if code == 200 {
                    self.navigationController?.popViewController(animated: true)
                }
                }, failure: { (error) in
                    
            })
        }

        NotificationCenter.default.addObserver(self, selector: #selector(SendMessageViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SendMessageViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
