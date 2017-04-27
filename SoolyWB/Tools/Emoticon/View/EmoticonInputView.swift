//
//  EmoticonInputView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let cellID = "emotionCell"

protocol EmoticonInputViewDelegate: NSObjectProtocol {
    
}

class EmoticonInputView: UIView {

    weak var delegate: EmoticonInputViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: EmoticonToolBar!
   
    /// 点击表情回调
    var emoticonCallBack: ((_ emoticon: WBEmoticon) -> ())?
    
    /// 快速创建EmoticonInputView
    ///
    /// - Parameter emoticonClick: 点击表情回调
    ///
    class func inputView(emoticonClick: @escaping (_ emoticon: WBEmoticon) -> ()) -> EmoticonInputView {
        let v = Bundle.main.loadNibNamed("EmoticonInputView", owner: nil, options: nil)?[0] as! EmoticonInputView
        
        // 记录闭包
        v.emoticonCallBack = emoticonClick
        
        return v
    }

    override func awakeFromNib() {
        setupUI()
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
        // 执行回调
        emoticonCallBack?(emoticon)
    }
}
