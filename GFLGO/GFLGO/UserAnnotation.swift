//
//  UserAnnotation.swift
//  GFLGO
//
//  Created by Justin Vo on 6/12/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import MapKit

/*
 Even though this is called UserAnnotation, this annotation is specifically for OTHER users. The user that is
 playing the game has its own annotation.
 */
class UserAnnotation: NSObject, MKAnnotation {
    
    var user: User
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(user: User) {
        self.user = user
        let userCoordinate = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
        self.coordinate = userCoordinate
        self.title = user.username
        super.init()
    }
}
