//
//  UserManager.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/31.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UserManager: NSObject {

    func siguUp(user: User, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        let paramsDic = ["name": user.userName,
                         "loginname": user.loginName,
                         "password": user.password,
                         "identity": user.identity,
                         "questionOne": user.questionOne,
                         "questionTwo": user.questionTwo,
                         "questionThree": user.questionThree,
                         "answerOne": user.answerOne,
                         "answerTwo": user.answerTwo,
                         "answerThree": user.answerThree] as [String : Any]
        NetworkManager.request(method: .post, URLsuffix: "signup", params: paramsDic, success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func loginIn(loginname: String, password: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        Alamofire.request("http://localhost:3000/"+"login", method: .post, parameters: ["loginname": loginname, "password": password]).responseJSON { (response) in
            switch response.result{
            case .success(let jsonData):
                let json = JSON(jsonData)
                if json["code"].int! == 200 {
                    if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.request?.url {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: cookies)
                        UserDefaults.standard.set(encodedData, forKey: UserCookieKey)
                    }
                    UserDefaults.standard.set(json["objectId"].string, forKey: UserObjectIdKey)
                    UserDefaults.standard.set(json["identity"].int, forKey: UserIdentityKey)
                    UserDefaults.standard.set(json["name"].string, forKey: UserNameKey)
                }
                success(json["code"].int!, json["message"].string!)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getVerifyQuestionBy(loginName: String, success: @escaping (_ code: Int, _ message: String, _ questions: [String]) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "getverifyquestion", params: ["loginname": loginName], success: { (jsonData) in
            let json = JSON(jsonData)
            var questionArray = [String]()
            if let questions = json["verifyQuestion"].array {
                for question in questions {
                    questionArray.append(question.string!)
                }
            }
            success(json["code"].int!, json["message"].string!, questionArray)
            }, failure: failure)
    }
    
    func findPasswordBy(answers: [String], loginName: String, pwd: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "findPassword", params: ["answerOne": answers[0], "answerTwo": answers[1], "answerThree": answers[2], "loginname": loginName, "password": pwd], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func changePassword(oldPwd: String, newPwd: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "changePassword", params: ["oldPassword": oldPwd, "newPassword": newPwd], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func selectUserInfo(userId: String, success: @escaping (_ code: Int, _ message: String, _ user: User) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .get, URLsuffix: "selectUserInfo", params: ["userId": userId], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!, User(json: json["user"]))
            }, failure: failure)
    }
    
    func getMessage(success: @escaping (_ code: Int, _ message: String, _ user: [Message]) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .get, URLsuffix: "getMessage", params: nil, success: { (jsonData) in
            let json = JSON(jsonData)
            var messages = [Message]()
            if let messageJson = json["msg"].array {
                for message in messageJson {
                    messages.append(Message(json: message))
                }
            }
            success(json["code"].int!, json["message"].string!, messages)
            }, failure: failure)
    }
    
    func sendMessage(studentName: String, content: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "sendMessage", params: ["studentName": studentName, "content": content], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func selectQuestions(success: @escaping ([Question]) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .get, URLsuffix: "selectQuestionByStudentId", params: nil, success: { (jsonData) in
            let json = JSON(jsonData)
            var questions = [Question]()
            if let questionJson = json.array {
                for question in questionJson {
                    questions.append(Question(json: question))
                }
            }
            success(questions)
            }, failure: failure)
    }
    
    func deleteUser(By loginname:String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "deleteUser", params: ["loginname": loginname], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func resetUser(By loginname:String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "resetUser", params: ["loginname": loginname], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func checkData(classId: String, date: String, success: @escaping (_ code: Int, _ message: String?, _ questionCount: Int?, _ solvedCount: Int?) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "displayData", params: ["questionDate": date, "classId": classId], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string, json["numofquestion"].int, json["numofmarkedquestion"].int)
            }, failure: failure)
    }
    
    func broadcast(content: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "broadcast", params: ["content": content], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
    
    func remindTeacher(By classId: String, success: @escaping (_ code: Int, _ message: String) -> Void, failure: @escaping ErrorHandlingClosure) {
        NetworkManager.request(method: .post, URLsuffix: "remindTeacher", params: ["classId": classId], success: { (jsonData) in
            let json = JSON(jsonData)
            success(json["code"].int!, json["message"].string!)
            }, failure: failure)
    }
}
