//
//  ProfileViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/26.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class ProfileViewController: BasicViewController {

    /// 头部视图
    lazy var headerView: ProfileHeaderView = ProfileHeaderView.headerView()
    lazy var statusVMs = [WBStatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadData() {
        // 请求用户微博
        NetWorkManager.shared.loadUserStatus { (viewModel, isSuccess) in
            guard let viewModel = viewModel else{
                return
            }
            
            self.statusVMs = viewModel + self.statusVMs
            self.tableView.reloadData()
        }
    }
}

// MARK: 设置界面
extension ProfileViewController {
     override func setupUI() {
        super.setupUI()
        
        navigationBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
        self.navBarBgAlpha = 0
    }
    
    override func setupTableView() {
        super.setupTableView()
        
        tableView.frame = view.bounds
        
        // 内缩进
        tableView.contentInset = UIEdgeInsets(top: profileHeaderViewHeight, left: 0, bottom: 49, right: 0)
        
        // 头部视图
        headerView.frame = CGRect(x: 0, y: -profileHeaderViewHeight, width: screenWidth, height: profileHeaderViewHeight)
        tableView.addSubview(headerView)
        
        // 偏移距离
        tableView.contentOffset = CGPoint(x: 0, y: -profileHeaderViewHeight)
        
        tableView.refreshControl = nil
        
        tableView.register(UINib(nibName: "StatusTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: statusCellID)
        tableView.register(UINib(nibName: "RepostStatusCell", bundle: Bundle.main), forCellReuseIdentifier: repostCellID)
        
        // 预估行高
        tableView.estimatedRowHeight = 300
        
    }
}

// MARK: tableView 方法
extension ProfileViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return statusVMs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseID = ""
        reuseID = statusVMs[indexPath.section].status.retweeted_status == nil ? statusCellID : repostCellID
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! StatusTableViewCell
        cell.viewModel = statusVMs[indexPath.section]
        cell.vc = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statusVMs[indexPath.section].rowHeight ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellMargin
    }
}

// MARK: scrollView代理方法
extension ProfileViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("offsetY - \(offsetY)")
        
        if offsetY <= -profileHeaderViewHeight {
            var rect = headerView.frame
            
            rect.origin.y = offsetY
            let deltaHeight = -(offsetY + tableView.contentInset.top)
            
            rect.size.height = profileHeaderViewHeight + deltaHeight
            
            // 设置头部视图
            headerView.frame = rect
            // 设置头部视图 背景图片高度
            headerView.bgImageViewCons.constant = bgImageHeight + deltaHeight
            
            navBarBgAlpha = 0
        }
        
        //   -320 < offset < -(320 - 120)
        if offsetY > -profileHeaderViewHeight && offsetY < -(profileHeaderViewHeight - bgImageHeight) {
            // 设置导航条的透明度
            navBarBgAlpha = 1 - (offsetY - -264) / (-320 - -264)
        }
    }
}
