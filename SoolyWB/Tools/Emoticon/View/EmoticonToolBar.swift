//
//  EmoticonToolBar.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let toolBarColor = "#EAEAEA"

enum toolBarButtonType {
    case keyboard
    case recent
    case nomal
    case lxh
    case del
}

class EmoticonToolBar: UIView {
    
    var btnClickCallBack: ((_ clickBtnType: toolBarButtonType) -> ())?
    
    override func awakeFromNib() {
        setupUI()
    }

}

extension EmoticonToolBar {
    fileprivate func setupUI() {
        backgroundColor = UIColor.color(hex: toolBarColor)
        
        let btnSettings = [["imageName": "keyboard", "actionName": "btnClick"],
                           ["imageName": "recent", "actionName": "btnClick"],
                           ["imageName": "default_emoticon", "actionName": "btnClick"],
                           ["imageName": "lxh_emoticon", "actionName": "btnClick"],
                           ["imageName": "del", "actionName": "btnClick"]]
        
        let width: CGFloat = screenWidth / 5
        for i in 0..<5 {
            
            let x: CGFloat =  CGFloat(i) * width
            let btn = UIButton(frame: CGRect(x: x, y: 0, width: width, height: bounds.height))
            let image = UIImage(named: btnSettings[i]["imageName"]!)
            btn.setImage(image, for: [])
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            
            addSubview(btn)
        }
        
    }
}

// MARK: 监听方法
extension EmoticonToolBar {
    
    @objc fileprivate func btnClick(btn: UIButton) {
        
        var type: toolBarButtonType
        
        switch btn.tag {
        case 0:
            type = .keyboard
        case 1:
            type = .recent
        case 2:
            type = .nomal
        case 3:
            type = .lxh
        case 4:
            type = .del
        default:
            type = .nomal
        }
        
        btnClickCallBack?(type)
    }
}
