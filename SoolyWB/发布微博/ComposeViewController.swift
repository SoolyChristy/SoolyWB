//
//  ComposeViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/23.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    /// toolBar与底部间距
    @IBOutlet weak var toolBarY: NSLayoutConstraint!
    
    lazy var emoticonView: EmoticonInputView = EmoticonInputView.inputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 监听键盘frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        setupUI()
    }

    // MARK: 关闭按钮监听方法
    @IBAction func closeBtnClick() {
        dismiss(animated: true)
    }
    
    // MARK: 发送按钮监听方法
    @IBAction func sendBtnClick() {
        // 将图片表情 => 文字 [哈哈]
        let string = WBEmoticonManager.shared.attributedStringToString(attributedString: textView.attributedText)
        
        NetWorkManager.shared.updateStatus(status: string) { (status, isSuccess) in
            guard let status = status else {
                return
            }
            print(status.text ?? "")
        }
        
        dismiss(animated: true)
    }
    
    /// 键盘监听方法
    @objc private func keyboardFrameChanged(notification: Notification) {
        
        guard let rect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        let offset = view.bounds.height - rect.origin.y
        // 更新工具栏约束
        self.toolBarY.constant = offset
        
        // 动画更新工具栏
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
        
    }
    
    /// 表情按钮监听方法
    @objc fileprivate func emoticonBtnClick() {
        
        // 设置键盘视图
        textView.inputView = emoticonView
        emoticonView.delegate = self
        
        // 刷新键盘视图
        textView.reloadInputViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: 设置界面
extension ComposeViewController {
    fileprivate func setupUI() {
        sendBtn.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        sendBtn.setImage(#imageLiteral(resourceName: "send"), for: .highlighted)
        sendBtn.setImage(#imageLiteral(resourceName: "send_disable"), for: .disabled)
        
        sendBtn.isEnabled = textView.hasText
        
        // 设置头像
        let urlStr = NetWorkManager.shared.userAccount.user?.avatar_large
        iconView.setImage(urlString: urlStr, placeholder: nil)
        // 圆形头像
        iconView.layer.cornerRadius = iconView.frame.width / 2
        iconView.layer.masksToBounds = true
    
        setToolBar()
    }
    
    private func setToolBar() {
        let itemsSettings = [["imageName": "compose_camerabutton_background"],
                             ["imageName": "compose_trendbutton_background"],
                             ["imageName": "compose_mentionbutton_background"],
                             ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonBtnClick"]]
        
        var items = [UIBarButtonItem]()
        for dic in itemsSettings {
            let btn = UIButton()
            
            guard let imageName = dic["imageName"] else {
                continue
            }
            
            btn.setImage(UIImage(named: imageName), for: [])
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
            
            if let actionName = dic["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            let item = UIBarButtonItem(customView: btn)
            items.append(item)
            
            // 追加弹簧距离
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
//        items.removeLast()
        
        toolBar.items = items
    }
}

// MARK: textView代理方法
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        sendBtn.isEnabled = textView.hasText
    }
}

// MARK: emoticonView代理方法
extension ComposeViewController: EmoticonInputViewDelegate {
    func emoticonViewDidSelectedDelButton() {
        print("删除")
    }
    
    func emoticonViewDidSelectedEmoticon(emoticon: WBEmoticon) {

        textView.insertEmoticon(emoticon: emoticon)
    }
    
    func emoticonViewDidSelectedKeyboardButton() {
        print("键盘")
    }
}
