//
//  ClassDetailViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/3.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

class ClassDetailViewController: UIViewController {

    var classObject: Class?
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var degreeView: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    var userManager = UserManager()
    var date = Date.init()
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadData()
        
        self.rightBarView.touchEndedBlock { [unowned self] (view) in
//            self.userManager.remindTeacher(By self.classObject.objectId, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure)
            self.userManager.remindTeacher(By: self.classObject?.objectId, success: { (code, message) in
                if code == 200 {
                    message.showSuccessHUD()
                } else {
                    message.showErrorHUD()
                }
                }, failure: { (error) in
                    "网络连接有问题".showErrorHUD()
            })
        }
        
        self.datePickerView.datePickerMode = .date
        self.datePickerView.addTarget(self, action: #selector(ClassDetailViewController.datePickerChanged(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(self.rightBarView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.rightBarView.removeFromSuperview()
    }
    
    func reloadData() {
        "请稍候".showLoadingHUD()
        self.userManager.checkData(classId: (self.classObject?.objectId)!, date: self.date.str, success: { (code, message, questionCount, solvedCount) in
            if code == 200 {
                SVProgressHUD.dismiss()
                self.numLabel.text = "当日答题总数：" + String(describing: questionCount!)
                let percent: Double
                if solvedCount == 0 {
                    percent = 0
                } else {
                    percent = Double(solvedCount!)/Double(questionCount!)
                }
                self.percentLabel.text = "答题率：" + String(percent*100) + "%"
                self.widthConstraint.constant = self.view.width*0.8*CGFloat(percent)+5
                if percent > 0.75 {
                    self.degreeView.backgroundColor = UIColor.green
                } else if percent > 0.5 {
                    self.degreeView.backgroundColor = UIColor.yellow
                } else if percent > 0.25 {
                    self.degreeView.backgroundColor = UIColor.orange
                } else {
                    self.degreeView.backgroundColor = UIColor.red
                }
            } else {
                message?.showErrorHUD()
                self.numLabel.text = "当日答题总数：0"
                self.percentLabel.text = "答题率：0.0%"
                self.degreeView.backgroundColor = UIColor.green
                self.widthConstraint.constant = self.view.width*0.8+5
            }
            UIView.animate(withDuration: 0.2, animations: { 
                self.view.layoutIfNeeded()
            })
            }) { (error) in
                "网络连接有问题".showErrorHUD()
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        print(sender.date)
        self.date = sender.date
        self.reloadData()
    }

}

extension Date {
    
    var str: String {
        get {
            let dateFormatter = DateFormatter()
            let dateFormate = "yyyy-MM-dd"
            dateFormatter.dateFormat = dateFormate
            return dateFormatter.string(from: self)
        }
    }
}
