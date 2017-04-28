//
//  ComposeTextView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/26.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {
    
    /// 占位标签
    lazy var placeholderLabel: UILabel = {
       let l = UILabel(frame: CGRect(x: 5, y: 8, width: 0, height: 0))
        l.font = self.font
        l.text = "说点什么"
        l.textColor = UIColor.lightGray
        l.sizeToFit()
        return l
    }()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// textView文字改变
    @objc fileprivate func textChanged() {
        placeholderLabel.isHidden = hasText
    }
}

extension ComposeTextView {
    // MARK: 将表情插入 textView
    func insertEmoticon(emoticon: WBEmoticon) {
        // 若是emoji UITextRange 只用于此处
        if let emoji = emoticon.getEmoji(), let selectedTextRange = selectedTextRange {
            replace(selectedTextRange, withText: emoji)
            return
        }
        
        // 图片表情属性文本
        let imageText = emoticon.imageText(font: font!)
        
        // 获取textView 属性文本 可变
        let attrM = NSMutableAttributedString(attributedString: attributedText)
        
        // 替换光标选中文本
        attrM.replaceCharacters(in: selectedRange, with: imageText)
        
         // 记录光标位置
        let range = selectedRange
        
        // 重新设置属性文本
        attributedText = attrM
        
         // 恢复光标位置
        selectedRange = NSRange(location: range.location + 1, length: 0)
        
        textChanged()
        // 通知代理
        delegate?.textViewDidChange?(self)
        
    }
}

// MARK: 设置界面
extension ComposeTextView {
    fileprivate func setupUI() {
        // 注册通知
        // 不使用代理 如果这里使用代理 Controller的代理就不生效
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: Notification.Name.UITextViewTextDidChange, object: nil)
        
        addSubview(placeholderLabel)
    }
}
