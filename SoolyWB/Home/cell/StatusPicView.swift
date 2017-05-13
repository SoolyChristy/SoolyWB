//
//  StatusPicView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/21.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

/// 点击图片通知
let photoDidSelectedNotification = "photoDidSelectedNotification"
/// 图片索引
let photoDidSelectedIndex = "photoDidSelectedIndex"
/// 图片url数组
let middlePhotoUrls = "middlePhotoUrls"
let largePhotoUrls = "largePhotoUrls"

class StatusPicView: UIView {

    /// 高度约束
//    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    
    var viewModel: WBStatusViewModel? {
        didSet {
            // 隐藏所有图片
            for v in subviews {
                v.isHidden = true
            }
            
            setupImageView()
        }
    }
    
    lazy var middlePicUrlStrs = [String]()
    lazy var largePicUrlStrs = [String]()
    
    override func awakeFromNib() {
        setupUI()
    }
    
    /// 手势监听方法
    @objc fileprivate func imageTaped(recognizer: UITapGestureRecognizer) {
        guard let urls = viewModel?.picUrls, var index = recognizer.view?.tag else {
            return
        }
        
        // 四张图处理
        if urls.count == 4 && index >= 2 {
            index -= 1
        }
        
        let userInfo: [String: Any] = [photoDidSelectedIndex: index,
                        middlePhotoUrls: middlePicUrlStrs,
                        largePhotoUrls: largePicUrlStrs]
        // 发送点击图片通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: photoDidSelectedNotification), object: nil, userInfo: userInfo)
    }
}

// MARK: 设置UI
extension StatusPicView {
    
    fileprivate func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        // viewModel还没有值 先创建9个imageView
        for i in 0..<9 {
            let row = i / 3
            let colunm = i % 3
            
            let x = CGFloat(colunm) * (picWH + picMargin)
            let y = CGFloat(row) * (picWH + picMargin)
            
            let imageView = UIImageView(frame: CGRect(x: x, y: y, width: picWH, height: picWH))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.isUserInteractionEnabled = true
            imageView.tag = i

            // 添加手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTaped(recognizer:)))
            imageView.addGestureRecognizer(tap)
            
            addSubview(imageView)
        }
    }
    
    fileprivate func setupImageView() {
        // 若没有图片
        guard let picUrls = viewModel?.picUrls else {
            return
        }

        // 由于重用的问题，需要先清空之前数据
        middlePicUrlStrs.removeAll()
        largePicUrlStrs.removeAll()
        
        // 记录图片字符串数组
        for url in picUrls {
            if let m = url.bmiddle_pic {
                middlePicUrlStrs.append(m)
            }
            if let b = url.large_pic {
                largePicUrlStrs.append(b)
            }
        }
        
        // 设置图片
        for (i,picModel) in (picUrls).enumerated() {
            var index = i
            
            // 四张图处理
            if picUrls.count == 4 && (i == 2 || i == 3){
                index += 1
            }
            
            let iv = subviews[index] as! UIImageView
            iv.isHidden = false
            iv.setImage(urlString: picModel.bmiddle_pic, placeholder: nil)
        }

        // 设置图片视图高度
        self.frame.size = CGSize(width: screenWidth - 2 * margin, height: viewModel?.picViewHeight ?? 0)
    }
}
