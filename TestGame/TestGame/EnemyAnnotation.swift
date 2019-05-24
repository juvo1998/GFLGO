//
//  EnemyAnnotation.swift
//  TestGame
//
//  Created by Justin Vo on 5/24/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import MapKit

class EnemyAnnotation: NSObject, MKAnnotation {
    
    var enemy: Enemy
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(enemy: Enemy) {
        self.enemy = enemy
        let enemyCoordinate = CLLocationCoordinate2D(latitude: enemy.latitude, longitude: enemy.longitude)
        self.coordinate = enemyCoordinate
        self.title = enemy.name
        super.init()
    }
}
