//
//  WBEmoticonManager.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/26.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class WBEmoticonManager {
    static let shared = WBEmoticonManager()
    /// 表情素材的bundle
    lazy var bundle: Bundle = {
       let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil)
        return Bundle(path: path!)!
    }()
    
    /// 表情包模型
    lazy var emoticonPackages = [WBEmoticonPackage]()
    
    private init() {
        loadEmoticonPackage()
    }
}

// MARK: 表情文本
extension WBEmoticonManager {
    /// 根据String 返回 表情属性文本
    func emoticonAttrubuteString(string: String, font: UIFont) -> NSAttributedString {
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(string: string))
        
        // [ ] 需要 转义 + \\
        let pattern = "\\[.*?\\]"
        guard let regularE = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrStrM
        }
        
        let matches = regularE.matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count))
        
        // 遍历 匹配结果 需要倒序遍历
        for m in matches.reversed() {
            let range = m.rangeAt(0)
            let subStr = (attrStrM.string as NSString).substring(with: range)

            // 根据查找结果 查找对应的表情模型 
            if let emoticonAttr = searchEmoticon(string: subStr, font: font) {
                // 将[表情]字符串替换 为表情图片
                attrStrM.replaceCharacters(in: range, with: emoticonAttr)
            }
            
        }
        return attrStrM
    }
    
    /// 表情属性文本 => 普通属性文本
    /// 上传到服务器
    func attributedStringToString(attributedString: NSAttributedString) -> String {
        var string = ""
        attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: []) { (dict, range, _) in
            
            // 如果字典中包含 NSAttachment `Key` 说明是图片，否则是文本
            // 下一个目标：从 attachment 中如果能够获得 chs 就可以了！
            if let attachment = dict["NSAttachment"] as? WBEmoticonAttachment {
                string += attachment.chs ?? ""
            }else {
                string += (attributedString.string as NSString).substring(with: range)
            }
        }
        
        return string
    }
    
    /// 根据String查找 表情模型的属性文本
    func searchEmoticon(string: String, font: UIFont) -> NSAttributedString? {
        var result = [WBEmoticon]()
        for package in emoticonPackages {
            result = package.emoticons.filter(){$0.chs == string}
            
            if result.count == 1 {
                return result[0].imageText(font: font)
            }
        }
        return nil
    }
}

extension WBEmoticonManager {
    
    /// 加载表情包数据
    fileprivate func loadEmoticonPackage() {
        
        // 获取emoticons.plist 里的数组
        guard let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
        let emoticonsArr = NSArray(contentsOfFile: plistPath) as? [[String: Any]] else {
                return
        }
        
        // 转模型
        for emoticonDic in emoticonsArr {
            let package = WBEmoticonPackage(dict: emoticonDic)
            emoticonPackages.append(package)
        }
    }
}
