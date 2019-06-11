//
//  MapVC.swift
//  TestGame
//
//  Created by Justin Vo on 5/24/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var firebase: DatabaseReference?
    
    var user: User?
    var selectedEnemy: Enemy?
    
    var locationManager: CLLocationManager?
    var firstCenter = true
    
    /*
     Why we use this firstCenter stuff:
     
     Upon first LOADING (not appearing), we need to grab the user's location. Afterward, we center on that location
     and load the annotations. However, if we don't get the location fast enough, there will be an error with
     centering on that location.
     
     To fix this, we make sure to only center the map and load the annotations when userLocation has been succesfully set.
     However, we do this only ONCE because we do not want to keep centering everytime the location changes.
     
     It is perfectly fine to use centerMap() and setUpAnnotations() after the first viewDidLoad, since we have a guaranteed
     non-nil userLocation. However, be careful about using either of these functions in viewWill/DidAppear(), since they
     happen with viewDidLoad()
     */
    var userLocation: CLLocationCoordinate2D? {
        didSet {
            if firstCenter {
                centerMap()
                setUpAnnotations()
                firstCenter = false
            }
        }
    }
    
    var mapCamera: MKMapCamera?
    
    var timer: Timer?
    
    @IBOutlet weak var centerOutlet: UIButton!
    @IBOutlet weak var mapOutlet: MKMapView!
    
    // Callout subview
    @IBOutlet var enemyCallout: UIView!
    @IBOutlet weak var enemyCalloutName: UILabel!
    @IBOutlet weak var enemyCalloutHealth: UILabel!
    @IBOutlet weak var enemyCalloutPower: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapVC: viewDidLoad()")
        
        // Set up Firebase
        self.firebase = Database.database().reference()

        // Obtain the User from the TabBarVC
        let tabBarVC = self.tabBarController as! TabBarVC
        self.user = tabBarVC.user
        
        // Set up map
        mapOutlet.delegate = self
        mapOutlet.showsUserLocation = true
        self.mapOutlet.showsBuildings = true
        self.mapCamera = MKMapCamera()
        
        // Customize the enemy callout
        enemyCallout.layer.cornerRadius = 10
        enemyCallout.isHidden = true;
        
        /*
         Set up spawn timer:
         Can only have 20 enemies near a user. When there are 0 enemies near the User, there will be a 20% chance
         for an enemy to spawn every 10 seconds. As there are more enemies, the spawn chance decreases (at 10 enemies, there
         will be a 10% chance at every 10 seconds).
         */
        tabBarVC.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (t) in
            let numEnemies = self.getNumberOfEnemiesAroundUser()
            let spawnChance = 50 - numEnemies
            if numEnemies < 50 {
                if self.successfulWithPercent(spawnChance) {
                    print("spawn, with num enemies: \(numEnemies + 1)")
                    self.spawnEnemy()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("MapVC: viewWillAppear()")
        
        // Obtain the location manager from the TabBarVC
        let tabBarVC = self.tabBarController as! TabBarVC
        self.locationManager = tabBarVC.locationManager
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.delegate = self
        self.locationManager?.startUpdatingLocation()
        
        if !firstCenter { setUpAnnotations() }
        self.enemyCallout.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("MapVC: viewDidDisappear()")
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("MapVC: didUpdateLocations")
        let currCoordinate = locations.last!.coordinate
        self.userLocation = currCoordinate
        self.user!.latitude = currCoordinate.latitude
        self.user!.longitude = currCoordinate.longitude
        
        // Update the user's location in Firebase
        self.firebase!.child("users").observeSingleEvent(of: .value) { (snapshot) in
            let userID = String(self.user!.userID)
            let latitude = currCoordinate.latitude
            let longitude = currCoordinate.longitude
            
            self.firebase!.child("users").child(userID).child("latitude").setValue(latitude)
            self.firebase!.child("users").child(userID).child("longitude").setValue(longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Map didFailWithError: \(error)")
    }
    
    @IBAction func centerAction(_ sender: UIButton) {
        centerMap()
        setUpAnnotations()
    }
    
    func centerMap() {
        /*
        let RADIUS: CLLocationDistance = 2000.0 // meters
        let region = MKCoordinateRegion(center: userLocation!, latitudinalMeters: RADIUS, longitudinalMeters: RADIUS)
        self.mapOutlet.setRegion(region, animated: true)
         */
        
        self.mapCamera!.pitch = 80
        self.mapCamera!.altitude = 100 // example altitude
        self.mapCamera!.centerCoordinate = self.userLocation!
        self.mapOutlet.setCamera(self.mapCamera!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is EnemyAnnotation || annotation is MKUserLocation else { return nil }
        
        if(annotation.isEqual(self.mapOutlet.userLocation)) {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserAnnotationID")
            let buffer = UIImage(named: "cms")
            let SCALE_RATIO: CGFloat = 0.38 // scale down for the annotation view
            let size = CGSize(width: buffer!.size.width * SCALE_RATIO, height: buffer!.size.height * SCALE_RATIO)
            let cmsAnnotation = resize(image: buffer!, targetSize: size)
            annotationView.image = cmsAnnotation
            return annotationView
            
        } else {
            let identifier = "EnemyAnnotationID"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView!.annotation = annotation
            }
            let buffer = UIImage(named: "aegis")
            let SCALE_RATIO: CGFloat = 0.30 // scale down for the annotation view
            let size = CGSize(width: buffer!.size.width * SCALE_RATIO, height: buffer!.size.height * SCALE_RATIO)
            let aegisAnnotation = resize(image: buffer!, targetSize: size)
            annotationView!.image = aegisAnnotation
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.reuseIdentifier == "EnemyAnnotationID" {
            if let enemyAnnotation = view.annotation as? EnemyAnnotation {
                self.enemyCallout.isHidden = false
                
                let enemy = enemyAnnotation.enemy
                self.selectedEnemy = enemy
                
                self.enemyCalloutName.text = enemy.name
                self.enemyCalloutHealth.text = "Health: \(enemy.health)"
                self.enemyCalloutPower.text = "Power: \(enemy.power)"
                
                let coordinate = enemyAnnotation.coordinate
                self.mapOutlet.setCenter(coordinate, animated: true)
            }
        }
    }
    
    @IBAction func battleAction(_ sender: UIButton) {
        performSegue(withIdentifier: "BattleSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BattleSegue" {
            let gameVC = segue.destination as! GameViewController
            gameVC.user = self.user
            gameVC.enemy = self.selectedEnemy
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != enemyCallout {
            enemyCallout.isHidden = true
        }
    }
    
    func setUpAnnotations() {
        self.mapOutlet.removeAnnotations(self.mapOutlet.annotations)
        
        // Set up enemy annotations
        findEnemiesAroundUser { (enemies) in
            for enemy in enemies {
                let enemyAnnotation = EnemyAnnotation(enemy: enemy)
                self.mapOutlet.addAnnotation(enemyAnnotation)
            }
        }
        
        // Set up other player annotations
        // findPlayersAroundUser
    }
    
    func findEnemiesAroundUser(completion: @escaping (_ enemies: [Enemy]) -> ()) {
        var enemyList = [Enemy]()
        let VIEW_DISTANCE = 100.0
        
        firebase!.child("enemies").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                // Grab enemy data from Firebase
                let enemyID = String(child.key)
                let enemyName = child.childSnapshot(forPath: "name").value as! String
                let enemyLatitude = child.childSnapshot(forPath: "latitude").value as! Double
                let enemyLongitude = child.childSnapshot(forPath: "longitude").value as! Double
                let enemyHealth = child.childSnapshot(forPath: "health").value as! Double
                let enemyPower = child.childSnapshot(forPath: "power").value as! Double

                // Get CLLocation from enemy and user coordinates
                let userLatitude = self.userLocation!.latitude
                let userLongitude = self.userLocation!.longitude
                let userLoc = CLLocation(latitude: userLatitude, longitude: userLongitude)
                let enemyLoc = CLLocation(latitude: enemyLatitude, longitude: enemyLongitude)
                
                // Compare distance
                let distance = enemyLoc.distance(from: userLoc)
                if distance <= VIEW_DISTANCE {
                    print("Adding enemy: \(enemyName) to list")
                    let enemy = Enemy(health: enemyHealth, latitude: enemyLatitude, longitude: enemyLongitude, identifier: enemyID, power: enemyPower)
                    enemy.name = enemyName
                    enemyList.append(enemy)
                }
            }
            print("sending completion()")
            completion(enemyList)
        }
    }
    
    func findPlayersAroundUser(completion: @escaping (_ users: [User]) -> ()) {
        var userList = [User]()
        let VIEW_DISTANCE = 20.0
        
        firebase!.child("enemies").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                // Grab user data from Firebase
                let userID = Int(child.key)
                
                // Skip if user is self
                if userID == self.user!.userID {
                    continue
                }
                
                let username = child.childSnapshot(forPath: "username").value as! String
                let health = child.childSnapshot(forPath: "health").value as! Double
                let power = child.childSnapshot(forPath: "power").value as! Double
                let totalExp = child.childSnapshot(forPath: "totalExp").value as! Int
                let latitude = child.childSnapshot(forPath: "latitude").value as! Double
                let longitude = child.childSnapshot(forPath: "longitude").value as! Double
                
                // Get current location for user and players
                let userLatitude = self.userLocation!.latitude
                let userLongitude = self.userLocation!.longitude
                let userLoc = CLLocation(latitude: userLatitude, longitude: userLongitude)
                let enemyLoc = CLLocation(latitude: latitude, longitude: longitude)
                
                // Compare distances and filter only nearby players into list
                let distance = enemyLoc.distance(from: userLoc)
                if distance <= VIEW_DISTANCE {
                    let otherUser = User(username: username, userID: userID!, health: health, power: power, totalExp: totalExp)
                    userList.append(otherUser)
                }
            }
            completion(userList)
        }
    }
    
    func getRandomCoordinateAroundUser(currentCoordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let currentLat = currentCoordinate.latitude
        let currentLong = currentCoordinate.longitude
        
        let HALF_LENGTH = 170.0
        
        let bufferX = Double.random(in: -HALF_LENGTH...HALF_LENGTH)
        var randomChangeX = Double.random(in: -HALF_LENGTH...HALF_LENGTH)
        while bufferX == randomChangeX {
            randomChangeX = Double.random(in: -HALF_LENGTH...HALF_LENGTH)
        }
        
        let bufferY = Double.random(in: -HALF_LENGTH...HALF_LENGTH)
        var randomChangeY = Double.random(in: -HALF_LENGTH...HALF_LENGTH)
        while bufferY == randomChangeY {
            randomChangeY = Double.random(in: -HALF_LENGTH...HALF_LENGTH)
        }
        
        // Calcuation and constants for meters -> lat and long degrees
        let latChange = randomChangeY * 0.00000900776
        let longChange = (randomChangeX * 0.00000900776) / (cos(Double.pi * currentLat / 180))
        
        let newLat = currentLat + latChange
        let newLong = currentLong + longChange
        
        let newCoordinate = CLLocationCoordinate2D(latitude: newLat, longitude: newLong)
        return newCoordinate
    }
    
    @IBAction func addEnemyAction(_ sender: UIButton) {
        spawnEnemy()
    }
    
    func spawnEnemy() {
        let enemyCoord = getRandomCoordinateAroundUser(currentCoordinate: self.userLocation!)
        let enemyID = getUniqueEnemyID()
        let newEnemy = Enemy(health: 30.0, location: enemyCoord, identifier: enemyID, power: 2.0)
        addEnemyToFirebase(enemy: newEnemy)
        
        // Add enemy annotation
        let enemyAnnotation = EnemyAnnotation(enemy: newEnemy)
        self.mapOutlet.addAnnotation(enemyAnnotation)
    }
    
    func addEnemyToFirebase(enemy: Enemy) {
        firebase!.child("enemies").observeSingleEvent(of: .value) { (snapshot) in
            self.firebase!.child("enemies").child(enemy.identifier).setValue(enemy.identifier)
            self.firebase!.child("enemies").child(enemy.identifier).child("name").setValue(enemy.name)
            self.firebase!.child("enemies").child(enemy.identifier).child("health").setValue(enemy.health)
            self.firebase!.child("enemies").child(enemy.identifier).child("power").setValue(enemy.power)
            self.firebase!.child("enemies").child(enemy.identifier).child("latitude").setValue(enemy.latitude)
            self.firebase!.child("enemies").child(enemy.identifier).child("longitude").setValue(enemy.longitude)
            // self.setUpAnnotations()
        }
    }
    
    func getUniqueEnemyID() -> String {
        let time = String(Date().timeIntervalSinceReferenceDate)
        let newTime = time.replacingOccurrences(of: ".", with: "d")
        let enemyID = "u\(self.user!.userID)e\(newTime)"
        return enemyID
    }
    
    func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func successfulWithPercent(_ percent: Int) -> Bool {
        let random1 = Int.random(in: 1...100)
        var random2 = Int.random(in: 1...100)
        while random1 == random2 {
            random2 = Int.random(in: 1...100)
        }
        if random2 <= percent {
            return true
        }
        return false
    }
    
    func getNumberOfEnemiesAroundUser() -> Int {
        // let num = self.mapOutlet.annotations.count - 1
        let annotations = self.mapOutlet.annotations
        let enemies = annotations.filter{$0 is EnemyAnnotation}
        let num = enemies.count
        return num
    }
}
