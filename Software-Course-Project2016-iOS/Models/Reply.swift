//
//  Reply.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/24.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class Reply: QuestionAndReply, JSONConvertable {
    var objectId: String!
    var userId: String!
    var userName: String!
    var userIdentity: Int!
    var questionId: String!
    var content: String!
    var date: Date!
    
    required init(json: JSON?) {
        if let objectId = json!["_id"].string {
            self.objectId = objectId
        }
        if let userId = json!["userId"].string {
            self.userId = userId
        }
        if let userName = json!["userName"].string {
            self.userName = userName
        }
        if let userIdentity = json!["userIdentity"].int {
            self.userIdentity = userIdentity
        }
        if let questionId = json!["questionId"].string {
            self.questionId = questionId
        }
        if let dateStr = json!["replyDate"].string {
            self.date = dateStr.date()
        }
        if let content = json!["replyContent"].string {
            self.content = content
        }
    }

}
