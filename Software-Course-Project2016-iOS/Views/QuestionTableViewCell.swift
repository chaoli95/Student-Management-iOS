//
//  QuestionTableViewCell.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/30.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var studentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(question: Question) {
        let dateFormate = "yyyy年MM月dd日"
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormate
        timeLabel.text = dateFormatter.string(from: question.date)
        studentLabel.text = "提问人：" + question.userName
        if question.status == false {
            titleLabel.text = "【未解决】" + question.content
        } else {
            titleLabel.text = "【已解决】" + question.content
        }
    }

}
