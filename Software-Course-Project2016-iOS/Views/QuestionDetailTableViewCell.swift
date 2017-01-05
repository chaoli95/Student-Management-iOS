//
//  QuestionDetailTableViewCell.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/30.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class QuestionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contectTextField: MultilineTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(detail: QuestionAndReply) {
        self.contectTextField.editable = false
        if detail.userIdentity == 2 {
            self.userLabel.text = "【老师】" + detail.userName
        } else if detail.userIdentity == 0 {
            self.userLabel.text = "【管理员】" + detail.userName
        } else {
            self.userLabel.text = detail.userName
        }
        let dateFormate = "yyyy年MM月dd日"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormate
        self.timeLabel.text = dateFormatter.string(from: detail.date)
        self.contectTextField.text = detail.content ?? ""
    }

}
