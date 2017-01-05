//
//  PostTableViewCell.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/30.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var multilineTextField: MultilineTextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.multilineTextField.editable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWith(post: Post) {
        self.multilineTextField.text = post.content
        let dateFormate = "yyyy年MM月dd日"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormate
        timeLabel.text = dateFormatter.string(from: post.date)
    }
 
}
