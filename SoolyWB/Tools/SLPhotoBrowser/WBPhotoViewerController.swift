//
//  WBPhotoViewerController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/8.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  负责展示

import UIKit

class WBPhotoViewerController: UIViewController {

    /// 中图url数组
    fileprivate let middlePicUrl: String
    /// 原图url数组
    fileprivate let largePicUrl: String
    /// 是否放大
    fileprivate var isEnlarge: Bool = false
    /// 图片索引
    let index: Int
    
    /// 图片原始尺寸
    fileprivate lazy var originalSize: CGSize = CGSize()
    
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()

    init(middlePic: String, largePic: String, index: Int){
        self.middlePicUrl = middlePic
        self.largePicUrl = largePic
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadImage()
    }

}

// MARK: 监听方法
extension WBPhotoViewerController {
    @objc fileprivate func taped() {
        dismiss(animated: true)
    }
    
    /// 双击监听
    @objc fileprivate func doubleTaped(recognizer: UITapGestureRecognizer) {
        let position = recognizer.location(in: imageView)
        
        if isEnlarge {
            if originalSize.height >= screenHeight {
                
                let y = position.y * originalSize.height / imageView.frame.height - screenHeight / 2
                var offsetY = y < 0 ? 0 : y
                let delta = originalSize.height - scrollView.frame.height
                offsetY = offsetY > delta ? delta : offsetY
                
                imageView.frame = CGRect(x: 0, y: 0, width: originalSize.width, height: originalSize.height)
                scrollView.contentSize = originalSize
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
            }else {
                imageView.frame.size = originalSize
                imageView.center = scrollView.center
                scrollView.contentSize = originalSize
                scrollView.contentOffset = CGPoint()

            }
            isEnlarge = false
        }else {
            let size = imageView.frame.size
            
            originalSize = size
            
            // 若图片高度 >= 屏幕高度 - 50
            if size.height >= screenHeight - 80 {
                let width = size.width * 2
                let height = width * size.height / size.width
                
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                scrollView.contentSize = imageView.frame.size
                
                let x = position.x * width / size.width - screenWidth / 2
                let offsetX = min(x < 0 ? 0 : x, width - screenWidth)
                
                let y = position.y * height / size.height - screenHeight / 2
                let offsetY = min(y < 0 ? 0 : y, height - screenHeight)
                
                scrollView.contentOffset = CGPoint(x: offsetX, y: offsetY)
                
            }else {
                // 放大后的宽度
                let width = size.width * screenHeight / size.height
                // 获取点击在imageView的位置
                let positionX = recognizer.location(in: imageView).x
                
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: screenHeight)
                scrollView.contentSize = imageView.frame.size
        
                let x = positionX * width / size.width - screenWidth / 2
                let offsetX = min(x < 0 ? 0 : x, width - screenWidth)
                
                scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
            }
            isEnlarge = true
        }
    }
    
    @objc fileprivate func longPressed() {
        let alertVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertVc.addAction(UIAlertAction(title: "保存图片", style: .default, handler: { _ in
            
        }))
        
        alertVc.addAction(UIAlertAction(title: "查看原图", style: .default, handler: { _ in
            
        }))
        
        alertVc.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            
        }))
        
        present(alertVc, animated: true)
    }
}


extension WBPhotoViewerController {
    fileprivate func loadImage() {
        imageView.setImage(urlString: largePicUrl, placeholder: nil) { (image) in
            guard let image = image else {
                return
            }
            self.setImageViewPosition(image: image)
        }
    }
    
    /// 设置imageView位置
    private func setImageViewPosition(image: UIImage) {
        // 规定图片宽度为屏幕宽度
        // 获取等比例的高度
        let height = screenWidth * image.size.height / image.size.width
        
        self.imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        
        // 若图片高度不满屏幕高度 居中显示
        if height < screenHeight {
            self.imageView.center = self.scrollView.center
        }
        
        self.scrollView.contentSize = self.imageView.frame.size
    }
}

extension WBPhotoViewerController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

// MARK: 设置界面
extension WBPhotoViewerController {
    fileprivate func setupUI() {
        scrollView.frame = view.bounds
        scrollView.bounces = false
        
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(taped))
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTaped(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        
        
        tap.require(toFail: doubleTap)
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(doubleTap)
        view.addGestureRecognizer(longPress)
    }
}
