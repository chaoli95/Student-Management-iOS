//
//  SignupViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    weak var loginNameTextField: UITextField?
    weak var userNameTextField: UITextField?
    weak var pwdTextField: UITextField?
    weak var verifyPwdTextField: UITextField?
    weak var identityLabel: UILabel?
    
    weak var questionOneTextField: UITextField?
    weak var answerOneTextField: UITextField?
    weak var questionTwoTextField: UITextField?
    weak var answerTwoTextField: UITextField?
    weak var questionThreeTextField: UITextField?
    weak var answerThreeTextField: UITextField?
    
    var loginName = "" {
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var userName = "" {
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var pwd = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var verifyPwd = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var questionOne = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var answerOne = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var questionTwo = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var answerTwo = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var questionThree = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var answerThree = ""{
        didSet {
            self.signupButton.isEnabled = loginName != "" && self.userName != "" && self.pwd != "" && self.verifyPwd != "" && self.questionOne != "" && self.questionTwo != "" && self.questionThree != "" && self.answerOne != "" && self.answerTwo != "" && self.answerThree != ""
        }
    }
    var identity = 1
    
    var index = IndexPath.init(row: 0, section: 0)
    var userManager = UserManager()
    
    let identityString = ["学生", "老师"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signupButton.isEnabled = false
  
        self.hidePickerView()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignupViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func doneToorBarButtonPressed(_ sender: AnyObject) {
        self.hidePickerView()
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        if self.pwd != self.verifyPwd {
            return
        }
        print("hello again")
        self.signupButton.isEnabled = false
        let user = User()
        user.loginName = self.loginName
        user.userName = self.userName
        user.password = self.pwd
        user.questionOne = self.questionOne
        user.questionTwo = self.questionTwo
        user.questionThree = self.questionThree
        user.answerOne = self.answerOne
        user.answerTwo = self.answerTwo
        user.answerThree = self.answerThree
        user.identity = self.identity
        self.userManager.siguUp(user: user, success: { (code, message) in
            print(code)
            print(message)
            if code == 200 {
                self.navigationController?.popViewController(animated: true)
            }
            }) { (error) in
                print(error.localizedDescription)
        }
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
    
    func showPickerView() {
        self.toolBar.isHidden = false
        self.pickerView.isHidden = false
    }
    
    func hidePickerView() {
        self.toolBar.isHidden = true
        self.pickerView.isHidden = true
    }

}

extension SignupViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoginItemCellTextDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.endEditing(true)
        self.hidePickerView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
                cell.delegate = self
                cell.textField.tag = 0
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入登录名"
                cell.label.text = "登录名："
                cell.textField.returnKeyType = .next
                self.loginNameTextField = cell.textField
                cell.textField.isSecureTextEntry = false
                cell.textField.text = self.loginName
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
                cell.delegate = self
                cell.textField.tag = 1
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入用户名"
                cell.label.text = "用户名："
                cell.textField.returnKeyType = .next
                self.userNameTextField = cell.textField
                cell.textField.isSecureTextEntry = false
                cell.textField.text = self.userName
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
                cell.delegate = self
                cell.textField.tag = 2
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入密码"
                cell.label.text = "密 码："
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = true
                self.pwdTextField = cell.textField
                cell.textField.text = self.pwd
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
                cell.delegate = self
                cell.textField.tag = 3
                cell.textField.delegate = self
                cell.textField.placeholder = "请再次输入密码"
                cell.label.text = ""
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = true
                self.verifyPwdTextField = cell.textField
                cell.textField.text = self.verifyPwd
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as! LoginPickerTableViewCell
                cell.typeLabel.text = "身 份:"
                cell.identityLabel?.text = self.identityString[self.identity-1]
                self.identityLabel = cell.identityLabel
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
            switch indexPath.row {
            case 0:
                cell.delegate = self
                cell.textField.tag = 4
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入问题一"
                cell.label.text = "验证问题一"
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = false
                self.questionOneTextField = cell.textField
                cell.textField.text = self.questionOne
            case 1:
                cell.delegate = self
                cell.textField.tag = 5
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入答案一"
                cell.label.text = "验证答案一"
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = false
                self.answerOneTextField = cell.textField
                cell.textField.text = self.answerOne
            case 2:
                cell.delegate = self
                cell.textField.tag = 6
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入问题二"
                cell.label.text = "验证问题二"
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = false
                self.questionTwoTextField = cell.textField
                cell.textField.text = self.questionTwo
            case 3:
                cell.delegate = self
                cell.textField.tag = 7
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入答案二"
                cell.label.text = "验证答案二"
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = false
                self.answerTwoTextField = cell.textField
                cell.textField.text = self.answerTwo
            case 4:
                cell.delegate = self
                cell.textField.tag = 8
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入问题三"
                cell.label.text = "验证问题三"
                cell.textField.returnKeyType = .next
                cell.textField.isSecureTextEntry = false
                self.questionThreeTextField = cell.textField
                cell.textField.text = self.questionThree
            case 5:
                cell.delegate = self
                cell.textField.tag = 9
                cell.textField.delegate = self
                cell.textField.placeholder = "请输入答案三"
                cell.label.text = "验证答案三"
                cell.textField.returnKeyType = .done
                cell.textField.isSecureTextEntry = false
                self.answerThreeTextField = cell.textField
                cell.textField.text = self.answerThree
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 4 {
            self.showPickerView()
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func textDidChange(sender textField: UITextField) {
        if textField.tag == 0 {
            textField.text = restrictText(text: textField.text!, length: 15)
            self.loginName = textField.text!
        } else if textField.tag == 1 {
            textField.text = restrictText(text: textField.text!, length: 15)
            self.userName = textField.text!
        } else if textField.tag == 2 {
            textField.text = restrictText(text: textField.text!, length: 15)
            self.pwd = textField.text!
        } else if textField.tag == 3 {
            textField.text = restrictText(text: textField.text!, length: 15)
            self.verifyPwd = textField.text!
        } else if textField.tag == 4 {
            textField.text = restrictText(text: textField.text!, length: 20)
            self.questionOne = textField.text!
        } else if textField.tag == 5 {
            textField.text = restrictText(text: textField.text!, length: 20)
            self.answerOne = textField.text!
        } else if textField.tag == 6 {
            textField.text = restrictText(text: textField.text!, length: 20)
            self.questionTwo = textField.text!
        } else if textField.tag == 7 {
            textField.text = restrictText(text: textField.text!, length: 20)
            self.answerTwo = textField.text!
        } else if textField.tag == 8 {
            textField.text = restrictText(text: textField.text!, length: 20)
            self.questionThree = textField.text!
        } else if textField.tag == 9 {
            textField.text = restrictText(text: textField.text!, length: 20)
            self.answerThree = textField.text!
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.loginNameTextField {
            index = IndexPath.init(row: 0, section: 0)
        } else if textField == self.userNameTextField {
            index = IndexPath.init(row: 1, section: 0)
        } else if textField == self.pwdTextField {
            index = IndexPath.init(row: 2, section: 0)
        } else if textField == self.verifyPwdTextField {
            index = IndexPath.init(row: 3, section: 0)
        } else if textField == self.questionOneTextField {
            index = IndexPath.init(row: 0, section: 1)
        } else if textField == self.answerOneTextField {
            index = IndexPath.init(row: 1, section: 1)
        } else if textField == self.questionTwoTextField {
            index = IndexPath.init(row: 2, section: 1)
        } else if textField == self.answerTwoTextField {
            index = IndexPath.init(row: 3, section: 1)
        } else if textField == self.questionThreeTextField {
            index = IndexPath.init(row: 4, section: 1)
        } else if textField == self.answerThreeTextField {
            index = IndexPath.init(row: 5, section: 1)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginNameTextField {
            self.userNameTextField!.becomeFirstResponder()
        } else if textField == self.userNameTextField {
            self.pwdTextField?.becomeFirstResponder()
        } else if textField == self.pwdTextField {
            self.verifyPwdTextField?.becomeFirstResponder()
        } else if textField == self.verifyPwdTextField {
            self.verifyPwdTextField?.resignFirstResponder()
            self.showPickerView()
        } else if textField == self.questionOneTextField {
            self.answerOneTextField?.becomeFirstResponder()
        } else if textField == self.answerOneTextField {
            self.questionTwoTextField?.becomeFirstResponder()
        } else if textField == self.questionTwoTextField {
            self.answerTwoTextField?.becomeFirstResponder()
        } else if textField == self.answerTwoTextField {
            self.questionThreeTextField?.becomeFirstResponder()
        } else if textField == self.questionThreeTextField {
            self.answerThreeTextField?.becomeFirstResponder()
        } else if textField == self.answerThreeTextField {
            self.answerThreeTextField?.resignFirstResponder()
        }
        return true
    }
}

extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.identityString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.identityString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.identity = row+1
        self.identityLabel?.text = identityString[row]
    }
    
}
