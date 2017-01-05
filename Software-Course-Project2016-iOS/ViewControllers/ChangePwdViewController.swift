//
//  ChangePwdViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class ChangePwdViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    var userManager = UserManager()
    
    var pwd: String = "" {
        didSet {
            self.confirmButton.isEnabled = self.pwd.characters.count>0 && self.newPwd.characters.count>0 && self.verifyPwd.characters.count>0
        }
    }
    var newPwd : String = "" {
        didSet {
            self.confirmButton.isEnabled = self.pwd.characters.count>0 && self.newPwd.characters.count>0 && self.verifyPwd.characters.count>0
        }
    }
    var verifyPwd: String = "" {
        didSet {
            self.confirmButton.isEnabled = self.pwd.characters.count>0 && self.newPwd.characters.count>0 && self.verifyPwd.characters.count>0
        }
    }
    
    weak var pwdTextField: UITextField?
    weak var newPwdTextField: UITextField?
    weak var verifyPwdTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        if newPwd != verifyPwd {
            return
        }
        self.confirmButton.isEnabled = false
        self.userManager.changePassword(oldPwd: self.pwd, newPwd: self.newPwd, success: { (code, message) in
            if code == 200 {
                self.navigationController?.popViewController(animated: true)
            }
            self.confirmButton.isEnabled = true
            }) { (error) in
                
                self.confirmButton.isEnabled = true
        }
    }
    


}

extension ChangePwdViewController: UITableViewDelegate, UITableViewDataSource, LoginItemCellTextDelegate, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
        if indexPath.section == 0 {
            cell.delegate = self
            cell.textField.tag = 0
            cell.textField.delegate = self
            cell.textField.placeholder = "请输入原密码"
            cell.label.text = "原密码："
            cell.textField.returnKeyType = .next
            cell.textField.isSecureTextEntry = true
            self.pwdTextField = cell.textField
        } else {
            if indexPath.row == 0 {
                cell.delegate = self
                cell.textField.tag = 1
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入新密码"
                cell.label.text = "新密码："
                cell.textField.isSecureTextEntry = true
                cell.textField.returnKeyType = .next
                self.newPwdTextField = cell.textField
            } else {
                cell.delegate = self
                cell.textField.tag = 2
                cell.textField.delegate = self
                cell.textField.placeholder = "请再次输入新密码"
                cell.label.text = ""
                cell.textField.returnKeyType = .done
                cell.textField.isSecureTextEntry = true
                self.verifyPwdTextField = cell.textField
            }
        }
        return cell
    }
    
    func textDidChange(sender: UITextField) {
        if sender.tag == 0 {
            self.pwd = sender.text!
        } else if sender.tag == 1 {
            self.newPwd = sender.text!
        } else {
            self.verifyPwd = sender.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.pwdTextField {
            self.newPwdTextField?.becomeFirstResponder()
        } else if textField == self.newPwdTextField {
            self.verifyPwdTextField?.becomeFirstResponder()
        } else {
            self.verifyPwdTextField?.resignFirstResponder()
        }
        return true
    }
    
}
