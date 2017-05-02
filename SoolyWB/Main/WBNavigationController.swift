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

    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: animated)
        
        if viewControllers.count <= 1 {
            navigationBar.isHidden = true
        }
        
        return nil
    }
    
//    override func et_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
//        guard let vcs = super.et_popToViewController(viewController, animated: animated) else {
//            return nil
//        }
//        
//        if viewControllers.count <= 1 {
//            navigationBar.isHidden = true
//        }
//        
//        return vcs
//    }

}
