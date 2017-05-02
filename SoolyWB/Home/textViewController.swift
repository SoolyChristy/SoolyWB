//
//  textViewController.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/4/30.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class textViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.yellow
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8) {
            self.navigationController?.navigationBar.isHidden = false
        }
    }

}
