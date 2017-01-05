//
//  MultilineTextField.swift
//  Software-Course-Project2016-iOS
//
//  Created by 李超 on 16/12/30.
//  Copyright © 2016年 UniqueStudio. All rights reserved.
//

import UIKit

protocol MultilineTextFieldDelegate: class {
    func multiTextFieldDidChange(textField: MultilineTextField)
}

@IBDesignable class MultilineTextField: UIView, UITextViewDelegate {
    
    var textView = UITextView()
    
    var editable : Bool {
        get {
            return self.textView.isEditable
        }
        set {
            self.textView.isEditable = newValue
        }
    }
    
    weak var delegate : MultilineTextFieldDelegate?
    
    var text : String {
        get{
            return self.textView.text
        }
        set{
            self.textView.text = newValue
        }
    }
    var placeholderLabel = UILabel(frame: CGRect.zero)
    
    @IBInspectable var textColor : UIColor = UIColor.black
    
    @IBInspectable var placeholder : String? {
        get{
            return self.placeholderLabel.text
        }
        set{
            self.placeholderLabel.text = newValue
            self.placeholderLabel.sizeToFit()
        }
    }
    
    @IBInspectable var font : UIFont? {
        get{
            return self.textView.font
        }
        set{
            self.textView.font = newValue
            self.placeholderLabel.font = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commitInit()
    }
    
    func commitInit() {
        self.textView.textColor = self.textColor
        self.textView.isEditable = true
        self.textView.delegate = self
        self.textView.backgroundColor = UIColor.clear
        self.textView.font = UIFont.systemFont(ofSize: 12)
        self.textView.isScrollEnabled = true
        self.addSubview(self.textView)
        
        self.placeholderLabel.textColor = UIColor.lightGray
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 12)
        self.placeholderLabel.text = self.placeholder
        self.addSubview(self.placeholderLabel)
    }
    
    override func layoutSubviews() {
        self.textView.frame = self.bounds
        self.textView.delegate = self
        self.textView.returnKeyType = .done
        self.placeholderLabel.frame = CGRect(x: 4, y: 7, width: 0, height: 0)
            //CGRectMake(4, 7, 0, 0)
        self.placeholderLabel.sizeToFit()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = textView.text != ""
        let selectRange = textView.markedTextRange
        //        let pos = textView.positionFromPosition((selectRange?.start)!, offset: 0)
        if selectRange != nil {
            return
        }
        self.delegate?.multiTextFieldDidChange(textField: self)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
}

