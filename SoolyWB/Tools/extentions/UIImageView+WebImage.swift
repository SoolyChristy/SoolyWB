//
//  UIImageView+WebImage.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/20.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - 隔离Kingfisher
extension UIImageView {
    
    func setImage(urlString: String?, placeholder: UIImage?) {
        
        let url = URL(string: urlString ?? "")
        kf.setImage(with: url, placeholder: placeholder)
    }
    
    /// 设置圆形图片
    ///
    /// - Parameters:
    ///   - urlString: url
    ///   - placeholder: 占位图
    ///   - size: 图片大小
    ///   - bgColor: 背景颜色
    func setCircularImage(urlString: String?, placeholder: UIImage?, size: CGSize, bgColor: UIColor) {
        let url = URL(string: urlString ?? "")
        
        kf.setImage(with: url, placeholder: placeholder) { [weak self] (image, _, _, _) in
            self?.image = image?.circuralImage(size: size, backgroundColor: bgColor)
        }
    }
}
