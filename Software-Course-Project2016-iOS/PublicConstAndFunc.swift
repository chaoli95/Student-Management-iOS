//
//  PublicConstAndFunc.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/23.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import Foundation

typealias ErrorHandlingClosure = ((Error) -> Void)
typealias JSONDataHandlingClosure = ((Any) -> Void)
typealias SimpleClosure = () -> Void

let App_MasterColor = HEXColor(hex: 0xE84E40)
let App_LightFontColor = HEXColor(hex: 0x999999)
let UserCookieKey = "UserCookie"
let UserObjectIdKey = "UserObjectId"
let UserIdentityKey = "UserIdentity"
let UserNameKey = "UserName"
let DefaultClassKey = "defaultClassObjectId"

extension SignedNumber {
    
    mutating func restrictInRange(min:Self, _ max: Self){
        if self<min {
            self = min
        }
        if self>max {
            self = max
        }
    }
}

func restrictText(text: String, length: Int) -> String {
    if text.characters.count <= length {
        return text
    } else {
        let index = text.index(text.startIndex, offsetBy: length)
        return text.substring(to: index)
    }
}

extension String {
    func date() -> Date? {
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
    
    var pinyin : String {
        let str = NSMutableString(string: self)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        let pinyinStr = String(str)
        return pinyinStr
    }
}



extension String {
    
    func showLoadingHUD() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: self)
    }
    
    func showErrorHUD(mask: SVProgressHUDMaskType = .none) {
        SVProgressHUD.setDefaultMaskType(mask)
        if mask == .black {
            SVProgressHUD.setDefaultStyle(.light)
        }else{
            SVProgressHUD.setDefaultStyle(.dark)
        }
        SVProgressHUD.showError(withStatus: self)
    }
    
    func showSuccessHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.showSuccess(withStatus: self)
    }
    
}

