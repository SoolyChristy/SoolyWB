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
    
    var alamoManager: SessionManager?
    
    private init() {
        setupAlamofire()
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
    func loadStatuses(sinceID: Int64,
                      maxID: Int64,
                      compeletion: @escaping (_ Statues: [WBStatusViewModel]?, _ isSuccess: Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        guard let accessToken = userAccount.access_token else {
            print("请求微博数据失败！ - toke为空")
            compeletion(nil, false)
            return
        }
        
        let param = ["access_token": accessToken,
                     "since_id": sinceID,
                     "max_id": maxID] as [String : Any]
        
        request(urlString: urlString, method: .GET, parameters: param) { (json, isSuccess) in
            if isSuccess {
                
                // 将JSON字典数组 => 模型数组
                var statusVMs = [WBStatusViewModel]()
                guard let statusesArr = json?["statuses"] as? [NSDictionary] else {
                    compeletion(nil, false)
                    print("请求成功，但微博数据为空！原因：当日微博API调取已达上限，明日重置")
                    return
                }
                for statusDic in statusesArr {
                    let status = WBStatus.deserialize(from: statusDic)
                    if let status = status {
                        
                        // 微博模型 => 微博视图模型
                        let statusVM = WBStatusViewModel(model: status)
                        
                        statusVMs.append(statusVM)
                    }
                }
                
                print("刷新到\(statusVMs.count)条数据")
                
                compeletion(statusVMs, true)
                
            } else {
                
                compeletion(nil, false)
                print("获取微博数据失败！")
            }
        }
    }
    
    
    /// 根据ID请求用户微博 若无id则请求当前用户微博
    ///
    /// - Parameters:
    ///   - uid: 请求用户ID
    ///   - compeletion: 完成回调
    func loadUserStatuses(uid: String? = nil,
                          sinceID: Int64,
                          maxID: Int64,
                          compeletion: @escaping (_ statuses: [WBStatusViewModel]?, _ isSuccess: Bool) -> ()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/user_timeline.json"
        var parameters: [String: Any] = ["access_token": userAccount.access_token ?? "",
                                         "since_id": sinceID,
                                         "max_id": maxID]
        
        if let uid = uid {
            parameters = ["access_token": userAccount.access_token ?? "",
                          "uid": uid,
                          "since_id": sinceID,
                          "max_id": maxID]
        }
        
        request(urlString: urlStr, method: .GET, parameters: parameters) { (json, isSuccess) in
            if isSuccess {
                guard let statusArr = json?["statuses"] as? [NSDictionary] else {
                    compeletion(nil, false)
                    print("请求成功，但微博数据为空！")
                    return
                }
                
                var statusViewModels = [WBStatusViewModel]()
                
                for dic in statusArr {
                    if let status = WBStatus.deserialize(from: dic) {
                        let vm = WBStatusViewModel(model: status)
                        statusViewModels.append(vm)
                    }
                }
                
                compeletion(statusViewModels, true)
            } else {
                print("微博请求失败！")
                compeletion(nil, false)
            }
        }
    }
    
    /// 发布一条纯文本微博
    ///
    /// - Parameters:
    ///   - status: 微博内容
    ///   - compeletion: 完成回调(微博模型，是否成功)
    func updateStatus(status: String, compeletion: @escaping (_ status: WBStatus?, _ isSuccess: Bool) -> ()) {
        
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        let parameters = ["access_token": userAccount.access_token ?? "",
                          "status": status]
        
        request(urlString: urlStr, method: .POST, parameters: parameters) { (json, isSuccess) in
            guard let dic = json as NSDictionary? else {
                print("发布微博失败！")
                compeletion(nil, false)
                return
            }
            let status = WBStatus.deserialize(from: dic)
            
            compeletion(status, true)
            
        }
    }
    
    /// 请求用户关注列表
    ///
    /// - Parameters:
    ///   - cursor: 返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。
    ///   - compeletion: 完成回调
    func loadUserFollows(cursor: Int = 0, compeletion: @escaping (_ list: WBFriendList?, _ isSuccess: Bool) -> ()) {
        
        let urlStr = "https://api.weibo.com/2/friendships/friends.json"
        let parameters = ["access_token": userAccount.access_token ?? "",
                          "cursor": cursor] as [String : Any]
        
        request(urlString: urlStr, method: .GET, parameters: parameters) { (json, isSuccess) in
            guard let dic = json as NSDictionary? else {
                print("请求用户关注列表数据为空！")
                compeletion(nil, false)
                return
            }
            let list = WBFriendList.deserialize(from: dic)
            print("请求到\(list?.users?.count ?? 0)条数据")
            compeletion(list, true)
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
            
            guard let json = json as NSDictionary? else {
                print("AccessToken为空")
                compeletion(false)
                return
            }
            print("授权登录信息 - \(json)")
            
            // 利用HandyJSON 转模型
            self.userAccount = WBUserAccount.deserialize(from: json) ?? WBUserAccount()
            self.userAccount.expiredDate = Date(timeIntervalSinceNow: self.userAccount.expires_in)
            
            compeletion(true)
        }
        
    }
}

// MARK: 封装Alamofire
extension NetWorkManager {
    
    fileprivate func setupAlamofire() {
        let config = URLSessionConfiguration.default
        // 设置超时时间 s
        config.timeoutIntervalForRequest = 15
        
        alamoManager = SessionManager(configuration: config)
    }
    
    /// 隔离Alamofire GET/POST 方法
    ///
    /// - Parameters:
    ///   - urlString: url
    ///   - method: HTTPMethod
    ///   - parameters: 参数字典
    ///   - compeletion: 完成回调(json：返回数据, isSuccese: 请求是否成功)
    func request(urlString: String,
                 method: WBHTTPMethod,
                 parameters: [String: Any]?,
                 compeletion: @escaping (_ json: [String: Any]?, _ isSuccese: Bool) -> ()) {
        
        var m: HTTPMethod
        if method == .GET {
            m = .get
        } else {
            m = .post
        }

        alamoManager?.request(urlString, method: m, parameters: parameters).responseJSON(completionHandler: { (response) in
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
