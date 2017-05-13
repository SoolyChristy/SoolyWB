//
//  UIImage+Circular.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/7.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 裁剪圆形图片
    ///
    /// - Parameters:
    ///   - image: 原始图片
    ///   - size: 图片大小
    ///   - backgroundColor: 背景颜色
    /// - Returns: 圆形图片
    func circuralImage(size: CGSize, backgroundColor: UIColor?, isTransparent: Bool = false) -> UIImage? {
        
        let rect = CGRect(origin: CGPoint(), size: size)
        
        // 上下文
        // 参数: 1.size 绘图的尺寸  2. true(不透明) false(透明) 3. 屏幕分辨率 0: 选择当前设备分辨率
        if isTransparent {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
        }else {
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
        }
        
        // 背景填充
        if let bgColor = backgroundColor {
            bgColor.setFill()
            UIRectFill(rect)
        }
        
        // 创建圆形路径
        let path = UIBezierPath(ovalIn: rect)
        // 裁剪 路径外的部分
        path.addClip()
        
        // 绘图 drawInRect 在指定区域内拉伸
        self.draw(in: rect)
        
        // 绘制边框
//        UIColor.darkGray.setStroke()
//        path.lineWidth = 2
//        path.stroke()
        
        // 取结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return result
    }
}
