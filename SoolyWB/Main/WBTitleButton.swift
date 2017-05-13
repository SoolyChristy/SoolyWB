//
//  WBTitleButton.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/12.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView, let titleLabel = titleLabel else {
            return
        }
        
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.frame.width + 5
        
    }
    
}

extension WBTitleButton {
    func setTitle(title: String, isHome: Bool = false) {
        let str = NSAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30)])
        setAttributedTitle(str, for: [])
        
        if isHome {
            setImage(#imageLiteral(resourceName: "triangle_down"), for: .normal)
            setImage(#imageLiteral(resourceName: "triangel_up"), for: .selected)
        }
        
        sizeToFit()
    }
}

extension WBTitleButton {
    fileprivate func setupUI() {
        
        
    }
}
