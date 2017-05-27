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
    var source: String?
    /// 微博发布时间
    var time: String?
    
    /// 认证图片
    var avatarImage: UIImage?
    
    /// 图片url数组
    var picUrls: [picturesModel]? {
        
        if status.retweeted_status == nil {
            return status.pic_urls
        } else {
            return status.retweeted_status?.pic_urls
        }
    }
    
    /// 正文属性文本
    var textAttributedStr: NSAttributedString?
    /// 转发属性文本
    var repostTextAttr: NSAttributedString?
    
    /// 图片视图高度
    var picViewHeight: CGFloat?
    /// 行高
    var rowHeight: CGFloat?
    
    init(model: WBStatus) {
        
        status = model
        
        repostStr = model.reposts_count == 0 ? "转发" : "\(model.reposts_count)"
        commentStr = model.comments_count == 0 ? "评论" : "\(model.comments_count)"
        likeStr = model.attitudes_count == 0 ? "" : "\(model.attitudes_count)"
        
        // 根据模型数据 设置来源
        source = setupSource()
        
        // 根据模型数据 设置时间文本
        time = setupTime()
        
        // 根据模型数据 设置认证图标
        avatarImage = self.setupAvatarImage()
        
        // 计算图片视图高度
        picViewHeight = setupPicViewHeight()
        
        // 正文属性文本
        textAttributedStr = setupTextAttributedString(string: model.text, font: originalTextFont)
        
        // 转发属性文本
        if let repostStr = model.retweeted_status?.text {
            let string = "@\(model.retweeted_status?.user?.screen_name ?? ""):\(repostStr)"
            repostTextAttr = setupTextAttributedString(string: string, font: repostTextFont)
        }
        
        // 计算行高
        rowHeight = setupRowHeight()

    }
}

extension WBStatusViewModel {
    
    /// 根据服务器传回的日期格式转为目标格式
    /// 示例： Tue May 31 17:46:55 +0800 2011
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    func setupTime() -> String {
        
        /// 日期格式器
        let dateFomatter = DateFormatter()
        dateFomatter.locale = Locale(identifier: "en_US_POSIX")
        dateFomatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        dateFomatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        /// 微博发布日期
        guard let creatDate = dateFomatter.date(from: status.created_at ?? "") else {
            return ""
        }

        /// 当前日历对象
        let calendar = Calendar.current
        
        // 判断日期是否是今天
        if calendar.isDateInToday(creatDate) {
            /// 微博创建时间与此时的时间差(秒) 负数
            let delta = -Int(creatDate.timeIntervalSinceNow)
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
                let m: Int = delta / 60
                return "\(m)分钟前"
            }
            
            let h: Int = delta / 3600
            return "\(h)小时前"
        }
        
        var fmt = "HH:mm"
        
        if calendar.isDateInYesterday(creatDate) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd HH:mm"
            let year = calendar.component(.year, from: creatDate)
            let thisYear = calendar.component(.year, from: Date())
            
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        
        dateFomatter.dateFormat = fmt
        
        return dateFomatter.string(from: creatDate)
        
    }
    
    func setupSource() -> String {
        let source = "来自 " + (status.source?.a_href()?.text ?? "")
        return source
    }
    
    /// 设置认证图片
    ///
    /// - Parameter type: 认证类型
    /// - Returns: 认证图片
    func setupAvatarImage() -> UIImage? {
        
        let type = status.user?.verified_type ?? 0
        
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
    
    /// 设置文字属性文本
    func setupTextAttributedString(string: String?, font: UIFont) -> NSAttributedString? {
        guard let string = string else {
            return nil
        }
        
        return WBEmoticonManager.shared.emoticonAttrubuteString(string: string, font: font)
    }
}

// MARK: 计算高度
extension WBStatusViewModel {
    
    /// 计算图片视图的高度
    func setupPicViewHeight() -> CGFloat {
        guard let picCount = picUrls?.count else {
            return 0
        }
        
        if picCount == 0 {
            return 0
        }
        
        if picCount < 4 {
            return picWH + margin
        }
        
        if picCount < 7 {
            return picWH * 2 + picMargin + margin
        } else {
            return picWH * 3 + 2 * picMargin + margin
        }

    }
    
    // 计算行高
    func setupRowHeight() -> CGFloat {
        let iconH: CGFloat = 34
        var height: CGFloat = 0
        /// 正文文本size 如果使用原始宽度 可能计算不准确，需要减 5 或者 10
        let textViewSize = CGSize(width: screenWidth - 2 * margin - 5, height: CGFloat(MAXFLOAT))
        
        // 顶部高度
        height = iconH + 2 * margin
        
        // 微博正文高度
        if status.text != nil {
            let l = WBLabel()
            l.attributedText = textAttributedStr
            l.numberOfLines = 0
            l.font = UIFont.systemFont(ofSize: 15)
            let textH = ceil(l.sizeThatFits(textViewSize).height) + 1
            
            height += textH
        }
//        if let textAttr = textAttributedStr {
//            let h = textAttr.boundingRect(with: textViewSize, options: .usesLineFragmentOrigin, context: nil).height
//            print("\(status.user?.screen_name ?? "")正文 - \(h)")
//            height += h
//        }
        
        // 间距
        height += margin
        
        // 如果有转发微博
        if status.retweeted_status != nil {
            height += margin
            
            // 转发文本
            let l = WBLabel()
            l.attributedText = repostTextAttr
            l.numberOfLines = 0
            l.font = UIFont.systemFont(ofSize: 14)
            //            l.lineBreakMode = .byTruncatingTail
            let textH = ceil(l.sizeThatFits(textViewSize).height) + 1

            height += textH
            
            height += margin
        }
//        if let repostAttr = repostTextAttr {
//            let h = repostAttr.boundingRect(with: textViewSize, options: .usesLineFragmentOrigin, context: nil).height
//            print("\(status.retweeted_status?.user?.screen_name ?? "")转发 - \(h)")
//            height += h
//        }
        
        // 配图
        if picUrls?.count != 0 && picUrls?.count != nil {
            height += picViewHeight ?? 0
        }
        
        // 工具条
        height += 35
        
        return height
    }
}
