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
    
    var identifier: String
    var name: String?
    var latitude: Double
    var longitude: Double
    
    var health: Double
    var power: Double
    
    init(health: Double, location: CLLocationCoordinate2D, identifier: String, power: Double) {
        // Set up basic properties
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.identifier = identifier
        
        // Set up stats
        self.health = health
        self.power = power
        
        self.name = createRandomName()
    }
    
    init(health: Double, latitude: Double, longitude: Double, identifier: String, power: Double) {
        // Set up basic properties
        self.latitude = latitude
        self.longitude = longitude
        self.identifier = identifier
        
        // Set up stats
        self.health = health
        self.power = power
        
        self.name = createRandomName()
    }
    
    func createRandomName() -> String {
        let random1 = Int.random(in: 4...7)
        var randomLength = Int.random(in: 4...7)
        while random1 == randomLength {
            randomLength = Int.random(in: 4...7)
        }
        
        let CONSONANTS = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]
        let VOWELS = ["a", "e", "i", "o", "u"]
        
        var randomName = ""
        
        let randomStart = Int.random(in: 0...1)
        switch randomStart {
        case 0:
            // Start with CONSONANT
            let randomFirst = Int.random(in: 0..<CONSONANTS.count)
            randomName.append(CONSONANTS[randomFirst])
        case 1:
            // Start with VOWEL
            let randomFirst = Int.random(in: 0..<VOWELS.count)
            randomName.append(VOWELS[randomFirst])
        default:
            print("default in name building")
        }
        
        for _ in 1...randomLength {
            let lastChar = String(randomName.last!)
            if CONSONANTS.contains(lastChar) {
                // Add a vowel
                let randomChar = Int.random(in: 0..<VOWELS.count)
                randomName.append(VOWELS[randomChar])
                
            } else { // last character is a vowel
                // Add a consonant
                let randomChar = Int.random(in: 0..<CONSONANTS.count)
                randomName.append(CONSONANTS[randomChar])
            }
        }
        
        // Capitalize first letter
        randomName = randomName.prefix(1).capitalized + randomName.dropFirst()

        var aegis = "Aegis - "
        aegis.append(randomName)
        return aegis
    }
}
