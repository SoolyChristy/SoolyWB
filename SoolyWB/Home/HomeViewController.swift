//
//  HomeViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let reuseID = "nomal"

class HomeViewController: BasicViewController {

    lazy var statuses = [WBStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: 加载数据
extension HomeViewController {
    override func loadData() {
        
        // 如果是上拉刷新
        if isPullUp {
            // 设置maxID
            let maxID = statuses.last?.id ?? 0
            NetWorkManager.shared.loadStatuses(sinceID: 0, maxID: maxID, compeletion: { (statuses, isSuccess) in

                guard let statuses = statuses else {
                    print("微博数据为空")
                    return
                }
                self.statuses += statuses
                self.tabelView.reloadData()
                self.pullUpView.indicator.stopAnimating()
            })
            isPullUp = false
            return
        }
        
        refreshControl.beginRefreshing()
        
        // 若模型数组为0 则不需要设置 sinceID
        var sinceID: Int64 = 0
        if statuses.count != 0 {
            sinceID = statuses[0].id
        }
        
        // 请求最新微博数据
        NetWorkManager.shared.loadStatuses(sinceID: sinceID, maxID: 0) { (statuses, isSuccess) in
            guard let statuses = statuses else {
                print("微博数据为空")
                return
            }
            // 将最新微博数据模型 置入 模型数组头部
            self.statuses = statuses + self.statuses
            
            self.refreshControl.endRefreshing()
            
            self.tabelView.reloadData()
        }
    }
}

// MARK: 设置UI
extension HomeViewController {
    override func setupTabelView() {
        super.setupTabelView()
        
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
    }
}

// MARK: tableView 代理方法、数据源方法
extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabelView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        cell.textLabel?.text = statuses[indexPath.row].text ?? ""
        
        return cell
    }
    
}
