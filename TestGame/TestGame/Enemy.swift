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
    var health: Double
    var latitude: Double
    var longitude: Double
    
    init(name: String, health: Double, location: CLLocationCoordinate2D, enemyID: Int) {
        self.name = name
        self.health = health
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.enemyID = enemyID
    }
    
    init(name: String, health: Double, latitude: Double, longitude: Double, enemyID: Int) {
        self.name = name
        self.health = health
        self.latitude = latitude
        self.longitude = longitude
        self.enemyID = enemyID
    }
}
