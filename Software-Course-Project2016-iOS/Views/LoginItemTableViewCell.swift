//
//  LoginItemTableViewCell.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

protocol LoginItemCellTextDelegate : class {
    func textDidChange(sender: UITextField)
}

class LoginItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!

    weak var delegate : LoginItemCellTextDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let imageView = UIImageView(frame: CGRect(0, 0, 35, 20))
//        imageView.contentMode = .center
//        self.textField.leftView = imageView
//        self.textField.leftViewMode = .always
        self.textField.addTarget(self, action: #selector(LoginItemTableViewCell.textFieldTextDidChange(notification:)), for: UIControlEvents.editingChanged)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginItemTableViewCell.textFieldTextDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: self.textField)
        // Initialization code
    }

    func textFieldTextDidChange(notification: NSNotification){
//        let textField = notification.object as! UITextField
        self.delegate?.textDidChange(sender: textField)
    }
    
//    func setLeftIcon(image: UIImage?) {
//        let imageView = self.textField.leftView as! UIImageView
//        imageView.image = image
//    }
//    
//    func setSendcodeButtonWidth(constant: CGFloat) {
//        self.buttonWidth.constant = constant
//    }
    

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
    
}
