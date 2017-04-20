//
//  HomeViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let statusCellID = "statusCell"

class HomeViewController: BasicViewController {

    lazy var statusVMs = [WBStatusViewModel]()
    
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
            let maxID = statusVMs.last?.status.id ?? 0
            NetWorkManager.shared.loadStatuses(sinceID: 0, maxID: maxID, compeletion: { (statuses, isSuccess) in

                guard let statuses = statuses else {
                    print("微博数据为空")
                    return
                }
                self.statusVMs += statuses
                self.tabelView.reloadData()
                self.pullUpView.indicator.stopAnimating()
            })
            isPullUp = false
            pullUpView.indicator.isHidden = true
            return
        }
        
        refreshControl.beginRefreshing()
        
        // 若模型数组为0 则不需要设置 sinceID
        var sinceID: Int64 = 0
        if statusVMs.count != 0 {
            sinceID = statusVMs[0].status.id
        }
        
        // 请求最新微博数据
        NetWorkManager.shared.loadStatuses(sinceID: sinceID, maxID: 0) { (statuses, isSuccess) in
            guard let statuses = statuses else {
                print("微博数据为空")
                return
            }
            // 将最新微博数据模型 置入 模型数组头部
            self.statusVMs = statuses + self.statusVMs
            
            self.refreshControl.endRefreshing()
            
            self.tabelView.reloadData()
        }
    }
}

// MARK: 设置UI
extension HomeViewController {
    override func setupTabelView() {
        super.setupTabelView()
        
        tabelView.register(UINib(nibName: "StatusTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: statusCellID)
        
        // 预估行高
        tabelView.estimatedRowHeight = 300
        
        // 自动行高
        tabelView.rowHeight = UITableViewAutomaticDimension
    }
}

// MARK: tableView 代理方法、数据源方法
extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return statusVMs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabelView.dequeueReusableCell(withIdentifier: statusCellID, for: indexPath) as! StatusTableViewCell
        
        cell.viewModel = statusVMs[indexPath.section]
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let v = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: cellMargin))
//        v.backgroundColor = footerViewBgColor
//        return v
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellMargin
    }
    
}
