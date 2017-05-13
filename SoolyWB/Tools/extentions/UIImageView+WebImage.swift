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
    
    func setImage(urlString: String?,
                  placeholder: UIImage?,
                  compeletion: ((_ image: UIImage?) -> ())? = nil)
    {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.center = (superview?.center)!
        addSubview(indicator)
        indicator.startAnimating()
        
        let url = URL(string: urlString ?? "")
//        kf.setImage(with: url, placeholder: placeholder) { (image, _, _, _) in
//            compeletion?(image)
//            indicator.stopAnimating()
//        }
        kf.setImage(with: url, placeholder: placeholder, progressBlock: { (current, total) in
            
        }) { (image, _, _, _) in
            compeletion?(image)
            indicator.stopAnimating()
        }
        
    }
    
    /// 设置圆形图片
    ///
    /// - Parameters:
    ///   - urlString: url
    ///   - placeholder: 占位图
    ///   - size: 图片大小
    ///   - bgColor: 背景颜色
    ///   - isTransparent: 背景是否透明
    func setCircularImage(urlString: String?,
                          placeholder: UIImage?,
                          size: CGSize,
                          bgColor: UIColor?,
                          isTransparent: Bool = false)
    {
        let url = URL(string: urlString ?? "")
        
        kf.setImage(with: url, placeholder: placeholder) { [weak self] (image, _, _, _) in
            self?.image = image?.circuralImage(size: size, backgroundColor: bgColor, isTransparent: isTransparent)
        }
    }
    
    ///
//    func setImageWithIndicator(urlString: String,
//                  placeholder: UIImage?,
//                  compelection: ((_ image: UIImage?) -> ())? = nil)
//    {
//        indi
//    }
}
