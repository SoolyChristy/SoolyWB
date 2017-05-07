//
//  WBNavigationController
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/18.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // 显示tabBar
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if viewControllers.count <= 2 {
            tabBarController?.tabBar.isHidden = false
        }
        
        return super.popToViewController(viewController, animated: animated)
    }
    
    // 隐藏tabBar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewControllers.count >= 2 {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
}
