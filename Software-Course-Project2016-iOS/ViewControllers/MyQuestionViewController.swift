//
//  MyQuestionViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/2.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

class MyQuestionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var questions: [Question]?
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailVCFromMy" {
            let question = sender as! Question
            let dest = segue.destination as! QuestionDetailViewController
            dest.question = question
        }
    }
    
    func reload() {
        self.userManager.selectQuestions(success: { [unowned self] (questions) in
            self.questions = questions
            self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
        }
    }

}

extension MyQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionTableViewCell
        cell.configureWith(question: self.questions![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showDetailVCFromMy", sender: self.questions?[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
}
