//
//  QuestionDataSource.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/30.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class QuestionDataSource: NSObject, QuestionTableViewDataSource {

    var tableView : UITableView?
    weak var viewController : QuestionViewController!
    var questions: [Question]?
    var classManager = ClassManager()
    
    func clearData() {
        self.questions = [Question]()
        self.tableView?.reloadData()
    }
    
    func reloadData(success: SimpleClosure?, failure: SimpleClosure?) {
        guard let classId = UserDefaults.standard.string(forKey: DefaultClassKey) else {
            return
        }
        try! self.classManager.selectQuestionsBy(classId: classId, success: { (questions) in
            self.questions = questions
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
        return self.questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionTableViewCell
//        cell.configureWithQuestion(question: questions![indexPath.row])
        cell.configureWith(question: questions![indexPath.row])
        return cell
    }
}
