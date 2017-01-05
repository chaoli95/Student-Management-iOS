//
//  QuestionDetailViewController.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/31.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var question: Question!
    var replies: [Reply]?
    var classManager = ClassManager()
    var alertViewController: UIAlertController?
    
    lazy var rightBarView : UIView = {
        let view = UIView(frame: CGRect(x: self.view.bounds.width - 16 - 44, y: 0, width: 44, height: 44))//CGRectMake(16, 0, 200, 44)
        view.backgroundColor = UIColor.green
        //        let imageView = UIImageView(frame: CGRectMake(0, 15, 12, 15))
        //        imageView.image = UIImage(named: "place.png")
        //        view.addSubview(imageView)
        //
        //        let label = UILabel(frame: CGRectMake(22, 14, view.width - 12 - 8, 17))
        //        label.textColor = UIColor.whiteColor()
        //        label.font = UIFont.boldSystemFontOfSize(14)
        //        self.locationLabel = label
        //        view.addSubview(label)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
//            self.alertViewController?.dismiss(animated: true, completion: nil)
        })
        self.alertViewController?.addAction(cancelAction)
        let addReplyAction = UIAlertAction(title: "回复", style: .default) { (action) in
//            self.alertViewController?.dismiss(animated: true, completion: { 
                self.performSegue(withIdentifier: "addReplyVC", sender: nil)
//            })
        }
        self.alertViewController?.addAction(addReplyAction)
        let markAsSolvedAction = UIAlertAction(title: "标记为已解决", style: .default) { (action) in
            self.alertViewController?.dismiss(animated: true, completion: nil)
            try! self.classManager.markQuestionSolved(by: self.question.objectId, success: { (code, message) in
                if code == 200 {
                    
                }
                }, failure: { (error) in
                    
            })
        }
        if let userId = UserDefaults.standard.string(forKey: UserObjectIdKey) {
            if userId == question.userId {
                self.alertViewController?.addAction(markAsSolvedAction)
            }
        }
        
        self.rightBarView.touchEndedBlock { [unowned self] (view) in
//            self.performSegue(withIdentifier: "addReplyVC", sender: nil)
            self.present(self.alertViewController!, animated: true, completion: nil)
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.rightBarView.isHidden = false
        self.navigationController?.navigationBar.addSubview(self.rightBarView)
        print(self.navigationController?.navigationBar.subviews.count)
        
        try! self.classManager.SelectReplyBy(questionId: self.question.objectId, success: { (replies) in
            self.replies = replies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.rightBarView.removeFromSuperview()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addReplyVC" {
            let dest = segue.destination as! AddReplyViewController
            dest.questionId = self.question.objectId
            dest.type = .addReply
        }
    }

}

extension QuestionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let replies = self.replies {
            return replies.count+1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! QuestionDetailTableViewCell
        cell.numLabel.text = "#" + String(indexPath.row+1)
        if indexPath.row == 0 {
            cell.configureWith(detail: self.question)
        } else {
            cell.configureWith(detail: self.replies![indexPath.row-1])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
}
