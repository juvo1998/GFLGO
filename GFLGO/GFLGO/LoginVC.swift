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

extension UIView {
    func addBackground(imageName: String, contentMode: UIView.ContentMode = .scaleToFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        
        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}

class LoginVC: UIViewController, CLLocationManagerDelegate {
    
    var firebase: DatabaseReference?
    
    var user: User?
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var loginViewOutlet: UIView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    
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
        
        // Login square visuals
        self.loginViewOutlet.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.loginViewOutlet.layer.cornerRadius = 12
        
        self.loginButtonOutlet.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.loginButtonOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.loginButtonOutlet.layer.borderWidth = 2
        self.loginButtonOutlet.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        self.signupButtonOutlet.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.signupButtonOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.signupButtonOutlet.layer.borderWidth = 2
        self.signupButtonOutlet.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        self.usernameOutlet.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.usernameOutlet.layer.cornerRadius = 1
        self.usernameOutlet.layer.borderWidth = 2
        
        self.passwordOutlet.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.passwordOutlet.layer.cornerRadius = 1
        self.passwordOutlet.layer.borderWidth = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("LoginVC: viewWillAppear()")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarSegue" {
            let tabBarVC = segue.destination as! TabBarVC
            tabBarVC.user = self.user
            tabBarVC.locationManager = self.locationManager
            
        } else if segue.identifier == "SignupSegue" {
            // Any preparations?
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let usernameText = usernameOutlet.text!
        let passwordText = passwordOutlet.text!
        loginIfValid(usernameText: usernameText, passwordText: passwordText)
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        performSegue(withIdentifier: "SignupSegue", sender: self)
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
                let totalExp = child.childSnapshot(forPath: "totalExp").value as! Int
                
                if username == usernameText && password == passwordText {
                    let validUser = User(username: username, password: password, userID: userID!, health: health, power: power, totalExp: totalExp)
                    self.user = validUser
                    self.performSegue(withIdentifier: "TabBarSegue", sender: self)
                    return
                }
            }
            
            // If we get here, then invalid username / password
            let alert = UIAlertController(title: "Could not verify", message: "Your username or password was entered incorrectly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
