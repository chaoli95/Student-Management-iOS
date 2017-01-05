//
//  LoginViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    weak var usernameField : UITextField!
    weak var passwordField : UITextField!
    var userManager = UserManager()
    
    var loginName = "" {
        didSet{
            self.loginButton.isEnabled = ( self.loginName.characters.count > 0 && self.password.characters.count > 0 )
        }
    }
    var password = "" {
        didSet{
            self.loginButton.isEnabled = ( self.loginName.characters.count > 0 && self.password.characters.count > 0 )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.isEnabled = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        print("hello")
        self.loginButton.isEnabled = false
        self.userManager.loginIn(loginname: self.loginName, password: self.password, success: { (code, message) in
            print(code)
            print(message)
            self.loginButton.isEnabled = true
            if code == 200 {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            }) { (error) in
                print(error.localizedDescription)
                self.loginButton.isEnabled = true
        }
    }
    
    @IBAction func unwindToLoginPage(segue: UIStoryboardSegue) {
        
    }
    
    
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource, LoginItemCellTextDelegate, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
        if indexPath.row == 0 {
            // 手机
            //            cell.setLeftIcon(UIImage(named: "account.png"))
            cell.delegate = self
            cell.textField.tag = 0
            cell.textField.delegate = self
            cell.textField.placeholder = "请输入登录名"
            cell.label.text = "登录名："
            //            cell.textField.keyboardType = .PhonePad
            //            cell.textField.returnKeyType = .Next
            cell.textField.returnKeyType = .next
            self.usernameField = cell.textField
//            cell.textField.becomeFirstResponder()
        }else{
            // 密码
            //            cell.setLeftIcon(UIImage(named: "key.png"))
            cell.delegate = self
            cell.textField.tag = 1
            //            cell.textField.delegate = self
            cell.textField.delegate = self
            cell.label.text = "密码："
            cell.textField.placeholder = "请输入密码"
            //            cell.textField.keyboardType = .Default
            cell.textField.returnKeyType = .done
            //            cell.textField.secureTextEntry = true
            cell.textField.isSecureTextEntry = true
            self.passwordField = cell.textField
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func textDidChange(sender textField: UITextField) {
        if textField.tag == 0 {
            textField.text = restrictText(text: textField.text!, length: 15)
            self.loginName = textField.text!
        }else{
            textField.text = restrictText(text: textField.text!, length: 15)
            self.password = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.usernameField {
            self.passwordField.becomeFirstResponder()
        }else{
            self.passwordField.resignFirstResponder()
        }
        return true
    }

    
}
