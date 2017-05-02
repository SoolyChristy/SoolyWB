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
    var isPullUp: Bool = false
    
    class func pullUpView() -> PullUpView {
        return Bundle.main.loadNibNamed("PullUpView", owner: nil, options: nil)?.last as! PullUpView
    }
    
    override func awakeFromNib() {
        indicator.isHidden = true
    }
    
    func startRefreshing() {
        indicator.isHidden = false
        indicator.startAnimating()
        isPullUp = true
    }

    func endRefreshing() {
        indicator.isHidden = true
        indicator.stopAnimating()
        isPullUp = false
    }
}
