//
//  MyfollowsViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/7.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let cellID = "friendCell"

class MyfollowsViewController: BasicViewController {

    var friendList: WBFriendList?
    lazy var friends: [WBUserInfo] = [WBUserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: 加载数据
extension MyfollowsViewController {
    override func loadData() {
        // 上拉刷新
        if pullUpView.isPullUp {
            NetWorkManager.shared.loadUserFollows(cursor: friendList?.next_cursor ?? 0, compeletion: { (list, isSuccess) in
                guard let list = list,
                let users = list.users else {
                    self.pullUpView.endRefreshing()
                    return
                }
                self.friendList = list
                self.friends += users
                
                self.pullUpView.endRefreshing()
                self.tableView.reloadData()
            })
            return
        }
        
        // 下拉刷新
        NetWorkManager.shared.loadUserFollows { (list, isSuccess) in
            guard let list = list, let users = list.users else {
                self.refreshControl.endRefreshing()
                return
            }
            self.friendList = list
            self.friends = users + self.friends
            
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

// MARK: 设置界面
extension MyfollowsViewController {
    override func setupUI() {
        super.setupUI()
        setTitleBtn(tilte: "我的关注")
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        tableView.register(UINib(nibName: "MyfriendTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellID)
    }
}

// MARK: tableView方法
extension MyfollowsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MyfriendTableViewCell
        cell.user = friends[indexPath.section]
        return cell
    }
}
