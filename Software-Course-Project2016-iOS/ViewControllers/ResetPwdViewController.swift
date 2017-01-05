//
//  ResetPwdViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class ResetPwdViewController: UIViewController {
    
    var loginName: String?
    var questionArray: [String]?
    var answerArray = ["", "", ""] {
        didSet {
            self.confirmButton.isEnabled = answerArray[0].characters.count > 0 && answerArray[1].characters.count > 0 && answerArray[2].characters.count > 0 && self.pwd.characters.count > 0 && self.verifyPwd.characters.count > 0
        }
    }
    weak var answerOneTextField: UITextField?
    weak var answerTwoTextField: UITextField?
    weak var answerThreeTextField: UITextField?
    weak var pwdTextField: UITextField?
    weak var verifyPwdTextField: UITextField?
    @IBOutlet weak var confirmButton: UIButton!
    var userManager = UserManager()
    
    var pwd = "" {
        didSet {
            self.confirmButton.isEnabled = answerArray[0].characters.count > 0 && answerArray[1].characters.count > 0 && answerArray[2].characters.count > 0 && self.pwd.characters.count > 0 && self.verifyPwd.characters.count > 0
        }
    }
    var verifyPwd = "" {
        didSet {
            self.confirmButton.isEnabled = answerArray[0].characters.count > 0 && answerArray[1].characters.count > 0 && answerArray[2].characters.count > 0 && self.pwd.characters.count > 0 && self.verifyPwd.characters.count > 0
        }
    }
    
    var index = IndexPath.init(row: 0, section: 0)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.confirmButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let frame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let height = frame.cgRectValue.height
        self.bottomConstant.constant = height - 88
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.tableView.scrollToRow(at: self.index, at: .top, animated: false)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.bottomConstant.constant = 20
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        if self.pwd != self.verifyPwd {
            return
        }
        self.userManager.findPasswordBy(answers: self.answerArray, loginName: self.loginName!, pwd: self.pwd, success: { (code, message) in
            if code == 200 {
                self.performSegue(withIdentifier: "unwindToLoginVC", sender: nil)
            }
            }) { (error) in
                
        }
    }

}

extension ResetPwdViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, LoginItemCellTextDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as! LoginPickerTableViewCell
                cell.typeLabel.text = "验证问题一:"
                cell.identityLabel?.text = self.questionArray?[0]
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
                cell.delegate = self
                cell.textField.tag = 0
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入答案一"
                cell.label.text = "验证答案一"
                cell.textField.returnKeyType = .next
                self.answerOneTextField = cell.textField
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as! LoginPickerTableViewCell
                cell.typeLabel.text = "验证问题二:"
                cell.identityLabel?.text = self.questionArray?[1]
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
                cell.delegate = self
                cell.textField.tag = 1
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入答案二"
                cell.label.text = "验证答案二"
                cell.textField.returnKeyType = .next
                self.answerTwoTextField = cell.textField
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as! LoginPickerTableViewCell
                cell.typeLabel.text = "验证问题三:"
                cell.identityLabel?.text = self.questionArray?[2]
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
                cell.delegate = self
                cell.textField.tag = 2
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入答案三"
                cell.label.text = "验证答案三"
                cell.textField.returnKeyType = .next
                self.answerThreeTextField = cell.textField
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
            if indexPath.row == 0 {
                cell.delegate = self
                cell.textField.tag = 3
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入密码"
                cell.label.text = "新密码"
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = true
                self.pwdTextField = cell.textField
            } else {
                cell.delegate = self
                cell.textField.tag = 4
                cell.textField.delegate = self
                cell.textField.placeholder = "请再次输入密码"
                cell.label.text = ""
                cell.textField.returnKeyType = .done
                cell.textField.isSecureTextEntry = true
                self.verifyPwdTextField = cell.textField
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func textDidChange(sender: UITextField) {
        if sender.tag <= 2 {
            self.answerArray[sender.tag] = sender.text!
        } else if sender.tag == 3 {
            self.pwd = sender.text!
        } else {
            self.verifyPwd = sender.text!
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.answerOneTextField {
            self.index = IndexPath.init(row: 1, section: 0)
        } else if textField == self.answerTwoTextField {
            self.index = IndexPath.init(row: 3, section: 0)
        } else if textField == self.answerThreeTextField {
            self.index = IndexPath.init(row: 5, section: 0)
        } else if textField == self.pwdTextField {
            self.index = IndexPath.init(row: 0, section: 1)
        } else {
            self.index = IndexPath.init(row: 1, section: 1)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.answerOneTextField {
            self.answerTwoTextField?.becomeFirstResponder()
        } else if textField == self.answerTwoTextField {
            self.answerThreeTextField?.becomeFirstResponder()
        } else if textField == self.answerThreeTextField {
            self.pwdTextField?.becomeFirstResponder()
        } else if textField == self.pwdTextField {
            self.verifyPwdTextField?.becomeFirstResponder()
        } else {
            self.verifyPwdTextField?.resignFirstResponder()
        }
        return true
    }
    
}
