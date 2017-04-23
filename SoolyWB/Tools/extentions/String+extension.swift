//
//  String+extension.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/21.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import Foundation

extension String {
    
    /// 匹配<a href>中 url 和 文字
    ///
    /// - Returns: link: 链接 text: 文字
    func a_href() -> (link: String, text: String)? {
        /// 匹配方案 
        /// "source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>",
        /// (.*?) 表示 关心括号内容且找到一个直接停止     (.*) 表示 关心括号内容 一直找到结束
        /// .*? 表示 不关心内容
        let patten = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        // 创建正则表达式
        guard let regx = try? NSRegularExpression(pattern: patten, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.characters.count)) else{
                return nil
        }
        
        // 获取结果
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return (link, text)
    }
}
