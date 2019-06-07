//
//  TabBarVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/23/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class TabBarVC: UITabBarController {
    
    var user: User?
    var locationManager: CLLocationManager?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarVC: viewDidLoad()")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // self.tabBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}
