//
//  textViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/30.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var urlStr: String?
    
    lazy var webView: WKWebView = WKWebView()
    lazy var backBtn: UIButton = UIButton()
    lazy var closeBtn: UIButton = UIButton()
    lazy var progressView: UIProgressView = UIProgressView(progressViewStyle: .default)
    
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
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            
            if progress == 0 {
                progressView.isHidden = false
            }
            
            self.progressView.setProgress(progress, animated: true)
            
            if progress == 1.0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.progressView.isHidden = true
                    self.progressView.progress = 0
                })
            }

        }
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
        
        setupProgressView()
        
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

        webView.backgroundColor = UIColor.white
        
        webView.navigationDelegate = self
        
        (webView.subviews[0] as? UIScrollView)?.bounces = false
        
        // 添加KVO监听进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [], context: nil)
        
        guard let urlStr = urlStr,
            let url = URL(string: urlStr) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    fileprivate func setupProgressView() {
        progressView.frame = CGRect(x: 0, y: 41.5, width: screenWidth, height: 0)
        progressView.tintColor = wbOrange
        progressView.trackTintColor = UIColor.clear
        navigationController?.navigationBar.addSubview(progressView)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 如果webView可以返回 添加关闭按钮
        if webView.canGoBack {
            DispatchQueue.main.async {
                self.setupCloseBtn()
            }
        }
    }
}
