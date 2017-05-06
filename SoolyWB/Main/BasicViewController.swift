//
//  BasicViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {

    lazy var tableView: UITableView = UITableView()
    /// 下拉刷新控件
    lazy var refreshControl = UIRefreshControl()
    /// 上拉视图
    lazy var pullUpView = PullUpView.pullUpView()
    
    /// 自定义导航条
    var navigationBar = UINavigationBar()
    
    var navItem = UINavigationItem()
    var titleBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name(rawValue: loginSuccessful), object: nil)
        
        // 判断是否登录
        if !NetWorkManager.shared.isUserLogin {
            
            present(LoginViewController(), animated: false)
            
            setupUI()
            return
        }
        
        setupUI()
        loadData()
        
    }

    @objc func rightBtnClick(btn: UIButton) {
        let popVc = PopMenuViewController()
        popVc.modalPresentationStyle = .popover
        popVc.preferredContentSize = CGSize(width: 160, height: 200)
        popVc.popoverPresentationController?.sourceView = btn
        popVc.popoverPresentationController?.sourceRect = btn.bounds

        present(popVc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: 加载数据
extension BasicViewController {
     func loadData() {
        // 获取登录用户账户信息
        NetWorkManager.shared.getUserInfo()
        
    }
}

// MARK: 设置界面
extension BasicViewController {
     func setupUI() {
        view.backgroundColor = UIColor.white
        
        // 取消自动缩进 - 如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        
        
        setupNavigationBar()
        setupTableView()
        
    }
    
    func setupNavigationBar() {
        
        navigationController?.navigationBar.isHidden = true
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 76)
        
        setTitleBtn(tilte: "")
        
        navItem.leftBarButtonItem = UIBarButtonItem(customView: titleBtn)
        
        // 右边按钮
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "menu"), for: [])
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(rightBtnClick(btn:)), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        
        // 取消底部黑线
        navigationBar.setBackgroundImage(UIImage.getImage(color: UIColor.white), for: .default)
        navigationBar.shadowImage = UIImage()
        
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor.black
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
    }
    
     func setupTableView() {
        tableView.frame = CGRect(x: 0, y: 88, width: screenWidth, height: screenHeight)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // 下拉刷新控件
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        // 上拉刷新
        tableView.tableFooterView = pullUpView
        
        // 设置内容缩进
//        tabelView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        view.addSubview(tableView)
//        view.insertSubview(tableView, belowSubview: navigationBar)
    }
    
    /// 设置title按钮
    func setTitleBtn(tilte: String) {
        let str = NSAttributedString(string: tilte, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30)])
        titleBtn.setAttributedTitle(str, for: [])
        titleBtn.sizeToFit()
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
        pullUpView.startRefreshing()
        loadData()
    }

}
