//
//  WBFriend.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/7.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import HandyJSON

struct WBFriendList: HandyJSON {
    var users: [WBUserInfo]?
    
    /// 下一页编号
    var next_cursor: Int = 0
    /// 上一页编号
    var previous_cursor: Int = 0
    
//    required init() {}
}
