//
//  StatusTableViewCell.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/20.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 微博来源
    @IBOutlet weak var resourceLabel: UILabel!
    /// 认证图标
    @IBOutlet weak var avatarIcon: UIImageView!
    /// 微博正文
    @IBOutlet weak var statusLabel: UILabel!
    /// 配图视图
    @IBOutlet weak var picView: StatusPicView!
    /// 工具栏
    @IBOutlet weak var toolBar: toolBarView!
    
    @IBOutlet weak var repostLabel: UILabel!
    
    
    var viewModel: WBStatusViewModel? {
        didSet {
            iconView.setImage(urlString: viewModel?.status.user?.avatar_large, placeholder: #imageLiteral(resourceName: "avatar_default_big"))
            nameLabel.text = viewModel?.status.user?.screen_name
            timeLabel.text = viewModel?.time
            resourceLabel.text = viewModel?.source
            avatarIcon.image = viewModel?.avatarImage
            statusLabel.attributedText = viewModel?.textAttributedStr
            toolBar.viewModel = viewModel
            picView.viewModel = viewModel
            
            // 设置转发微博
            if let repostAttr = viewModel?.repostTextAttr {
                repostLabel.attributedText = repostAttr
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
