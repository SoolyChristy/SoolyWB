//
//  EmoticonToolBar.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let toolBarColor = "#EAEAEA"
private let btnWidth: CGFloat = screenWidth / 5

enum toolBarButtonType {
    case keyboard
    case recent
    case nomal
    case lxh
    case del
    case delLongPress
}

class EmoticonToolBar: UIView {
    
    /// 工具条按钮点击回调
    var btnClickCallBack: ((_ clickBtnType: toolBarButtonType) -> ())?
    /// 选中分组
    var selectedSection: Int = 0 {
        didSet {
            switch selectedSection {
            case 0:
                moveIndicator(section: 0)
            case 1, 2:
                moveIndicator(section: 1)
            case 3:
                moveIndicator(section: 2)
            default:
                break
            }
        }
    }
    /// 分页指示器
    fileprivate lazy var indicatorView = UIView()
    
    override func awakeFromNib() {
        setupUI()
    }

    /// 移动分页指示器 0 1 2
    fileprivate func moveIndicator(section: Int) {
        UIView.animate(withDuration: 0.25) { 
            self.indicatorView.frame.origin.x = CGFloat(section) * btnWidth + btnWidth
        }
    }
    
}

extension EmoticonToolBar {
    fileprivate func setupUI() {
        backgroundColor = UIColor.color(hex: toolBarColor)
        
        let btnSettings = [["imageName": "keyboard", "actionName": "btnClick"],
                           ["imageName": "recent", "actionName": "btnClick"],
                           ["imageName": "default_emoticon", "actionName": "btnClick"],
                           ["imageName": "lxh_emoticon", "actionName": "btnClick"],
                           ["imageName": "del", "actionName": "btnClick", "longPress": "longPress"]]
        
        for (i,settings) in btnSettings.enumerated() {
            
            let x: CGFloat =  CGFloat(i) * btnWidth
            let btn = UIButton(frame: CGRect(x: x, y: 0, width: btnWidth, height: bounds.height))
            let image = UIImage(named: btnSettings[i]["imageName"]!)
            btn.setImage(image, for: [])
            btn.tag = i
            
            // 增加监听方法
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            
            // 增加长按手势
            if settings["longPress"] != nil {
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(delBtnLongPress))
                longPress.minimumPressDuration = 0.8
                btn.addGestureRecognizer(longPress)
            }
            
            addSubview(btn)
        }
        
        // 设置分页指示器
        indicatorView.frame = CGRect(x: btnWidth, y: frame.height - 2, width: btnWidth, height: 2)
        indicatorView.backgroundColor = UIColor.color(hex: "#FC6A08")
        addSubview(indicatorView)
        
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
            moveIndicator(section: 0)
        case 2:
            type = .nomal
            moveIndicator(section: 1)
        case 3:
            type = .lxh
            moveIndicator(section: 2)
        case 4:
            type = .del
        default:
            type = .nomal
        }
        
        btnClickCallBack?(type)
    }
    
    // MARK: 退格键长按监听方法
    @objc fileprivate func delBtnLongPress() {
        btnClickCallBack?(.delLongPress)
    }
}
