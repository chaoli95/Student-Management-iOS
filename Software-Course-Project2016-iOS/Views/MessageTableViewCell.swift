//
//  MessageTableViewCell.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 17/1/2.
//  Copyright © 2017年 UniqueStudio. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: MultilineTextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
