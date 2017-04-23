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
}
