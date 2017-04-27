//
//  UIImage+extension.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/23.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 根据颜色返回UIImage
    class func getImage(color: UIColor)->UIImage{
       
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    convenience init(color: UIColor) {
        self.init()
    }
}
