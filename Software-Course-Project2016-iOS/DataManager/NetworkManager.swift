//
//  NetworkManager.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/23.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol JSONConvertable{
    init(json: JSON?)
}

class NetworkManager {
    
//    let URL = "http://localhost:3000/"
    
    class func request(method: HTTPMethod = .get,
                       URLsuffix: String,
                       params: [String: Any]?,
                       success: JSONDataHandlingClosure?,
                       failure: ErrorHandlingClosure?) {
        Alamofire.request("http://localhost:3000/"+URLsuffix, method: method, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success(let jsonData):
                success?(jsonData)
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
}
