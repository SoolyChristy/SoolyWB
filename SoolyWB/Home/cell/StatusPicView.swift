//
//  StatusPicView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/21.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        setupUI()
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
            imageView.backgroundColor = UIColor.yellow
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
//            imageView.isHidden = true
            addSubview(imageView)
        }
    }
    
    fileprivate func setupImageView() {
        // 若没有图片
        guard let picUrls = viewModel?.picUrls else {
            return
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
