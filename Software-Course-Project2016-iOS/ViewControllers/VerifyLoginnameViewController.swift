//
//  VerifyLoginnameViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class VerifyLoginnameViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    weak var loginNameTextField: UITextField?
    var loginName = "" {
        didSet {
            self.confirmButton.isEnabled = loginName.characters.count > 0
        }
    }
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResetPwdVC" {
            let dest = segue.destination as! ResetPwdViewController
            dest.questionArray = sender as? [String]
            dest.loginName = self.loginName
        }
    }

    @IBAction func confirmButtonPressed(_ sender: AnyObject) {
        self.confirmButton.isEnabled = false
        self.userManager.getVerifyQuestionBy(loginName: self.loginName, success: { (code, message, questions) in
            self.confirmButton.isEnabled = true
            print(message)
            if code == 200 {
                self.performSegue(withIdentifier: "showResetPwdVC", sender: questions)
            }
            }) { (error) in
                self.confirmButton.isEnabled = true
        }
    }

}

extension VerifyLoginnameViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LoginItemCellTextDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loginCell") as! LoginItemTableViewCell
        cell.delegate = self
        cell.textField.delegate = self
        cell.textField.placeholder = "请输入登录名"
        cell.label.text = "登录名："
        cell.textField.returnKeyType = .done
        self.loginNameTextField = cell.textField
        return cell
    }
    
    func textDidChange(sender: UITextField) {
        sender.text = restrictText(text: sender.text!, length: 15)
        self.loginName = sender.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
