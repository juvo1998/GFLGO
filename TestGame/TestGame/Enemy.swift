//
//  Enemy.swift
//  TestGame
//
//  Created by Justin Vo on 5/24/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import CoreLocation

class Enemy {
    
    var enemyID: Int
    var name: String
    var latitude: Double
    var longitude: Double
    
    var health: Double
    var power: Double
    
    init(name: String, health: Double, location: CLLocationCoordinate2D, enemyID: Int, power: Double) {
        
        // Set up basic properties
        self.name = name
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.enemyID = enemyID
        
        // Set up stats
        self.health = health
        self.power = power
    }
    
    init(name: String, health: Double, latitude: Double, longitude: Double, enemyID: Int, power: Double) {
        
        // Set up basic properties
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.enemyID = enemyID
        
        // Set up stats
        self.health = health
        self.power = power
    }
}
