//
//  MainViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MainViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildViewControllers()
    }

    private func setupChildViewControllers() {
        
        let home = WBNavigationController(rootViewController: HomeViewController())
        let message = WBNavigationController(rootViewController: BasicViewController())
        let discover = WBNavigationController(rootViewController: BasicViewController())
        let profile = WBNavigationController(rootViewController: BasicViewController())
        
        home.tabBarItem = ESTabBarItem(WBTabBarItemContentView(), title: nil, image: #imageLiteral(resourceName: "tabbar_home"), selectedImage: #imageLiteral(resourceName: "tabbar_home_selected"), tag: 0)
        message.tabBarItem = ESTabBarItem(WBTabBarItemContentView(), title: nil, image: #imageLiteral(resourceName: "tabbar_message_center"), selectedImage: #imageLiteral(resourceName: "tabbar_message_center_selected"), tag: 1)
        discover.tabBarItem = ESTabBarItem(WBTabBarItemContentView(), title: nil, image: #imageLiteral(resourceName: "tabbar_discover"), selectedImage: #imageLiteral(resourceName: "tabbar_discover_selected"), tag: 2)
        profile.tabBarItem = ESTabBarItem(WBTabBarItemContentView(), title: nil, image: #imageLiteral(resourceName: "tabbar_profile"), selectedImage: #imageLiteral(resourceName: "tabbar_profile_selected"), tag: 2)
        
        viewControllers = [home, message, discover, profile]
    }

}
