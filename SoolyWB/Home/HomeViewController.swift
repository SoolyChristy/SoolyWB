//
//  HomeViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class HomeViewController: BasicViewController {

    lazy var statusVMs = [WBStatusViewModel]()
    var composeBtn: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyAnimation.values = [0.4, 0.6, 0.8, 1.0, 1.2, 1.0]
        keyAnimation.duration = 0.25
        composeBtn.layer.add(keyAnimation, forKey: nil)
    }
}

// MARK: 加载数据
extension HomeViewController {
    override func loadData() {
        super.loadData()
        
        // 如果是上拉刷新
        if pullUpView.isPullUp {
            // 设置maxID
            let maxID = statusVMs.last?.status.id ?? 0
            NetWorkManager.shared.loadStatuses(sinceID: 0, maxID: maxID, compeletion: { (statuses, isSuccess) in

                guard let statuses = statuses else {
                    print("微博数据为空")
                    return
                }
                self.statusVMs += statuses
                self.tableView.reloadData()
            })
            
            pullUpView.endRefreshing()
            return
        }
        
        refreshControl.beginRefreshing()
        
        // 若模型数组为0 则不需要设置 sinceID 
        // 若不为零 更新之前微博的时间
        var sinceID: Int64 = 0
        if statusVMs.count != 0 {
            // 设置 sinceID
            sinceID = statusVMs[0].status.id
            
            // 更新时间
            for viewModel in statusVMs {
                viewModel.time = viewModel.setupTime()
            }
        }
        
        // 请求最新微博数据
        NetWorkManager.shared.loadStatuses(sinceID: sinceID, maxID: 0) { (statuses, isSuccess) in
            guard let statuses = statuses else {
                print("微博数据为空")
                
                self.refreshControl.endRefreshing()
                
                return
            }
            
            // 将最新微博数据模型 置入 模型数组头部
            self.statusVMs = statuses + self.statusVMs
            
            self.refreshControl.endRefreshing()
            
            self.tableView.reloadData()
        }
    }
}

// MARK: 设置UI
extension HomeViewController {
    
    override func setupUI() {
        super.setupUI()
        setTitleBtn(tilte: "特别关心")
        setupComposeButton()
    }
    
    override func setupTableView() {
        super.setupTableView()

        tableView.register(UINib(nibName: "StatusTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: statusCellID)
        tableView.register(UINib(nibName: "RepostStatusCell", bundle: Bundle.main), forCellReuseIdentifier: repostCellID)
        
        // 预估行高
        tableView.estimatedRowHeight = 300
        
        // 自动行高
//        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    /// 发布新微博按钮
    private func setupComposeButton() {
        
        let x = screenWidth - (28 + margin)
        let y = screenHeight - (28 + margin) - 49
        
        composeBtn.frame.size = CGSize(width: 56, height: 56)
        composeBtn.center = CGPoint(x: x, y: y)
        composeBtn.setBackgroundImage(#imageLiteral(resourceName: "composeBtn"), for: [])
        
        // 阴影
        composeBtn.layer.shadowRadius = 3
        composeBtn.layer.shadowOpacity = 0.5
        composeBtn.layer.shadowOffset = CGSize(width: 1, height: 1)
        composeBtn.layer.shadowColor = UIColor.black.cgColor

        composeBtn.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)
        
        view.addSubview(composeBtn)
    }
}

extension HomeViewController {
    @objc fileprivate func composeBtnClick() {
        navigationController?.present(ComposeViewController(), animated: true)
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
        
        let viewModel = statusVMs[indexPath.section]
        
        // 判断 是否有转发微博
        let id = viewModel.status.retweeted_status == nil ? statusCellID : repostCellID
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! StatusTableViewCell
        
        cell.viewModel = viewModel
        cell.vc = self
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return statusVMs[indexPath.section].rowHeight ?? 0
    }
    
}
