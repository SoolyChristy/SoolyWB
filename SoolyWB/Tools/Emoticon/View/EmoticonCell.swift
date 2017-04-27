//
//  EmoticonCell.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let cellColor = "#F2F2F2"

/// EmoticonCell代理协议
protocol EmoticonCellDelegate: NSObjectProtocol {
    func emoticonClick(emoticon: WBEmoticon)
}

class EmoticonCell: UICollectionViewCell {
    
    weak var delegate: EmoticonCellDelegate?
    
    var emoticons: [WBEmoticon]? {
        didSet {
            // 隐藏所有btn 赋值时再显示 防止重用胡乱显示
            for btn in contentView.subviews {
                if let btn = btn as? UIButton {
                    btn.isHidden = true
                }
            }
            
            for (i,emoticon) in (emoticons ?? []).enumerated() {
                if let btn = contentView.subviews[i] as? UIButton {
                    btn.setImage(emoticon.image, for: [])
                    btn.setTitle(emoticon.getEmoji(), for: [])
                    btn.isHidden = false
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 表情监听方法
    @objc fileprivate func emoticonClick(btn: UIButton) {
        guard let emoticon = emoticons?[btn.tag] else {
            return
        }
        
        delegate?.emoticonClick(emoticon: emoticon)
    }
    
}

// MARK: 设置界面
extension EmoticonCell {
    fileprivate func setupUI() {
        
        contentView.backgroundColor = UIColor.color(hex: cellColor)
        
        let WH = (screenWidth - 2 * margin) / 7
        
        // 创建 21 个表情btn
        for i in 0..<21 {
            let row = i / 7
            let column = i % 7
            let x = margin + CGFloat(column) * WH
            let y = CGFloat(row) * WH
            
            let btn = UIButton(frame: CGRect(x: x, y: y, width: WH, height: WH))
            btn.tag = i
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            btn.addTarget(self, action: #selector(emoticonClick(btn:)), for: .touchUpInside)
            
            contentView.addSubview(btn)
        }
    }
}
