//
//  HealthBarNode.swift
//  TestGame
//
//  Created by Justin Vo on 5/30/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBarNode: SKNode {
    
    var backBar: SKSpriteNode
    var frontBar: SKSpriteNode
    var width: CGFloat
    
    var currentHealth: Double {
        didSet {
            if self.currentHealth > 0 {
                let scaleFactor = CGFloat(self.currentHealth / self.maxHealth)
                self.frontBar.size.width = self.width * scaleFactor
                
            } else { // Dead, so make the hp bar 0
                self.frontBar.size.width = 0.0
            }
        }
    }
    
    var maxHealth: Double
    
    init(currentHealth: Double, maxHealth: Double, width: CGFloat) {
        self.width = width

        let size = CGSize(width: width, height: 12)
        self.backBar = SKSpriteNode(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), size: size)
        self.frontBar = SKSpriteNode(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), size: size)
        self.maxHealth = maxHealth
        self.currentHealth = currentHealth // didSet called
        
        super.init()
        
        self.backBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.frontBar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        addChild(backBar)
        addChild(frontBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
