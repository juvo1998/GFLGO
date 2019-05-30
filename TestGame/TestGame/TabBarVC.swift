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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarVC: viewDidLoad()")
        // self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
