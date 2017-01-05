//
//  UiViewExtensions.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/26.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

//
//  UIViewExtensions.swift
//  趣买乐
//
//  Created by Bers on 15/12/21.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

extension UIView {
    
    var centerX : CGFloat {
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.centerY)
            //CGPointMake(newValue, self.centerY)
        }
    }
    
    var centerY : CGFloat {
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.centerX, y: newValue)
            //CGPointMake(self.centerX, newValue)
        }
    }
    
    
    var width : CGFloat {
        return self.bounds.size.width
    }
    
    var height : CGFloat {
        return self.bounds.size.height
    }
    
    var originX : CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var originY : CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
}

func RGBColor(red: Int, _ green: Int, _ blue: Int) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
}

func HEXColor(hex: Int) -> UIColor {
    return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: 1.0)
}
