//
//  User.swift
//  TestGame
//
//  Created by Justin Vo on 5/24/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation

class User {
    
    var username: String
    var password: String
    var userID: Int
    
    var health: Double
    var power: Double
    
    init(username: String, password: String, userID: Int, health: Double, power: Double) {
        
        // Set up basic properties
        self.username = username
        self.password = password
        self.userID = userID
        
        // Set up stats
        self.health = health
        self.power = power
    }
}
