//
//  SlideTableViewNavigator.swift
//  趣买乐
//
//  Created by Bers on 16/2/13.
//  Copyright © 2016年 Bers. All rights reserved.
//

import UIKit

protocol SlideTableViewNavigatorDelegate : class {
    func navigatorDidSelectTitleAtIndex(index: Int)
}

class SlideTableViewNavigator: UIView {
    
    var titles = [String]() {
        didSet{
            if self.titles.count > oldValue.count {
                for _ in 0..<self.titles.count - oldValue.count {
                    let label = UILabel()
                    label.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
                    label.textAlignment = .center
                    self.addSubview(label)
                    self.titleLabels.append(label)
                }
            }else{
                self.titleLabels.dropLast(oldValue.count - self.titles.count).forEach({ (label) -> () in
                    label.removeFromSuperview()
                })
            }
        }
    }
    var currentSelection : Int {
        get{
            return self.selection
        }
        set{
            self.titleLabels[self.currentSelection].textColor = App_LightFontColor
            self.selection = newValue
            self.titleLabels[newValue].textColor = App_MasterColor
            self.indicator.centerX = CGFloat(newValue + 1) * self.titleLabels.first!.width - (self.titleLabels[0].width / 2)
        }
    }
    var portion : CGFloat {
        get{
            return self.indicator.centerX / self.width
        }
        set{
            print(newValue)
            self.indicator.centerX = newValue * self.width + self.titleLabels.first!.centerX
            var index = Int(self.indicator.centerX / self.titleLabels.first!.width)
            index.restrictInRange(min: 0, 1)
            self.titleLabels[self.selection].textColor = App_LightFontColor
            self.titleLabels[index].textColor = App_MasterColor
            self.selection = index
        }
    }
    
    weak var delegate : SlideTableViewNavigatorDelegate?
    private var selection : Int = 0
    private var titleLabels = [UILabel]()
    private let separator = CAShapeLayer()
    private var indicator : UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        for _ in 0..<self.titles.count {
            let label = UILabel()
            label.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
            label.textAlignment = .center
            self.addSubview(label)
            self.titleLabels.append(label)
        }
        self.indicator = UIView()
        self.indicator.backgroundColor = App_MasterColor
        self.addSubview(self.indicator)
    }
    
    override func layoutSubviews() {
        self.separator.removeFromSuperlayer()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.width, y: 0))
//        CGPathMoveToPoint(path, nil, 0, 0)
        
            //        CGPathAddLineToPoint(path, nil, self.width, 0)
        self.separator.path = path
        self.separator.strokeColor = HEXColor(hex: 0xEFEFEF).cgColor
        self.separator.lineWidth = 1.0
        self.separator.frame = CGRect(x: 0, y: self.height, width: self.width, height: 1.0)
            //CGRectMake(0, self.height, self.width, 1.0)
        self.layer.addSublayer(self.separator)
        
        let titleWidth = self.width / CGFloat(self.titles.count)
        for i in 0..<self.titles.count {
            self.titleLabels[i].frame = CGRect(x: CGFloat(i)*titleWidth, y: 0, width: titleWidth, height: self.height)
                //CGRectMake(CGFloat(i) * titleWidth, 0, titleWidth, self.height)
            self.titleLabels[i].text = self.titles[i]
        }
        
        let textWidth = (self.titles[0] as NSString).size(attributes: [NSFontAttributeName:self.titleLabels[0].font]).width
        self.indicator.frame = CGRect(x: 0, y: self.height - 3.0, width: textWidth, height: 3.0)
            //CGRectMake(0, self.height - 3.0, textWidth, 3.0)
        self.indicator.centerX = CGFloat(self.selection + 1) * self.titleLabels.first!.width - (self.titleLabels[0].width / 2)
        
        self.titleLabels.forEach { (label) -> () in
            label.textColor = App_LightFontColor
        }
        
        if self.currentSelection < self.titles.count {
            self.titleLabels[self.currentSelection].textColor = App_MasterColor
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let aTouch = touch {
            let width = self.width / CGFloat(self.titles.count)
            let index = Int(aTouch.location(in: self).x / width)
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                self.indicator.centerX = CGFloat(index + 1) * width - width / 2
//                self.titleLabels[self.currentSelection].textColor = App_LightFontColor
//                }, completion: { (finished) -> Void in
//                    if finished{
                        self.titleLabels[index].textColor = App_MasterColor
                        if self.currentSelection != index {
                            self.currentSelection = index
                            self.delegate?.navigatorDidSelectTitleAtIndex(index: index)
                        }
                        
//                    }
//            })
        }
    }
    

    
    
}
