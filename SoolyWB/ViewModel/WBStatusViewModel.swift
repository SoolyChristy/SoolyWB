//
//  WBStatusViewModel.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/20.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

/// 单条微博的视图模型
class WBStatusViewModel {
    var status: WBStatus
    
    /// 转发数量文本
    var repostStr: String
    /// 评论数量文本
    var commentStr: String
    /// 点赞数量文本
    var likeStr: String
    /// 微博来源
    var source: String
    /// 微博发布时间
    var time: String
    
    /// 认证图片
    var avatarImage: UIImage?
    
    init(model: WBStatus) {
        
        status = model
        
        repostStr = model.reposts_count == 0 ? "转发" : "\(model.reposts_count)"
        commentStr = model.comments_count == 0 ? "评论" : "\(model.comments_count)"
        likeStr = model.attitudes_count == 0 ? "赞" : "\(model.attitudes_count)"
        source = setupSource(str: model.source)
        
        avatarImage = setupAvatarImage(model.user?.verified_type ?? -1)
    }
}

extension WBStatusViewModel {
    
    func setupTime() {
        
    }
    
    func setupSource(str: String?) -> String {
        return str ?? ""
    }
    
    /// 设置认证图片
    ///
    /// - Parameter type: 认证类型
    /// - Returns: 认证图片
    func setupAvatarImage(_ type: Int) -> UIImage? {
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
