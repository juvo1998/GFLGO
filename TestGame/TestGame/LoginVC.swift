//
//  LoginVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/23/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginVC viewDidLoad()")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarSegue" {
            let tabBarVC = segue.destination as! TabBarVC
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        performSegue(withIdentifier: "TabBarSegue", sender: self)
    }
}
