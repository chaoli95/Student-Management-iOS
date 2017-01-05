//
//  PostDataSource.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/30.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class PostDataSource: NSObject, QuestionTableViewDataSource {
    
    var tableView : UITableView?
    weak var viewController : QuestionViewController!
    var posts: [Post]?
    var classManager = ClassManager()
    
    func clearData() {
        self.posts = [Post]()
        self.tableView?.reloadData()
    }
    
    func reloadData(success: SimpleClosure?, failure: SimpleClosure?) {
        guard let classId = UserDefaults.standard.string(forKey: DefaultClassKey) else {
            return
        }
        try! self.classManager.selectClass(success: { (classes) in
            for classObject in classes {
                if classObject.objectId == classId {
                    self.posts = classObject.posts
                    break
                }
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            success?()
            }) { (error) in
                failure?()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
        cell.configureWith(post: posts![indexPath.row])
        return cell
    }
}
