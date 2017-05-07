//
//  textViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/30.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    lazy var webView: UIWebView = UIWebView()
    var urlStr: String?
    
    lazy var backBtn: UIButton = UIButton()
    lazy var closeBtn: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8) {
            self.navigationController?.navigationBar.isHidden = false
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.hidesBackButton = false
    }
}

// MARK: 监听方法
extension WebViewController {
    @objc fileprivate func backBtnClick() {
        if webView.canGoBack {
            webView.goBack()
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func closeBtnClick() {
        navigationController?.popViewController(animated: true)
    }
}

extension WebViewController {
    fileprivate func setupUI() {
        navigationItem.hidesBackButton = true
        
        setupBackBtn()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        automaticallyAdjustsScrollViewInsets = false
        setupWebView()
        
    }
    
    fileprivate func setupBackBtn() {
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.setImage(#imageLiteral(resourceName: "back_highlighted"), for: .highlighted)
        
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        
        backBtn.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)

    }
    
    fileprivate func setupCloseBtn() {
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.setTitleColor(UIColor.black, for: .normal)
        closeBtn.setTitleColor(wbOrange, for: .highlighted)
        
        closeBtn.sizeToFit()
        
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backBtn), UIBarButtonItem(customView: closeBtn)]

    }
    
    fileprivate func setupWebView() {
        view.addSubview(webView)
        webView.frame = CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64)
        webView.delegate = self
        webView.backgroundColor = UIColor.white
        
        (webView.subviews[0] as? UIScrollView)?.bounces = false
        
        guard let urlStr = urlStr,
            let url = URL(string: urlStr) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 如果webView可以返回 添加关闭按钮
        if webView.canGoBack {
            setupCloseBtn()
        }
    }
}
