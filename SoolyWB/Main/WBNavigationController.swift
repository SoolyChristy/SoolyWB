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

    // 若pop回微博主页则隐藏导航条
//    override func popViewController(animated: Bool) -> UIViewController? {
//        if viewControllers.count <= 2 {
//            for vc in viewControllers {
//                if vc is HomeViewController {
//                    navigationBar.isHidden = true
//                    return super.popViewController(animated: animated)
//                }
//            }
//        }else {
//            navigationBar.isHidden = false
//        }
//        
//        return super.popViewController(animated: animated)
//    }
    
}
