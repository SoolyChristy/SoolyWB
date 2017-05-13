//
//  WBPhotoBroswerController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/8.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  负责交互

import UIKit

class WBPhotoBroswerController: UIViewController {

    fileprivate var index: Int = 0
    fileprivate let middlePics: [String]
    fileprivate let largePics: [String]
    
    lazy var pageControl: UIPageControl = UIPageControl()
    
    init(index: Int, middlePics: [String], largePics: [String]) {
        self.index = index
        self.middlePics = middlePics
        self.largePics = largePics
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @objc fileprivate func didTaped() {
        dismiss(animated: true)
    }
}

// MARK: 分页控制器数据源方法
extension WBPhotoBroswerController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var currentIndex = (viewController as! WBPhotoViewerController).index
        
        if currentIndex >= middlePics.count - 1 {
            return nil
        }
        currentIndex += 1
        
        return WBPhotoViewerController(middlePic: middlePics[currentIndex], largePic: largePics[currentIndex], index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var currentIndex = (viewController as! WBPhotoViewerController).index
        
        if currentIndex <= 0 {
            return nil
        }
        currentIndex -= 1
        
        return WBPhotoViewerController(middlePic: middlePics[currentIndex], largePic: largePics[currentIndex], index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let vc = pageViewController.viewControllers![0] as! WBPhotoViewerController
            pageControl.currentPage = vc.index
        }
    }
}

// MARK: 设置界面
extension WBPhotoBroswerController {
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.black
        
        // 分页控制器
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: cellMargin])
        
        // 添加分页控制器的自控制器
        let viewer = WBPhotoViewerController(middlePic: middlePics[index], largePic: largePics[index], index: index)
        pageController.setViewControllers([viewer], direction: .forward, animated: false)
        
        view.addSubview(pageController.view)
        // 添加子控制器 保证响应者链条不会被打断
        addChildViewController(pageController)
        
        pageController.didMove(toParentViewController: self)
        
        // 添加分页控制器的手势
        view.gestureRecognizers = pageController.gestureRecognizers
        
        pageController.dataSource = self
        pageController.delegate = self
        
        pageControl.center = CGPoint(x: view.center.x, y: screenHeight - 60)
        pageControl.tintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.numberOfPages = middlePics.count
        pageControl.currentPage = index
        
        view.addSubview(pageControl)

    }
}
