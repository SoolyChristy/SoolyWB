//
//  LoginViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import HandyJSON
import PKHUD

class LoginViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        
        webView.scrollView.isScrollEnabled = false
        
        webView.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "登录"
        
        // 创建URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirect_uri)"
        guard let url = URL(string: urlStr) else {
            return
        }
        
        // 创建请求
        let request = URLRequest(url: url)
        
        // 加载请求
        webView.loadRequest(request)
    }
}

// MARK: UIWebViewDelegate
extension LoginViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        HUD.hide()
        // 自动填充
        // 准备 js
        let js = "document.getElementById('userId').value = '13007157719'; " +
        "document.getElementById('passwd').value = 'WSL1995';"
        //        let js = "document.getElementById('userId').value = 'm13080602718@sina.com'; " +
        //        "document.getElementById('passwd').value = 'm13080602718';"
        
        // 让 webview 执行 js
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 若是回调网页则不加载
        if request.url?.absoluteString.hasPrefix(redirect_uri) == false {
            return true
        }
        
        // query 就是 URL 中 `?` 后面的所有部分
        // 若回调网页中的query没有code则授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            print("授权失败")
            return false
        }

        // 取code
        guard let code = request.url?.query?.substring(from: "code=".endIndex) else {
            print("code获取失败")
            return false
        }
        print("code - \(code)")
        
        // 获取AccessToken
        NetWorkManager.shared.getAccessToken(code: code) { (isSuccess) in
            if isSuccess {
                // 登录成功 发送通知
                NotificationCenter.default.post(name: Notification.Name(rawValue: loginSuccessful), object: nil)
            }
        }
        
        self.dismiss(animated: true) {
            HUD.hide()
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        HUD.show(.progress)
    }
    
}
