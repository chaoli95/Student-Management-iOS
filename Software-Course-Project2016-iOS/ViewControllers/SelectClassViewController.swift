//
//  SelectClassViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/31.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

enum SelectVCType: Int {
    case normal
    case admin
}

protocol SelectClassVCDelegate: class {
    func didSelect(classObject: Class) -> Void
}

class SelectClassViewController: UIViewController {

    var className: String?
    var type: SelectVCType?
    var classes: [Class]?
    @IBOutlet weak var tableView: UITableView!
    var classManager = ClassManager()
    weak var delegate: SelectClassVCDelegate?
    var alertController: UIAlertController?
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))
        view.backgroundColor = UIColor.green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alertController = UIAlertController(title: "添加班级", message: "输入班级名称", preferredStyle: .alert)
        self.alertController?.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "班级名称"
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
//            self.alertController?.dismiss(animated: true, completion: nil)
        }
        let doneAction = UIAlertAction(title: "确定", style: .default) { (action) in
//            self.alertController?.dismiss(animated: true, completion: {
//            })
            try! self.classManager.addClass(by: self.alertController!.textFields![0].text!, success: { (code, message) in
                if code == 200 {
                    self.reloadData()
                }
                }, failure: { (error) in
                    
            })
        }
        self.alertController?.addAction(cancelAction)
        self.alertController?.addAction(doneAction)
        
        self.rightBarView.touchEndedBlock { [unowned self] (view) in
            self.present(self.alertController!, animated: true, completion: { 
                
            })
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadData()
        
        if UserDefaults.standard.integer(forKey: UserIdentityKey) == 2 {
            self.navigationController?.navigationBar.addSubview(self.rightBarView)
        }
    }
    
    func reloadData() {
        if self.type == .normal {
            do {
                "加载中".showLoadingHUD()
                try self.classManager.selectClass(success: { (classes) in
                    self.classes = classes
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    }, failure: { (error) in
                        print(error.localizedDescription)
                        "网络连接有问题".showErrorHUD()
                })
            } catch {
                 SVProgressHUD.dismiss()
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        } else if self.type == .admin {
            "加载中".showLoadingHUD()
            self.classManager.searchClass(By: self.className!, success: { (classes) in
                self.classes = classes
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                }, failure: { (error) in
                    print(error.localizedDescription)
                    "网络连接有问题".showErrorHUD()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UserDefaults.standard.integer(forKey: UserIdentityKey) == 2 {
            self.rightBarView.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClassDetail" {
            let dest = segue.destination as! ClassDetailViewController
            dest.classObject = sender as! Class
        }
    }
}

extension SelectClassViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell")
        cell!.textLabel?.text = classes?[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.type == .normal {
            UserDefaults.standard.set(self.classes![indexPath.row].objectId, forKey: DefaultClassKey)
            self.performSegue(withIdentifier: "unwindToQuestionVC", sender: nil)
            self.delegate?.didSelect(classObject: self.classes![indexPath.row])
        } else if self.type == .admin {
            self.performSegue(withIdentifier: "showClassDetail", sender: self.classes?[indexPath.row])
        }
    }
}
