//
//  ButtonNode.swift
//  TestGame
//
//  Created by Justin Vo on 5/28/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonNode: SKNode {
    
    var mode: String // either "SPRITE" or "LABEL"
    
    var defaultStateSprite: SKSpriteNode?
    var activeStateSprite: SKSpriteNode?
    
    var defaultStateLabel: SKLabelNode?
    var activeStateLabel: SKLabelNode?
    
    var event: () -> Void
    
    // Create button with images (Sprite)
    init(defaultStateImage: String, activeStateImage: String, event: @escaping () -> Void) {
        // Set properties
        self.mode = "SPRITE"
        self.defaultStateSprite = SKSpriteNode(imageNamed: defaultStateImage)
        self.activeStateSprite = SKSpriteNode(imageNamed: activeStateImage)
        self.event = event
        
        self.activeStateSprite!.isHidden = true
        
        super.init()
        
        self.isUserInteractionEnabled = true
        addChild(self.defaultStateSprite!)
        addChild(self.activeStateSprite!)
    }
    
    // Create buttons with text
    init(defaultStateText: String, activeStateText: String, color: UIColor, event: @escaping () -> Void) {
        // Set properties
        self.mode = "LABEL"
        self.defaultStateLabel = SKLabelNode(text: defaultStateText)
        self.activeStateLabel = SKLabelNode(text: activeStateText)
        self.event = event
        
        self.activeStateLabel!.isHidden = true
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.defaultStateLabel!.fontColor = color
        self.activeStateLabel!.fontColor = color
        
        addChild(self.defaultStateLabel!)
        addChild(self.activeStateLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.mode == "SPRITE" {
            self.defaultStateSprite!.isHidden = true
            self.activeStateSprite!.isHidden = false
        } else { // self.mode == "LABEL"
            self.defaultStateLabel!.isHidden = true
            self.activeStateLabel!.isHidden = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        
        if self.mode == "SPRITE" {
            if self.defaultStateSprite!.contains(location) {
                self.defaultStateSprite!.isHidden = true
                self.activeStateSprite!.isHidden = false
            } else {
                self.defaultStateSprite!.isHidden = false
                self.activeStateSprite!.isHidden = true
            }
            
        } else { // self.mode == "LABEL"
            if self.defaultStateLabel!.contains(location) {
                self.defaultStateLabel!.isHidden = true
                self.activeStateLabel!.isHidden = false
            } else {
                self.defaultStateLabel!.isHidden = false
                self.activeStateLabel!.isHidden = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        
        if self.mode == "SPRITE" {
            if self.defaultStateSprite!.contains(location) {
                self.event()
            }
            
            self.defaultStateSprite!.isHidden = false
            self.activeStateSprite!.isHidden = true
            
        } else { // self.mode == "LABEL"
            if self.defaultStateLabel!.contains(location) {
                self.event()
            }
            
            self.defaultStateLabel!.isHidden = false
            self.activeStateLabel!.isHidden = true
        }
    }
}
