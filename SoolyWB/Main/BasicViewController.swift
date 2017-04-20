//
//  BasicViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {

    lazy var tabelView: UITableView = UITableView()
    /// 下拉刷新控件
    lazy var refreshControl = UIRefreshControl()
    /// 上拉视图
    lazy var pullUpView = PullUpView.pullUpView()
    /// 是否是上拉刷新
    var isPullUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // 判断是否登录
        if !NetWorkManager.shared.isUserLogin {
            self.navigationController?.present(WBNavigationController(rootViewController: LoginViewController()), animated: false)
        }
        
        loadData()
    }

}

// MARK: 加载数据
extension BasicViewController {
     func loadData() {
        
    }
}

// MARK: 设置界面
extension BasicViewController {
     func setupUI() {
        view.backgroundColor = UIColor.white
        setupTabelView()
    
    }
    
     func setupTabelView() {
        tabelView.frame = view.frame
        tabelView.backgroundColor = UIColor.white
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.separatorStyle = .none
        
        // 下拉刷新控件
        tabelView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        // 上拉刷新
        tabelView.tableFooterView = pullUpView
        
        // 设置内容缩进
//        tabelView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController?.tabBar.bounds.height ?? 49, 0)
        
        view.addSubview(tabelView)
    }
}

// MARK: tableView 代理方法、数据源方法
extension BasicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        // 判断是最后一组
        if section + 1 != tableView.numberOfSections {
            return
        }
        
        // 判断是最后一行
        if row + 1 != tableView.numberOfRows(inSection: section) {
            return
        }
        
        // 开始刷新
        pullUpView.indicator.startAnimating()
        isPullUp = true
        pullUpView.indicator.isHidden = false
        loadData()
    }

}
