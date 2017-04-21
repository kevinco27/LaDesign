//
//  MyTabBarController.swift
//  LaDesign
//
//  Created by kai on 2017/4/13.
//  Copyright © 2017年 kai. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.barTintColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.00)
        self.tabBar.tintColor = UIColor(red: 96/255, green: 10/255, blue: 30/255, alpha: 1.00)
    }
}
