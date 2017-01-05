//
//  LoginPickerTableViewCell.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/25.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class LoginPickerTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var identityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        let pickerView = UIPickerView()
//        self.textField.inputView = pickerView
//        pickerView?.delegate = self
//        pickerView?.dataSource = self
//        self.textField.text = selections?[0]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
