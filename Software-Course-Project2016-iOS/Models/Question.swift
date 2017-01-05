//
//  Question.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/24.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol QuestionAndReply {
    var objectId: String! {get set}
    var userId: String! {get set}
    var userName: String! {get set}
    var userIdentity: Int! {get set}
    var date: Date! {get set}
    var content: String! {get set}
}

class Question: QuestionAndReply, JSONConvertable {

    var objectId: String!
    var userId: String!
    var userName: String!
    var userIdentity: Int! = 1
    var date: Date!
    var content: String!
    var status: Bool!
    var classId: String!
    
    init() {

    }
    
    required init(json: JSON?) {
        if let objectId = json!["_id"].string {
            self.objectId = objectId
        }
        if let userId = json!["studentId"].string {
            self.userId = userId
        }
        if let userName = json!["studentName"].string {
            self.userName = userName
        }
        if let dateStr = json!["questionDate"].string {
            self.date = dateStr.date()
        }
        if let content = json!["questionContent"].string {
            self.content = content
        }
        if let status = json!["questionStatus"].bool {
            self.status = status
        }
        if let classId = json!["classId"].string {
            self.classId = classId
        }
        
    }
}
