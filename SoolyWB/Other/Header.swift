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

let screenBounds = UIScreen.main.bounds
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

/// Documents目录
let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

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
