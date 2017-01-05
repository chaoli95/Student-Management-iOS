//
//  ManageStudentViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/1.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

//protocol ManageStudentDelegate: class {
//    func didAddStudent()
//    func didRemoveStudent()
//}

class ManageStudentViewController: UIViewController {

    var classId: String?
    var classObject: Class?
    var studentDic: [String: User] = [String: User]()
    var dataLoaded = 0;
    var userManager = UserManager()
    var classManager = ClassManager()
//    var delegate: ManageStudentDelegate?
    
    lazy var leftBarView : UIView = {
        let view = UIView(frame: CGRect(x: 16, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.black
        return view
    }()
    
    var alertController: UIAlertController?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertController = UIAlertController(title: "添加学生", message: nil, preferredStyle: .alert)
        alertController?.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "请输入姓名"
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        self.alertController?.addAction(cancelAction)
        let doneAction = UIAlertAction(title: "确定", style: .default) { (action) in
            self.classManager.addstudent(By: self.alertController!.textFields![0].text!, classId: self.classId!, success: { (code, message) in
                print(message)
                if code == 200 {
                    self.reload()
                }
                }, failure: { (error) in
                    
            })
        }
        self.alertController?.addAction(doneAction)
        
        self.leftBarView.touchEndedBlock { [unowned self] (view) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        self.rightBarView.touchEndedBlock { [unowned self] (view) in
            self.present(self.alertController!, animated: true, completion: nil)
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.reload()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(self.leftBarView)
        self.navigationController?.navigationBar.addSubview(self.rightBarView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.leftBarView.removeFromSuperview()
        self.rightBarView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        try! self.classManager.selectClass(success: { (classes) in
            for classObject in classes {
                if classObject.objectId == self.classId {
                    self.classObject = classObject
                    for studentId in classObject.studentId {
                        self.userManager.selectUserInfo(userId: studentId, success: { (code, message, user) in
                            if code == 200 {
                                self.studentDic[studentId] = user
                                self.dataLoaded += 1
                                if self.dataLoaded == (self.classObject?.studentId.count)! {
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                            }, failure: { (error) in
                                
                        })
                    }
                }
            }
            }, failure: { (error) in
                
        })
    }

}

extension ManageStudentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")
        let user = self.studentDic[(self.classObject?.studentId[indexPath.row])!]
        cell?.textLabel?.text = user!.userName
        cell?.detailTextLabel?.text = user!.loginName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = self.studentDic[(self.classObject?.studentId[indexPath.row])!]
            self.classManager.removeStudent(By: user!.loginName, classId: self.classId!, success: { (code, message) in
                if code == 200 {
                    self.classObject?.studentId.remove(at: indexPath.row)
                    self.studentDic.removeValue(forKey: user!.objectId)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                }, failure: { (error) in
                    
            })
        }
    }
    
}
