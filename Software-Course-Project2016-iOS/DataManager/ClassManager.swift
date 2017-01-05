//
//  classManager.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/31.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClassManager: NSObject {

    enum Errors: Error, CustomStringConvertible {
        case NotLoggedIn
        case AuthorityNotEnough
        
        var description: String {
            switch self {
            case .NotLoggedIn:
                return "当前还未登录"
            case .AuthorityNotEnough:
                return "权限不够"
            }
        }
    }
    
//    static 
    
    func selectClass(success: @escaping ([Class]) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .get, URLsuffix: "selectClass", params: nil, success: { (jsonData) in
            let jsons = JSON(jsonData)
            var classes = [Class]()
            for json in jsons.array! {
                classes.append(Class(json: json))
            }
            success(classes)
            }, failure: failure)
    }
    
    func selectQuestionsBy(classId: String, success: @escaping ([Question]) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .get, URLsuffix: "selectQuestionByClassId", params: ["classId": classId], success: { (jsonData) in
            let json = JSON(jsonData)
            var questions = [Question]()
            if let jsonArray = json.array {
                for object in jsonArray {
                    questions.append(Question(json: object))
                }
            }
            success(questions)
            }, failure: failure)
    }
    
    func SelectReplyBy(questionId: String, success: @escaping ([Reply]) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .get, URLsuffix: "selectReplyByQuestionId", params: ["questionId": questionId], success: { (jsonData) in
            let json = JSON(jsonData)
            var replies = [Reply]()
            if let replyArray = json.array {
                for reply in replyArray {
                    replies.append(Reply(json: reply))
                }
            }
            success(replies)
            }, failure: failure)
    }
    
    func addReply(questionId: String, replyContent: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .post, URLsuffix: "addReply", params: ["questionId": questionId, "replycontent": replyContent], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func markQuestionSolved(by questionId: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .post, URLsuffix: "markQuestionSolved", params: ["questionId": questionId], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func addQuestion(by classId: String, questionContent: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .post, URLsuffix: "addQuestion", params: ["classId": classId, "questionContent": questionContent], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func addPost(by classId: String, post: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .post, URLsuffix: "addPost", params: ["classId": classId, "post": post], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func addClass(by className: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) throws {
        guard UserDefaults.standard.data(forKey: UserCookieKey) != nil else {
            throw Errors.NotLoggedIn
        }
        NetworkManager.request(method: .post, URLsuffix: "addClass", params: ["className": className], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func addstudent(By studentName: String, classId: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "addStudent", params: ["studentName": studentName, "classId": classId], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func removeStudent(By studentName: String, classId: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "removeStudent", params: ["studentName": studentName, "classId": classId], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func searchClass(By name: String, success: @escaping ([Class]) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .get, URLsuffix: "searchclasses", params: ["name": name], success: { (jsonData) in
            let json = JSON(jsonData)
            var classes = [Class]()
            if let classArray = json.array {
                for classJson in classArray {
                    classes.append(Class(json: classJson))
                }
            }
            success(classes)
            }, failure: failure)
    }
}
