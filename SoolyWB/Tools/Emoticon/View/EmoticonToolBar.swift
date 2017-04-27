//
//  EmoticonToolBar.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let toolBarColor = "#EAEAEA"

class EmoticonToolBar: UIView {
    
    override func awakeFromNib() {
        setupUI()
    }

}

extension EmoticonToolBar {
    fileprivate func setupUI() {
        backgroundColor = UIColor.color(hex: toolBarColor)
        
        let btnSettings = [["imageName": "keyboard", "actionName": "keyboardBtnClick"],
                           ["imageName": "recent", "actionName": "recentBtnClick"],
                           ["imageName": "defaultEmoticon", "actionName": "defaultBtnClick"],
                           ["imageName": "lxhEmoticon", "actionName": "lxhBtnClick"],
                           ["imageName": "del", "actionName": "delBtnClick"]]
        
        let width: CGFloat = screenWidth / 5
        for i in 0..<5 {
            
            let x: CGFloat =  CGFloat(i) * width
            let btn = UIButton(frame: CGRect(x: x, y: 0, width: width, height: bounds.height))
            let image = UIImage(named: btnSettings[i]["imageName"]!)
            btn.setImage(image, for: [])
            
            btn.addTarget(self, action: Selector(btnSettings[i]["actionName"]!), for: .touchUpInside)
            
            addSubview(btn)
        }
        
    }
}

// MARK: 监听方法
extension EmoticonToolBar {
    @objc fileprivate func keyboardBtnClick() {
        
    }
    
    @objc fileprivate func recentBtnClick() {
        
    }
    
    @objc fileprivate func defaultBtnClick() {
        
    }
    
    @objc fileprivate func lxhBtnClick() {
        
    }
    
    @objc fileprivate func delBtnClick() {
        
    }
}
