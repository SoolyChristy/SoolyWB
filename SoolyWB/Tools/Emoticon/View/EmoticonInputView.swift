//
//  EmoticonInputView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let cellID = "emotionCell"

/// EmoticonInputView代理协议
protocol EmoticonInputViewDelegate: NSObjectProtocol {
    /// 点击键盘按钮
    func emoticonViewDidSelectedKeyboardButton()
    /// 点击退格按钮
    func emoticonViewDidSelectedDelButton()
    /// 点击表情
    func emoticonViewDidSelectedEmoticon(emoticon: WBEmoticon)
}

class EmoticonInputView: UIView {

    weak var delegate: EmoticonInputViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: EmoticonToolBar!
    
    /// 快速创建EmoticonInputView
    class func inputView() -> EmoticonInputView {
        let v = Bundle.main.loadNibNamed("EmoticonInputView", owner: nil, options: nil)?[0] as! EmoticonInputView
        
        return v
    }

    override func awakeFromNib() {
        setupUI()
        
        // 记录闭包 (注意循环引用)
        toolBar.btnClickCallBack = { [weak self] (type) in
            switch type {
            case .keyboard:
                self?.delegate?.emoticonViewDidSelectedKeyboardButton()
            case .del:
                self?.delegate?.emoticonViewDidSelectedDelButton()
            default:
                break
            }
        }
        
    }
    
}

// MARK: 设置界面
extension EmoticonInputView {
    fileprivate func setupUI() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: cellID)
    }
}

// MARK: collectionView代理方法、数据源方法
extension EmoticonInputView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WBEmoticonManager.shared.emoticonPackages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return WBEmoticonManager.shared.emoticonPackages[section].numberOfPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EmoticonCell
        
        cell.emoticons = WBEmoticonManager.shared.emoticonPackages[indexPath.section].emoticons(page: indexPath.item)
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: EmoticonCell代理方法
extension EmoticonInputView: EmoticonCellDelegate {
    func emoticonClick(emoticon: WBEmoticon) {
        // 执行代理方法
        delegate?.emoticonViewDidSelectedEmoticon(emoticon: emoticon)
    }
}
