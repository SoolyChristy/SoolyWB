//
//  PopMenuViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/6.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class PopMenuViewController: UITableViewController {

    override var preferredContentSize: CGSize {
        didSet {
            tableView.frame.size = preferredContentSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

}

// MARK: 设置界面
extension PopMenuViewController {
    fileprivate func setupUI() {
        tableView.backgroundColor = UIColor.color(hex: "#4E4E4E")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        
        popoverPresentationController?.backgroundColor = tableView.backgroundColor
        popoverPresentationController?.delegate = self
        popoverPresentationController?.permittedArrowDirections = .any
        
        modalPresentationStyle = .popover
    }
}

extension PopMenuViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: tabelView 方法
extension PopMenuViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        cell.backgroundColor = UIColor.color(hex: "#4E4E4E")
        cell.textLabel?.text = "点我"
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
}
