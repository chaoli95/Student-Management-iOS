//
//  Class.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/24.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class Class: JSONConvertable {
    var objectId: String!
    var studentId: [String]!
    var teacherId: String!
    var name: String!
    var fileName: [String]!
    var posts: [Post]!
    
    required init(json: JSON?) {
        if let objectId = json?["_id"].string {
            self.objectId = objectId
        }
        if let teacherId = json?["teacherId"].string {
            self.teacherId = teacherId
        }
        self.studentId = [String]()
        if let studentIds = json?["studentId"].array {
            for studentId in studentIds {
                self.studentId.append(studentId.string!)
            }
        }
        if let name = json?["className"].string {
            self.name = name
        }
        var postArray = [Post]()
        if let posts = json?["post"].array {
            for post in posts {
                postArray.append(Post(json: post))
            }
        }
        self.posts = postArray
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        if let objectId = aDecoder.decodeObject(forKey: "objectId") as? String {
//            self.objectId = objectId
//        }
//        if let studentId = aDecoder.decodeObject(forKey: "studentId") as? [String] {
//            self.studentId = studentId
//        }
//        if let teacherId = aDecoder.decodeObject(forKey: "teacherId") as? String {
//            self.teacherId = teacherId
//        }
//        if let name = aDecoder.decodeObject(forKey: "name") as? String {
//            self.name = name
//        }
//        if let fileName = aDecoder.decodeObject(forKey: "fileName") as? [String] {
//            self.fileName = fileName
//        }
//        if let posts = aDecoder.decodeObject(forKey: "posts") as? [Post] {
//            self.posts = posts
//        }
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        if let objectId = self.objectId {
//            aCoder.encode(objectId, forKey: "objectId")
//        }
//        if let studentId = self.studentId {
//            aCoder.encode(studentId, forKey: "studentId")
//        }
//        if let teacherId = self.teacherId {
//            aCoder.encode(teacherId, forKey: "teacherId")
//        }
//        if let name = self.name {
//            aCoder.encode(name, forKey: "name")
//        }
//        if let fileName = self.fileName {
//            aCoder.encode(fileName, forKey: "fileName")
//        }
//        if let posts = self.posts {
//            aCoder.encode(posts, forKey: "posts")
//        }
//    }
    
}

class Post: JSONConvertable {
    var objectId: String!
    var content: String!
    var date: Date!
    
    required init(json: JSON?) {
        if let objectId  = json?["_id"].string {
            self.objectId = objectId
        }
        if let content = json?["postContent"].string {
            self.content = content
        }
        if let dateStr = json?["postDate"].string {
            self.date = dateStr.date()
        }
    }
    
//    func encode(with aCoder: NSCoder) {
//        if let objectId = self.objectId {
//            aCoder.encode(objectId, forKey: "objectId")
//        }
//        if let content = self.content {
//            aCoder.encode(content, forKey: "content")
//        }
//        if (self.date) != nil {
//            aCoder.encode(date, forKey: "date")
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        if let objectId = aDecoder.decodeObject(forKey: "objectId") as? String {
//            self.objectId = objectId
//        }
//        if let content = aDecoder.decodeObject(forKey: "content") as? String {
//            self.content = content
//        }
//        if let date = aDecoder.decodeObject(forKey: "date") as? Date {
//            self.date = date
//        }
//    }
}
