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
    @IBOutlet weak var healthOutlet: UILabel!
    @IBOutlet weak var powerOutlet: UILabel!
    @IBOutlet weak var levelOutlet: UILabel!
    @IBOutlet weak var expOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserVC: viewDidLoad()")
        
        // Set up Firebase
        self.firebase = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("UserVC: viewDidAppear()")
        
        // Obtain the User from TabBarVC
        let tabBarVC = tabBarController as! TabBarVC
        self.user = tabBarVC.user
        
        self.usernameOutlet.text = self.user?.username
        self.healthOutlet.text = "Health: \(self.user!.health)"
        self.powerOutlet.text = "Power: \(self.user!.power)"
        self.levelOutlet.text = "Level: \(self.user!.level)"
        self.expOutlet.text = "EXP: \(self.user!.exp) / 5"
    }
}
