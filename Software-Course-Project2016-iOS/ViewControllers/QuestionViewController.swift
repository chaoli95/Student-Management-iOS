//
//  QuestionViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secondTableView: UITableView!
//    @IBOutlet weak var secondTableView: UITableView!
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableNavigator: SlideTableViewNavigator!
    @IBOutlet weak var adminTableView: UITableView!
    
    var dataSources: [QuestionTableViewDataSource] = [
        QuestionDataSource(),
        PostDataSource()
    ]
    
    var adminDataSource = AdminTableViewDelegate()
    
    var questions: [Question]? {
        get {
            let dataSource = self.dataSources[0] as! QuestionDataSource
            return dataSource.questions
        }
    }
    
//    var classId: String?
    
    var posts: [Post]? {
        get {
            let dataSource = self.dataSources[1] as! PostDataSource
            return dataSource.posts
        }
    }
    
    var isAdmin: Bool {
        return UserDefaults.standard.integer(forKey: UserIdentityKey) == 0
    }
    
    lazy var leftBarView : UIView = {
        let view = UIView(frame: CGRect(x: 16, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.red
        return view
    }()
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.red
        return view
    }()
    
    var alertController: UIAlertController?
    var selectClassAlertController: UIAlertController?
    var loginAlertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.addSubview(self.leftBarView)
        self.navigationController?.navigationBar.addSubview(self.rightBarView)
    
        self.leftBarView.isHidden = true
        self.rightBarView.isHidden = true
        
        self.alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
//            self.alertController?.dismiss(animated: true, completion: nil)
        })
        self.alertController?.addAction(cancelAction)
        let addPostAction = UIAlertAction(title: "发布通知", style: .default) { (action) in
                self.performSegue(withIdentifier: "addQuestionOrPost", sender: nil)
        }
        self.alertController?.addAction(addPostAction)
        let manageStudentAction = UIAlertAction(title: "管理学生", style: .default) { (action) in
//            self.alertController?.dismiss(animated: true, completion: {
//                DispatchQueue.main.async {
                self.performSegue(withIdentifier: "manageStudent", sender: nil)
//                }
//            })
        }
        self.alertController?.addAction(manageStudentAction)
        
        self.selectClassAlertController = UIAlertController(title: "未选择班级", message: "请先选择班级", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            //            self.alertController?.dismiss(animated: true, completion: nil)
        })
        let addPost = UIAlertAction(title: "确定", style: .default) { (action) in
            self.performSegue(withIdentifier: "selectClassVC", sender: nil)
        }
        self.selectClassAlertController?.addAction(cancel)
        self.selectClassAlertController?.addAction(addPost)
        
        self.loginAlertController = UIAlertController(title: "请先登录", message: nil, preferredStyle: .alert)
        let loginCalcel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        self.loginAlertController?.addAction(loginCalcel)
        let loginDone = UIAlertAction(title: "确定", style: .default) { (action) in
            self.performSegue(withIdentifier: "showLoginFromMain", sender: nil)
        }
        self.loginAlertController?.addAction(loginDone)
        
        self.tableNavigator.titles = ["问 题", "班级通知"]
        self.tableNavigator.delegate = self
        
        self.scrollView.delegate = self
        
        self.tableView.delegate = self
        self.secondTableView.delegate = self
        
        self.adminDataSource.tableView = self.adminTableView
        self.adminDataSource.viewController = self
        self.adminTableView.delegate = self.adminDataSource
        self.adminTableView.dataSource = self.adminDataSource
        self.dataSources[0].tableView = self.tableView
        self.dataSources[0].viewController = self
        self.tableView.dataSource = self.dataSources[0]
        self.dataSources[1].tableView = self.secondTableView
        self.dataSources[1].viewController = self
        self.secondTableView.dataSource = self.dataSources[1]
        
        self.leftBarView.touchEndedBlock { [unowned self] (view) in
            if self.showAlert() {
                self.performSegue(withIdentifier: "selectClassVC", sender: nil)
            }
            
        }
        
        self.rightBarView.touchEndedBlock { [unowned self] (view) in
            if self.showAlert() {
                if UserDefaults.standard.integer(forKey: UserIdentityKey) == 1 {
                    self.performSegue(withIdentifier: "addQuestionOrPost", sender: nil)
                } else if UserDefaults.standard.integer(forKey: UserIdentityKey) == 2 {
                    self.present(self.alertController!, animated: true, completion: nil)
                }
                
            }
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for dataSource in self.dataSources {
            dataSource.clearData()
        }
//        if UserDefaults.standard.string(forKey: DefaultClassKey) != nil {
//            self.reloadData()
//        }
        if self.isAdmin == false {
            self.leftBarView.isHidden = false
            self.rightBarView.isHidden = false
        }
        self.adminTableView.isHidden = true
        if self.showAlert() {
            self.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.leftBarView.isHidden = true
        self.rightBarView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: self.scrollView.height)
        //CGSizeMake(UIScreen.mainScreen.bounds.width * 2, self.scrollView.height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailVC" {
            let question = sender as! Question
            let dest = segue.destination as! QuestionDetailViewController
            dest.question = question
        } else if segue.identifier == "selectClassVC" {
            let dest = segue.destination as! UINavigationController
            let selectVC = dest.viewControllers.first as! SelectClassViewController
            selectVC.type = .normal
            selectVC.delegate = self
        } else if segue.identifier == "addQuestionOrPost" {
            let dest = segue.destination as! AddReplyViewController
            if UserDefaults.standard.integer(forKey: UserIdentityKey) == 1{
                dest.type = .addQuestion
            } else if UserDefaults.standard.integer(forKey: UserIdentityKey) == 2 {
                dest.type = .addPost
            } else {
                dest.type = .addBroadcast
            }
            dest.classId = UserDefaults.standard.string(forKey: DefaultClassKey)
        } else if segue.identifier == "manageStudent" {
            let dest = segue.destination as! UINavigationController
            let viewController = dest.viewControllers[0] as! ManageStudentViewController
            viewController.classId = UserDefaults.standard.string(forKey: DefaultClassKey)
        } else if segue.identifier == "showSelectionFromAdmin" {
            let dest = segue.destination as! SelectClassViewController
            dest.className = sender as? String
            dest.type = .admin
        }
    }
    
    func reloadData() {
        for dataSource in self.dataSources {
            dataSource.reloadData(success: { 
                
                }, failure: { 
                    
            })
        }
    }
    
    func showAlert() -> Bool {
        if UserDefaults.standard.string(forKey: UserObjectIdKey) == nil {
            self.present(self.loginAlertController!, animated: true, completion: nil)
            return false
        }
        if UserDefaults.standard.integer(forKey: UserIdentityKey) == 0 {
            self.adminTableView.isHidden = false
            return false
        }
        if UserDefaults.standard.string(forKey: DefaultClassKey) == nil {
            self.present(self.selectClassAlertController!, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func unwindToQuestionPage(segue: UIStoryboardSegue) {
        
    }

}

extension QuestionViewController: SlideTableViewNavigatorDelegate, UIScrollViewDelegate, UITableViewDelegate, SelectClassVCDelegate {
    
    func didSelect(classObject: Class) {
        (self.dataSources[1] as! PostDataSource).posts = classObject.posts
//        self.classId = classObject.objectId
        self.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentSize)
//        print(UIScreen.main.bounds.width)
        if scrollView == self.scrollView {
            // 过滤掉tableView的竖直滑动
            let offsetX = scrollView.contentOffset.x
            let portion = offsetX / scrollView.contentSize.width
//            print(portion)
            self.tableNavigator.portion = portion
//            self.dataSources[self.tableViewNavigator.currentSelection].reloadData(nil)

        }
    }
    
    func navigatorDidSelectTitleAtIndex(index: Int) {
        print(index)
        let rect = CGRect(x: CGFloat(index)*self.scrollView.width, y: 0, width: self.scrollView.width, height: self.scrollView.height)
        self.scrollView.scrollRectToVisible(rect, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            self.performSegue(withIdentifier: "showDetailVC", sender: self.questions![indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
