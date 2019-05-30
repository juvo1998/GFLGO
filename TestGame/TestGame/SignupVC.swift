//
//  SignupVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/30/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignupVC: UIViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        print("SignupVC: viewDidLoad()")
        super.viewDidLoad()
    }
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        
    }
}
