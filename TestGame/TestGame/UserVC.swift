//
//  UserVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/24/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class UserVC: UIViewController {

    var firebase: DatabaseReference?
    var user: User?
    
    @IBOutlet weak var usernameOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserVC: viewDidLoad()")
        
        // Set up Firebase
        self.firebase = Database.database().reference()
        
        // Obtain the User from TabBarVC
        let tabBarVC = tabBarController as! TabBarVC
        self.user = tabBarVC.user
        
        usernameOutlet.text = self.user?.username
    }
}
