//
//  Header.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

let appKey = "1593427755"
let appSecret = "2b473b02322fb48cdbfb3faf1285fff2"
/// 回调url
let redirect_uri = "https://www.baidu.com"

/// 登录成功通知
let loginSuccessful = "loginSuccessful"

let screenBounds = UIScreen.main.bounds
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

/// Documents目录
let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

let statusCellID = "statusCell"
let repostCellID = "repostCell"

// cell间隔背景颜色
let footerViewBgColor = UIColor.color(hex: "#efeff4")
/// section间距
let cellMargin: CGFloat = 8
/// 微博配图间距
let picMargin: CGFloat = 5
/// 配图视图 宽 高
let picWH = (screenWidth - 2 * picMargin - 2 * 12) / 3
/// 间距
let margin: CGFloat = 12

/// 原创微博字体
let originalTextFont = UIFont.systemFont(ofSize: 15)
/// 转发微博字体
let repostTextFont = UIFont.systemFont(ofSize: 14)

/// 微博橙色
let wbOrange = UIColor.color(hex: "#FC6A08")
/// 超链接文本颜色
let linkTextColor = UIColor.color(hex: "#4F7596")

/// 个人资料页头部视图高度
let profileHeaderViewHeight: CGFloat = 320
/// 背景图片默认高度
let bgImageHeight: CGFloat = 120
