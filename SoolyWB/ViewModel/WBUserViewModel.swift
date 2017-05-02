//
//  WBUserViewModel.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/2.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class WBUserViewModel {
    var user: WBUserInfo
    
    var avatarImage: UIImage?
    var sexImage: UIImage?
    var description: String
    var followTitle: String
    var starTitle: String
    
    init(model: WBUserInfo) {
        user = model
        description = "个人简介：\(user.description ?? "")"
        followTitle = "\(user.friends_count) 关注"
        starTitle = "\(user.followers_count) 粉丝"
        
        avatarImage = setupAvatarImage()
        sexImage = setupSexImage()
    }

}

extension WBUserViewModel {
    fileprivate func setupSexImage() -> UIImage? {
        switch user.gender ?? "" {
        case "m":
            return #imageLiteral(resourceName: "man")
        case "f":
            return #imageLiteral(resourceName: "woman")
        default:
            return nil
        }
    }
    
    /// 设置认证图片
    ///
    /// - Parameter type: 认证类型
    /// - Returns: 认证图片
    fileprivate func setupAvatarImage() -> UIImage? {
        
        let type = user.verified_type
        
        switch type {
        case -1:
            return nil
        case 0:
            return #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            return #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            return #imageLiteral(resourceName: "avatar_grassroot")
        default:
            return nil
        }
    }
}
