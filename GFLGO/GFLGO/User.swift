//
//  User.swift
//  TestGame
//
//  Created by Justin Vo on 5/24/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import Firebase

enum Gun: String {
    case cms
}

class User {
    
    var firebase = Database.database().reference()
    
    var username: String
    var password: String
    var userID: Int
    
    var health: Double
    var power: Double
    var totalExp: Int
    var exp: Int
    var level: Int
        
    init(username: String, password: String, userID: Int, health: Double, power: Double, totalExp: Int) {
        // Set up basic properties
        self.username = username
        self.password = password
        self.userID = userID
        
        // Set up stats
        self.health = health
        self.power = power
        self.totalExp = totalExp
        self.exp = totalExp % 5
        self.level = totalExp / 5
    }
    
    func addExperience(amount: Int) {
        self.totalExp += amount
        self.exp = self.totalExp % 5
        self.level = totalExp / 5
        
        // Update firebase
        firebase.child("users").child(String(self.userID)).child("totalExp").setValue(self.totalExp)
    }
}
