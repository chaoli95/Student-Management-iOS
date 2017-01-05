//
//  User.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/24.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class User/*: SQLiteStatementConvertible*/: JSONConvertable {
    var objectId: String!
    var loginName: String!
    var userName: String!
    var password: String!
    var identity: Int!
//    var email: String!
    var questionOne: String!
    var answerOne: String!
    var questionTwo: String!
    var answerTwo: String!
    var questionThree: String!
    var answerThree: String!
    var messages: [Message]!
    
    init() {
        
    }
    
    required init(json: JSON?) {
        if let objectId = json?["_id"].string {
            self.objectId = objectId
        }
        if let loginName = json?["loginname"].string {
            self.loginName = loginName
        }
        if let userName = json?["name"].string {
            self.userName = userName
        }
        if let identity = json?["identity"].int {
            self.identity = identity
        }
    }
    
//    required init(rs: FMResultSet) {
//        self.objectId = rs.string(forColumn: "objectId")
//        self.loginName = rs.string(forColumn: "loginName")
//        self.userName = rs.string(forColumn: "userName")
//        self.password = rs.string(forColumn: "password")
//        self.identity = Int(rs.int(forColumn: "identity"))
////        self.email = rs.string(forColumn: "email")
////        self.questionOne = rs.string(forColumn: "questionOne")
////        self.questionTwo = rs.string(forColumn: "questionTwo")
////        self.objectId = rs.string(forColumn: "objectId")
////        self.objectId = rs.string(forColumn: "objectId")
////        self.objectId = rs.string(forColumn: "objectId")
////        self.objectId = rs.string(forColumn: "objectId")
//    }
//    
//    func storableValues() -> [AnyObject] {
//        var values = [AnyObject]()
//        values.append(objectId as AnyObject? ?? NSNull())
//        values.append(loginName as AnyObject? ?? NSNull())
//        values.append(userName as AnyObject? ?? NSNull())
//        values.append(password as AnyObject? ?? NSNull())
//        values.append(identity as AnyObject? ?? NSNull())
////        values.append(email as AnyObject? ?? NSNull())
//        return values
//    }
    
}

class Message: JSONConvertable {
    var objectId: String!
    var senderId: String!
    var content: String!
    var date: Date!
    
    required init(json: JSON?) {
        if let objectId = json?["_id"].string {
            self.objectId = objectId
        }
        if let content = json?["message"].string {
            self.content = content
        }
        if let senderId = json?["senderId"].string {
            self.senderId = senderId
        }
        if let dateStr = json?["date"].string {
            self.date = dateStr.date()
        }
    }
}
