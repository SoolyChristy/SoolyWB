//
//  ProfileHeaderView.swift
//  SoolyWB
//
//  Created by SoolyChristina on 2017/5/2.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var avatarIconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexIconView: UIImageView!
    @IBOutlet weak var authenticationLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    
    @IBOutlet weak var bgImageViewCons: NSLayoutConstraint!
    
    weak var vc: ProfileViewController?
    
    class func headerView() -> ProfileHeaderView {
        let view = Bundle.main.loadNibNamed("ProfileHeaderView", owner: nil, options: nil)?[0] as! ProfileHeaderView
        view.setupUI()
        return view
    }

    @IBAction func followBtnClick() {
        vc?.navigationController?.pushViewController(MyfollowsViewController(), animated: true)
    }

    @IBAction func starBtnClick() {
    }
}

// MARK: 设置界面
extension ProfileHeaderView {
    func setupUI() {
        guard let user = NetWorkManager.shared.userAccount.user else {
            print("用户数据为空！")
            return
        }
        let vm = WBUserViewModel(model: user)
        
        iconView.setCircularImage(urlString: vm.user.avatar_large, placeholder: #imageLiteral(resourceName: "avatar_default_big"), size: iconView.frame.size, bgColor: nil, isTransparent: true)
        avatarIconView.image = vm.avatarImage
        nameLabel.text = vm.user.screen_name
        sexIconView.image = vm.sexImage
        profileLabel.text = "个人简介：\(vm.user.description ?? "")"
        locationLabel.text = vm.user.location
        followBtn.setTitle(vm.followTitle, for: [])
        starBtn.setTitle(vm.starTitle, for: [])
        
        
    }
}
