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
    var firstCenter: Bool?
    var userLocation: CLLocationCoordinate2D? {
        didSet {
            if firstCenter! {
                centerMap()
                setUpAnnotations()
                firstCenter = false
            }
        }
    }
    
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
        self.firstCenter = true
        mapOutlet.delegate = self
        mapOutlet.showsUserLocation = true
        
        // Obtain the location manager from the TabBarVC
        self.locationManager = tabBarVC.locationManager
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.delegate = self
        self.locationManager?.startUpdatingLocation()
        
        enemyCallout.layer.cornerRadius = 10
        enemyCallout.isHidden = true;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("MapVC: didUpdateLocations")
        self.userLocation = locations.last!.coordinate
    }
    
    @IBAction func centerAction(_ sender: UIButton) {
        centerMap()
        setUpAnnotations()
    }
    
    func centerMap() {
        let RADIUS: CLLocationDistance = 3000.0 // meters
        let region = MKCoordinateRegion(center: userLocation!, latitudinalMeters: RADIUS, longitudinalMeters: RADIUS)
        self.mapOutlet.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is EnemyAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            // annotationView!.canShowCallout = true
            // annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.enemyCallout.isHidden = false
        
        let enemyAnnotation = view.annotation as! EnemyAnnotation
        let enemy = enemyAnnotation.enemy
        self.selectedEnemy = enemy
        
        self.enemyCalloutName.text = enemy.name
        self.enemyCalloutHealth.text = "Health: \(enemy.health)"
        self.enemyCalloutPower.text = "Power: \(enemy.power)"
        
        let coordinate = enemyAnnotation.coordinate
        self.mapOutlet.setCenter(coordinate, animated: true)
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
        // location is relative to the current view
        // do something with the touched point
        if touch?.view != enemyCallout {
            enemyCallout.isHidden = true
        }
    }
    
    func setUpAnnotations() {
        self.mapOutlet.removeAnnotations(self.mapOutlet.annotations)
        findEnemiesAroundUser { (enemies) in
            for enemy in enemies {
                let enemyAnnotation = EnemyAnnotation(enemy: enemy)
                self.mapOutlet.addAnnotation(enemyAnnotation)
            }
        }
    }
    
    func findEnemiesAroundUser(completion: @escaping (_ enemies: [Enemy]) -> ()) {
        var enemyList = [Enemy]()
        let VIEW_DISTANCE = 1600.0
        firebase!.child("enemies").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                // Grab enemy data from Firebase
                let enemyID = Int(child.key)
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
                if (distance <= VIEW_DISTANCE) {
                    let enemy = Enemy(name: enemyName, health: enemyHealth, latitude: enemyLatitude, longitude: enemyLongitude, enemyID: enemyID!, power: enemyPower)
                    enemyList.append(enemy)
                }
                
                completion(enemyList)
            }
        })
    }
}
