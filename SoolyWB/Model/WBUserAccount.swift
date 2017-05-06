//
//  WBUserAccount.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import HandyJSON

/// 用户账户存储路径
private let userAccountPath = docPath + "/userAccount.json"

/// 登录用户模型
class WBUserAccount: HandyJSON {
    /// 令牌
    var access_token: String?
    /// 令牌生命周期
    var expires_in: TimeInterval = 0
    /// 用户ID
    var uid: String?
    /// 账号信息
    var user: WBUserInfo?
    /// 令牌过期时间
    var expiredDate: Date?
    
    required init() {}
    
    /// 从沙盒读取用户信息 没有则返回空
    class func userAccount() -> WBUserAccount {

        guard let dic = NSDictionary(contentsOfFile: userAccountPath),
            let userAccount = WBUserAccount.deserialize(from: dic) else {
                return WBUserAccount()
        }
        print("令牌过期时间 - \(userAccount.expiredDate?.description ?? "")")
        
        // 判断令牌是否过期
        if userAccount.expiredDate?.compare(Date()) != .orderedDescending {
            
            print("账户过期！")
            
            // 删除沙盒缓存
            try? FileManager.default.removeItem(atPath: userAccountPath)
            
            // 直接返回空模型
            return WBUserAccount()
        }
        
        return userAccount
    }
    
    /// 存储用户账户信息
    func save() {
        // 序列化 模型 => 字典
        var dic = self.toJSON() ?? [:]
        dic["expiredDate"] = self.expiredDate
        
        // 去除不需要的信息
        dic.removeValue(forKey: "expires_in")
        dic.removeValue(forKey: "user")
        
        // 存入沙盒
        (dic as NSDictionary).write(toFile: userAccountPath, atomically: true)
        print("存储用户账户 - \(userAccountPath)")
    }
    
}

/// 用户数据模型
struct WBUserInfo: HandyJSON {
    /// id
    var idstr: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户所在地
    var location: String?
    
    /// 个人简介
    var description: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    /// 用户头像地址（高清），高清头像原图
    var avatar_hd: String?
    /// 性别，m：男、f：女、n：未知
    var gender: String?
    /// 粉丝数
    var followers_count: Int = 0
    /// 关注数
    var friends_count: Int = 0
    /// 微博数
    var statuses_count: Int = 0
    /// 用户创建（注册）时间
    var created_at: String?
    /// 是否是微博认证用户，即加V用户，true：是，false：否
    var verified: String?
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1
    
    var avatarImage: UIImage? {
        let type = verified_type
        
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
//    required init() {}
    
}
