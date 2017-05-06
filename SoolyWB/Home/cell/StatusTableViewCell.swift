//
//  StatusTableViewCell.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/20.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    weak var vc: BasicViewController?
    
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
    @IBOutlet weak var statusLabel: WBLabel!
    /// 配图视图
    @IBOutlet weak var picView: StatusPicView!
    /// 工具栏
    @IBOutlet weak var toolBar: toolBarView!
    /// 被转发文本
    @IBOutlet weak var repostLabel: WBLabel!
    
    
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
            
            statusLabel.delegate = self
            
            // 设置转发微博
            if let repostAttr = viewModel?.repostTextAttr {
                repostLabel.delegate = self
                repostLabel.attributedText = repostAttr
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}

extension StatusTableViewCell: WBLabelDelegate {
    func labelDidSelectedLink() {
        let vv = textViewController()
        
        vc?.navigationController?.pushViewController(vv, animated: true)
    }
    
    func labelDidSelectedAt() {
        vc?.navigationController?.pushViewController(BasicViewController(), animated: true)
    }
    
    func labelDidSelectedTopic() {
        vc?.navigationController?.pushViewController(BasicViewController(), animated: true)
    }
}
