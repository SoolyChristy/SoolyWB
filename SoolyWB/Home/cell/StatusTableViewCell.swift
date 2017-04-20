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
    
    /// 转发按钮
    @IBOutlet weak var reposeBtn: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentBtn: UIButton!
    /// 点赞按钮
    @IBOutlet weak var likeBtn: UIButton!
    
    var viewModel: WBStatusViewModel? {
        didSet {
            iconView.setImage(urlString: viewModel?.status.user?.avatar_large, placeholder: #imageLiteral(resourceName: "avatar_default_big"))
            nameLabel.text = viewModel?.status.user?.screen_name
            timeLabel.text = viewModel?.status.created_at
            resourceLabel.text = viewModel?.status.source
            avatarIcon.image = viewModel?.avatarImage
            statusLabel.text = viewModel?.status.text
            reposeBtn.setTitle(viewModel?.repostStr, for: [])
            commentBtn.setTitle(viewModel?.commentStr, for: [])
            likeBtn.setTitle(viewModel?.likeStr, for: [])
            print(viewModel?.status.source)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
