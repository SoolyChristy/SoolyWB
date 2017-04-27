//
//  WBEmoticonModel.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/26.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import HandyJSON

/// 表情包模型
class WBEmoticonPackage: NSObject {
    /// 分组名称
    var groupName: String?
    var bgImageName: String?
    
    /// 表情页数
    var numberOfPage: Int = 1
    
    /// 表情包路径
    var directory: String? {
        didSet {

            if let directory = directory,
                let bundlePath = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: bundlePath),
                let EmoticonPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let emoticonArr = NSArray(contentsOfFile: EmoticonPath) as? [NSDictionary] {
                for dic in emoticonArr {
                    // 转模型
                    var emoticon = WBEmoticon.deserialize(from: dic) ?? WBEmoticon()
                    emoticon.directory = directory
                    
                    emoticons.append(emoticon)
                }
                
                // 每页 21 个表情 计算页数
                numberOfPage = (emoticons.count - 1) / 21 + 1
            }
        }
    }
    
    /// 表情模型
    var emoticons = [WBEmoticon]()
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    /// 从懒加载的表情包中，按照 page 截取最多 20 个表情模型的数组
    /// 例如有 26 个表情
    /// page == 0，返回 0~19 个模型
    /// page == 1，返回 20~25 个模型
    func emoticons(page: Int) -> [WBEmoticon] {
        
        let count = 21
        let location = count * page
        var length = 21
        
        // 防止越界
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        
        return (emoticons as NSArray).subarray(with: NSRange(location: location, length: length)) as! [WBEmoticon]
    }
}

/// 表情模型
struct WBEmoticon: HandyJSON {
    /// 表情类型 0：图片  1：emoji
    var type: String?
    /// 中文标识
    var chs: String?
    /// emoji 16进制编码
    var code: String?
    /// 图片名称
    var png: String?
    /// 表情目录
    var directory: String?
    
    /// 表情图片
    var image: UIImage? {
        if let directory = directory,
            let bundlePath = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: bundlePath) {
            return UIImage(named: "\(directory)/\(png ?? "")", in: bundle, compatibleWith: nil)
        }
        return nil
    }
    
    /// 16进制编码 => emoji
    func getEmoji() -> String? {
        
        guard let code = code else {
            return nil
        }
        
        let scanner = Scanner(string: code)
        
        var result: UInt32 = 0
        scanner.scanHexInt32(&result)
        let emoji = String(Character(UnicodeScalar(result)!))
        
        return emoji
    }
    
    /// 表情的属性文本
    func imageText(font: UIFont) -> NSAttributedString {
        
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        // 附件
        let attachment = WBEmoticonAttachment()
        attachment.image = image
        attachment.chs = chs
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        let attr = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        // 设置字体属性
        attr.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: 1))
        
        return attr
    }
    
}
