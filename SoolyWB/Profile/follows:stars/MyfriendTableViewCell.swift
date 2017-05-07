//
//  MyfriendTableViewCell.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/7.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class MyfriendTableViewCell: UITableViewCell {

    var user: WBUserInfo? {
        didSet {
            iconView.setImage(urlString: user?.avatar_large, placeholder: #imageLiteral(resourceName: "avatar_default_big"))
            nameLabel.text = user?.screen_name ?? ""
            statusLabel.text = user?.status?.text ?? ""
            avatarIcon.image = user?.avatarImage
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: WBLabel!
    @IBOutlet weak var avatarIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
