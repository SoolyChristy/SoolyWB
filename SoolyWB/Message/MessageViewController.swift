//
//  MessageViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/26.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let messageNomalCell = "messageNomalCell"
private let messageCell = "messageCell"

class MessageViewController: BasicViewController {

    var info = ["@我的", "评论", "赞我的", "未关注人的消息"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

extension MessageViewController {
    override func setupUI() {
        super.setupUI()
        titleBtn.setTitle(title: "消息")
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: messageNomalCell)
        tableView.register(UINib(nibName: "MyfriendTableViewCell", bundle: nil), forCellReuseIdentifier: messageCell)
        tableView.separatorStyle = .singleLine
    }
}

extension MessageViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return info.count
        } else {
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageNomalCell, for: indexPath)
            cell.textLabel?.text = info[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 19)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath) as! MyfriendTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 73
        }
    }
}
