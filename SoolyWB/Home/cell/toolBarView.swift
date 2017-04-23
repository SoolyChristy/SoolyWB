//
//  toolBarView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/22.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class toolBarView: UIView {

    var viewModel: WBStatusViewModel? {
        didSet {
            repostBtn.setTitle(viewModel?.repostStr, for: [])
            commentBtn.setTitle(viewModel?.commentStr, for: [])
            likeBtn.setTitle(viewModel?.likeStr, for: [])
        }
    }
    
    @IBOutlet weak var repostBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!

}
