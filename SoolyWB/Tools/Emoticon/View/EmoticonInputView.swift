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
    func emoticonViewDidSelectedDelButton(isLongPress: Bool)
    /// 点击表情
    func emoticonViewDidSelectedEmoticon(emoticon: WBEmoticon)
}

class EmoticonInputView: UIView {

    weak var delegate: EmoticonInputViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBar: EmoticonToolBar!
    @IBOutlet weak var pageControl: UIPageControl!
    
    /// 快速创建EmoticonInputView
    class func inputView() -> EmoticonInputView {
        let v = Bundle.main.loadNibNamed("EmoticonInputView", owner: nil, options: nil)?[0] as! EmoticonInputView
        
        return v
    }

    override func awakeFromNib() {
        setupUI()
        
        // 记录工具条按钮点击闭包 (注意循环引用)
        toolBar.btnClickCallBack = { [weak self] (type) in
            switch type {
            case .keyboard:
                self?.delegate?.emoticonViewDidSelectedKeyboardButton()
            case .del:
                self?.delegate?.emoticonViewDidSelectedDelButton(isLongPress: false)
            case .delLongPress:
                self?.delegate?.emoticonViewDidSelectedDelButton(isLongPress: true)
            case .recent:
                self?.collectionViewScrollToSection(section: 0)
            case .nomal:
                self?.collectionViewScrollToSection(section: 1)
            case .lxh:
                self?.collectionViewScrollToSection(section: 3)
            }
        }
        
    }
    
    /// 滚动collectionView到指定组
    private func collectionViewScrollToSection(section: Int) {
        let indexPath = IndexPath(item: 0, section: section)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        // 设置分页控制器
        if section == 0 {
            pageControl.isHidden = true
        }else {
            pageControl.numberOfPages = collectionView.numberOfItems(inSection: section)
            pageControl.currentPage = 0
            pageControl.isHidden = false
        }
        
    }
}

// MARK: 设置界面
extension EmoticonInputView {
    fileprivate func setupUI() {
        setupCollectionView()
        setupPageControl()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    private func setupPageControl() {
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.color(hex: "#FC6A08")
        pageControl.isHidden = true
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView在屏幕的中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        // 获取正在显示的cell 的indexPath
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        /// 中心点在的cell
        var targetIndexPath: IndexPath?

        // 判断center在哪个cell中
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
        }
        
        guard let target = targetIndexPath else {
            return
        }
        
        let section = target.section
        toolBar.selectedSection = section
        
        // 设置 分页控制器
        switch section {
        case 0:
            pageControl.isHidden = true
        case 1, 2, 3:
            pageControl.numberOfPages = collectionView.numberOfItems(inSection: section)
            pageControl.currentPage = target.item
            pageControl.isHidden = false
        default:
            break
        }
        
    }
    
}

// MARK: EmoticonCell代理方法
extension EmoticonInputView: EmoticonCellDelegate {
    func emoticonClick(emoticon: WBEmoticon) {
        // 执行代理方法
        delegate?.emoticonViewDidSelectedEmoticon(emoticon: emoticon)
        
        // 添加表情到最近使用
        WBEmoticonManager.shared.addRecentEmoticon(emoticon: emoticon)
        
        // 刷新第0组
        var indexSet = IndexSet()
        indexSet.insert(0)
        collectionView.reloadSections(indexSet)
    }
}
