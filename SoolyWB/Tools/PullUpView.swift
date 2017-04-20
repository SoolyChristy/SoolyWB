//
//  PullUpView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/20.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class PullUpView: UIView {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    class func pullUpView() -> PullUpView {
        return Bundle.main.loadNibNamed("PullUpView", owner: nil, options: nil)?.last as! PullUpView
    }

}
