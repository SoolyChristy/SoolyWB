//
//  WBStatus.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import HandyJSON

/// 微博模型
class WBStatus: HandyJSON{
    
    /// 微博创建时间
    var created_at: String?
    
    /// 微博ID
    var id: Int64 = 0
    
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 缩略图片地址，没有时不返回此字段
    var thumbnail_pic: String?
    /// 中等尺寸图片地址
    var bmiddle_pic: String?
    /// 原始图片地址
    var original_pic: String?
    /// 微博作者的用户信息字段
    var user: WBUserInfo?
    /// 被转发的原微博信息字段，当该微博为转发微博时返回
    var retweeted_status: WBStatus?
    /// 转发数
    var reposts_count: Int = 0
    /// 评论数
    var comments_count: Int = 0
    /// 点赞数
    var attitudes_count: Int = 0
    /// 图片模型数组
    var pic_urls: [picturesModel]?
    
    required init() {}

}

/// 图片模型
struct picturesModel: HandyJSON {
    /// 缩略图
    var thumbnail_pic: String? {
        didSet {
            large_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    /// 原图
    var large_pic: String?
    
//    required init() {}
    
}
