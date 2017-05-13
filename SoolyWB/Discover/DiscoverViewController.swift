//
//  DiscoverViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/26.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let searchCell = "searchCell"

class DiscoverViewController: BasicViewController {

    var recentSearch = ["Swift", "SoolyChristina", "iPhone 8"]
    var hotSearch = ["比特币病毒", "957", "欢乐颂2", "鹿晗、迪丽热巴", "习近平"]
    
    lazy var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
}

extension DiscoverViewController {
    override func setupUI() {
        super.setupUI()
        titleBtn.setTitle(title: "搜索", isHome: false)
        
        setupSearchBar()
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.refreshControl = nil
        pullUpView.isHidden = true
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: searchCell)
        
        tableView.contentInset = UIEdgeInsets(top: 52, left: 0, bottom: 49, right: 0)

    }
    
    func setupSearchBar() {
        searchBar.frame = CGRect(x: 15, y: navigationBar.frame.height, width: screenWidth - 30, height: 40)
        searchBar.placeholder = "大家正在搜"
        searchBar.backgroundImage = UIImage.image(with: UIColor.white)
        searchBar.barStyle = .blackTranslucent
        searchBar.tintColor = footerViewBgColor
        
        view.addSubview(searchBar)
    }
}

extension DiscoverViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        section == 0 ? (count = recentSearch.count) : (count = hotSearch.count)
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCell, for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = recentSearch[indexPath.row]
        }else {
            cell.textLabel?.text = hotSearch[indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        view.backgroundColor = UIColor.white
       
        let label = UILabel()
        label.frame.origin = CGPoint(x: 15, y: 0)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = wbOrange
        view.addSubview(label)
        
        var text = ""
        section == 0 ? (text = "最近搜索的") : (text = "微博热搜")
        
        label.text = text
        label.sizeToFit()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellMargin
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
