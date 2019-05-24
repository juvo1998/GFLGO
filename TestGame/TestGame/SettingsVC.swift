//
//  SettingsVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/23/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {
    
    var user: User?
    
    let NUM_ROWS = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingsVC: viewDidLoad()")
        
        // Obtain the User from the TabBarVC
        let tabBarVC = tabBarController as! TabBarVC
        self.user = tabBarVC.user
    }
}
