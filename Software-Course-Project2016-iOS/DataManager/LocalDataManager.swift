////
////  LocalDataManager.swift
////  Software-Course-Project2016-iOS
////
////  Created by 李超 on 16/12/24.
////  Copyright © 2016年 UniqueStudio. All rights reserved.
////
//
//
//import UIKit
//
//protocol SQLiteStatementConvertible {
//    var objectId : String! { get set }
//    var propertyWithTypeListStatement : String { get }
//    var propertyListStatement : String { get }
//    var valuePlaceholderStatement : String { get }
//    /// 顺序必须与类属性定义的顺序相同，不提供数组、字典和NSDate等类型的默认实现
//    func storableValues() -> [AnyObject]
//    init(rs: FMResultSet)
//}
//
//
//extension SQLiteStatementConvertible {
//    var propertyWithTypeListStatement : String {
//        var str = "'objectId' INTEGER PRIMARY KEY"
//        let mirror = Mirror(reflecting: self)
//        for (key, value) in mirror.children {
//            if let key = key {
//                if key == "objectId" || key == "reflecting"{
//                    continue;
//                }
//                let valueMirror = Mirror(reflecting: value)
//                str += ", '\(key)"
//                if (valueMirror.subjectType == String.self || valueMirror.subjectType == Optional<String>.self) {
//                    str += "' TEXT"
//                } else if (valueMirror.subjectType == Int.self || valueMirror.subjectType == Optional<Int>.self) {
//                    str += "' INTEGER"
//                } else if (valueMirror.subjectType == Double.self || valueMirror.subjectType == Optional<Double>.self ||
//                    valueMirror.subjectType == NSDate.self || valueMirror.subjectType == Optional<NSDate>.self ) {
//                    str += "' REAL"
//                } else {
//                    str += "' BLOB"
//                }
//            }
//        }
//        return str
//    }
//    
//    
//    var propertyListStatement : String {
//        var str = ""
//        let mirror = Mirror(reflecting: self)
//        for (key, _) in mirror.children {
//            if let key = key {
//                if key == "reflecting" {
//                    continue
//                }
//                str += "'\(key)', "
//            }
//        }
////        return str.substringToIndex(str.endIndex.advancedBy(-2))
//        let index = str.index(str.endIndex, offsetBy: -2)
//        return str.substring(to: index)
//    }
//    
//    var valuePlaceholderStatement : String {
//        var str = ""
//        let mirror = Mirror(reflecting: self)
//        for (key, _) in mirror.children {
//            if let key = key {
//                if key == "reflecting" {
//                    continue
//                }
//                str += "?, "
//            }
//        }
//        let index = str.index(str.endIndex, offsetBy: -2)
//        return str.substring(to: index)
//    }
//    
//    func storableValues() -> [AnyObject] {
//        /// 如果是可选类型但非隐式解析可选类型无法取出value
//        var values = [AnyObject]()
//        let mirror = Mirror(reflecting: self)
//        for (key, value) in mirror.children {
//            if let _ = key {
//                let valueMirror = Mirror(reflecting: value)
//                if (valueMirror.subjectType == String.self || valueMirror.subjectType == Optional<String>.self ||
//                    valueMirror.subjectType == Double.self || valueMirror.subjectType == Optional<Double>.self ||
//                    valueMirror.subjectType == Int.self || valueMirror.subjectType == Optional<Int>.self ||
//                    valueMirror.subjectType == NSData.self || valueMirror.subjectType == Optional<NSData>.self) {
//                    let object = value as AnyObject
////                    if let object = object {
//                        values.append(object)
////                    }else{
////                        values.append(NSNull())
////                    }
//                }else if (valueMirror.subjectType == UIImage.self || valueMirror.subjectType == Optional<UIImage>.self){
//                    let image = value as? UIImage
//                    if let image = image {
//                        let data = UIImagePNGRepresentation(image)
//                        if let data = data {
//                            values.append(data as AnyObject)
//                        }
//                    }else{
//                        values.append(NSNull())
//                    }
//                }else{
//                    values.append(NSNull())
//                }
//            }
//        }
//        return values
//    }
//}
//
//
//class LocalDataManager {
//    
//    static let sharedManager = LocalDataManager()
//    
//    private let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    private let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//    
//    private var database : FMDatabase!
//    
//    struct TableName {
//        static var User = "_UserTable"
////        static var Store = "_QMLStoreTable"
//    }
//    
//    private init() {
//        let localDataFilePathString = cachesPath + "/localdata.sqlite"
//        self.database = FMDatabase(path: localDataFilePathString)
//        guard self.database.open() else {
//            self.database.close()
//            self.database = nil
//            return
//        }
//        self.createTables()
//    }
//    
//    private func createTables() {
//        let userQuery = "CREATE TABLE IF NOT EXISTS \(TableName.User) (\(User().propertyWithTypeListStatement))"
////        guard self.database.executeUpdate(userQuery, withArgumentsInArray: nil) else {
////            self.database.close()
////            self.database = nil
////            return
////        }
//        guard self.database.executeUpdate(userQuery, withArgumentsIn: nil) else {
//            self.database.close()
//            self.database = nil
//            return
//        }
//    }
//    
//    
//    deinit {
//        self.database.close()
//    }
//    
//    var currentUser : User? {
//        get {
//            let query = "SELECT * FROM \(TableName.User)"
//            do {
//                let res = try self.database.executeQuery(query, values: nil)
//                if !res.next() {
//                    return nil
//                }
//                return User(rs: res)
//            }catch{
//                return nil
//            }
//        }
//        set {
//            if let user = newValue {
//                // 设置
//                let deleteUpdate = "DELETE FROM \(TableName.User)"
//                let insertUpdate = "INSERT INTO \(TableName.User) (\(user.propertyListStatement)) VALUES (\(user.valuePlaceholderStatement))"
//                do {
//                    try self.database.executeUpdate(deleteUpdate, values: nil)
//                    try self.database.executeUpdate(insertUpdate, values: user.storableValues())
//                }catch let error as NSError{
//                    NSLog("Update default user error: \(error.localizedDescription)");
//                }
//            }else{
//                // 清除原有的
//                let update = "DELETE FROM \(TableName.User)"
//                do {
//                    try self.database.executeUpdate(update, values: nil)
//                }catch let error as NSError{
//                    NSLog("Delete default user error: \(error.localizedDescription)");
//                }
//            }
//        }
//    }
//
//    
//}
//
