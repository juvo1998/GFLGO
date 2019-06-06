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
    
    var firebase: DatabaseReference?
    
    override func viewDidLoad() {
        print("SignupVC: viewDidLoad()")
        super.viewDidLoad()
        
        self.firebase = Database.database().reference()
    }
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        checkIfUserExists { (userExists) in
            if userExists {
                let alert = UIAlertController(title: "Username already exists", message: "Please try a different username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            } else {
                self.addUserToFirebase(username: self.usernameOutlet.text!)
                self.goToLogin()
            }
        }
    }
    
    func goToLogin() {
        let alert = UIAlertController(title: "Sign up successful!", message: "You've successfully created your account! Please log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func checkIfUserExists(completion: @escaping (_ check: Bool) -> ()) {
        firebase!.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            var userExists = false
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let username = child.childSnapshot(forPath: "username").value as! String
                if self.usernameOutlet.text == username {
                    userExists = true
                    break;
                }
            }
            completion(userExists)
        })
    }
    
    func addUserToFirebase(username: String) {
        firebase!.child("users").observeSingleEvent(of: .value) { (snapshot) in
            let userID = String(snapshot.childrenCount)
            let user = User(username: username, password: self.passwordOutlet.text!, userID: Int(userID)!, health: 50, power: 3.2, totalExp: 10)
            
            self.firebase!.child("users").child(userID).setValue(user.userID)
            self.firebase!.child("users").child(userID).child("username").setValue(user.username)
            self.firebase!.child("users").child(userID).child("password").setValue(user.password)
            self.firebase!.child("users").child(userID).child("health").setValue(user.health)
            self.firebase!.child("users").child(userID).child("power").setValue(user.power)
            self.firebase!.child("users").child(userID).child("totalExp").setValue(user.totalExp)
        }
    }
}
