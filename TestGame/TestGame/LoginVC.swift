//
//  LoginVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/23/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class LoginVC: UIViewController, CLLocationManagerDelegate {
    
    var firebase: DatabaseReference?
    
    var user: User?
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginVC: viewDidLoad()")
        
        // Set up Firebase
        self.firebase = Database.database().reference()
        
        
        // Set up location services
        self.locationManager.delegate = self
        if !(CLLocationManager.authorizationStatus() == .authorizedAlways) &&
            !(CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarSegue" {
            let tabBarVC = segue.destination as! TabBarVC
            tabBarVC.user = self.user
            tabBarVC.locationManager = self.locationManager
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let usernameText = usernameOutlet.text!
        let passwordText = passwordOutlet.text!
        loginIfValid(usernameText: usernameText, passwordText: passwordText)
    }
    
    func loginIfValid(usernameText: String, passwordText: String) {
        firebase!.child("users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                // Grab the data from the user
                let userID = Int(child.key)
                let username = child.childSnapshot(forPath: "username").value as! String
                let password = child.childSnapshot(forPath: "password").value as! String
                let health = child.childSnapshot(forPath: "health").value as! Double
                let power = child.childSnapshot(forPath: "power").value as! Double
                
                if username == usernameText && password == passwordText {
                    let validUser = User(username: username, password: password, userID: userID!, health: health, power: power)
                    self.user = validUser
                    self.performSegue(withIdentifier: "TabBarSegue", sender: self)
                    break;
                }
                
                // If we get here, then invalid username / password
                let alert = UIAlertController(title: "Could not verify", message: "Your username or password was entered incorrectly.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
