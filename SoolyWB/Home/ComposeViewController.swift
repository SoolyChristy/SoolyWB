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
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func closeBtnClick() {
        dismiss(animated: true)
    }
    
    @IBAction func sendBtnClick() {
        
    }
}

extension ComposeViewController {
    fileprivate func setupUI() {
        sendBtn.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        sendBtn.setImage(#imageLiteral(resourceName: "send"), for: .highlighted)
        sendBtn.setImage(#imageLiteral(resourceName: "send_disable"), for: .disabled)
    }
}
