//
//  NewPasswordVC.swift
//  TestGame
//
//  Created by Justin Vo on 6/5/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewPasswordVC: UIViewController {
    
    var firebase = Database.database().reference()
    var user: User?
    
    @IBOutlet weak var oldPasswordOutlet: UITextField!
    @IBOutlet weak var newPasswordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NewPasswordVC: viewDidLoad()")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        changeIfValidPassword()
    }
    
    func changeIfValidPassword() {
        let oldPassword = oldPasswordOutlet.text
        let userID = String(self.user!.userID)
        
        self.firebase.child("users").child(userID).child("password").observeSingleEvent(of: .value) { (snapshot) in
            let truePassword = snapshot.value as! String
            
            if oldPassword == truePassword {
                let newPassword = self.newPasswordOutlet.text
                self.firebase.child("users").child(userID).child("password").setValue(newPassword)
                let alert = UIAlertController(title: "Password changed!", message: "Your new password has been set succesfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
                
            } else { // password doesn't match
                let alert = UIAlertController(title: "Incorrect password", message: "Your original password was not entered correctly.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
