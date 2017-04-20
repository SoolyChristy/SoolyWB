//
//  NetWorkManager.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import Foundation
import Alamofire

enum WBHTTPMethod {
    case POST
    case GET
}

class NetWorkManager {
    /// 单例
    static let shared: NetWorkManager = NetWorkManager()
    /// 用户模型
    lazy var userAccount: WBUserAccount = WBUserAccount.userAccount()
    /// 用户是否登录
    var isUserLogin: Bool {
        return userAccount.access_token != nil
    }
}

// MARK: 微博相关方法
extension NetWorkManager {
    /// 获取登录用户信息
    func getUserInfo() {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        guard let accessToken = userAccount.access_token,
        let uid = userAccount.uid
            else {
            return
        }
        let param = ["access_token": accessToken,
                     "uid": uid]
        
        request(urlString: urlString, method: .GET, parameters: param) { (json, isSuccess) in
            if let json = json as NSDictionary? {
                
                // 利用HandyJSON json数据转模型
                self.userAccount.user = WBUserInfo.deserialize(from: json)
                print("当前登录用户 - \(self.userAccount.user?.screen_name ?? "")")
                
                // 保存用户账户信息
                self.userAccount.save()
            }
        }
    }
    
    /// 获取当前登录用户及其所关注（授权）用户的最新微博
    ///
    /// - Parameters:
    ///   - sinceID: since_id 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - maxID: max_id 返回ID小于或等于max_id的微博，默认为0
    /// - 默认返回20条 微博模型数组
    func loadStatuses(sinceID: Int64, maxID: Int64, compeletion: @escaping (_ Statues: [WBStatus]?, _ isSuccess: Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        guard let accessToken = userAccount.access_token else {
            return
        }
        

        let param = ["access_token": accessToken,
                     "since_id": sinceID,
                     "max_id": maxID] as [String : Any]
        
        request(urlString: urlString, method: .GET, parameters: param) { (json, isSuccess) in
            if isSuccess {
                
                // 将JSON字典数组 => 模型数组
                var statuses = [WBStatus]()
                guard let statusesArr = json?["statuses"] as? [NSDictionary] else {
                    return
                }
                for statusDic in statusesArr {
                    let status = WBStatus.deserialize(from: statusDic)
                    if let status = status {
                        statuses.append(status)
                    }
                }
                
                print("刷新到\(statuses.count)条数据！")
                
                compeletion(statuses, true)
                
            } else {
                
                compeletion(nil, false)
                print("获取微博数据失败！")
            }
        }
    }
}

// MARK: OAuth授权相关方法
extension NetWorkManager {
    /// 获取AccessToken
    func getAccessToken(code: String, compeletion: @escaping (_ isSuccess: Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id": appKey,
                          "client_secret": appSecret,
                          "grant_type": "authorization_code",
                          "code": code,
                          "redirect_uri": redirect_uri]
        
        request(urlString: urlString, method: .POST, parameters: parameters) { (json, isSuccess) in
            
            compeletion(isSuccess)
            
            guard let json = json as NSDictionary? else {
                print("AccessToken为空")
                return
            }
            print("授权登录信息 - \(json)")
            
            // 利用HandyJSON 转模型
            self.userAccount = WBUserAccount.deserialize(from: json) ?? WBUserAccount()
            self.userAccount.expiredDate = Date(timeIntervalSinceNow: self.userAccount.expires_in)
            
            // 登录成功后立即获取登录用户信息
            self.getUserInfo()
        }
    }
}

// MARK: 封装Alamofire
extension NetWorkManager {
    
    /// 隔离Alamofire GET/POST 方法
    ///
    /// - Parameters:
    ///   - urlString: url
    ///   - method: HTTPMethod
    ///   - parameters: 参数字典
    ///   - compeletion: 完成回调(json：返回数据, isSuccese: 请求是否成功)
    func request(urlString: String, method: WBHTTPMethod, parameters: [String: Any]?, compeletion: @escaping (_ json: [String: Any]?, _ isSuccese: Bool) -> ()) {
        
        var m: HTTPMethod
        if method == .GET {
            m = .get
        } else {
            m = .post
        }
        
        Alamofire.request(urlString, method: m, parameters: parameters).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let json):
                
                compeletion(json as? [String : Any], true)
                
            case .failure(let error):
                print("网络请求错误 - \(error)")
                
                compeletion(nil, false)
            }
        })
    }

}
