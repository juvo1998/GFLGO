//
//  ButtonNode.swift
//  TestGame
//
//  Created by Justin Vo on 5/28/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import Foundation
import SpriteKit

enum ButtonType {
    case sprite
    case label
}

enum ButtonState {
    case standby
    case active
    case both
}

class ButtonNode: SKNode {
    
    var type: ButtonType // either "SPRITE" or "LABEL"
    
    var defaultStateSprite: SKSpriteNode?
    var activeStateSprite: SKSpriteNode?
    
    var defaultStateLabel: SKLabelNode?
    var activeStateLabel: SKLabelNode?
    
    var event: () -> Void
    
    // Create button with images (Sprite)
    init(defaultStateImage: String, activeStateImage: String, event: @escaping () -> Void) {
        // Set properties
        self.type = .sprite
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
        self.type = .label
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
        if self.type == .sprite {
            self.defaultStateSprite!.isHidden = true
            self.activeStateSprite!.isHidden = false
        } else { // self.type == .label
            self.defaultStateLabel!.isHidden = true
            self.activeStateLabel!.isHidden = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self)
        
        if self.type == .sprite {
            if self.defaultStateSprite!.contains(location) {
                self.defaultStateSprite!.isHidden = true
                self.activeStateSprite!.isHidden = false
            } else {
                self.defaultStateSprite!.isHidden = false
                self.activeStateSprite!.isHidden = true
            }
            
        } else { // self.type == .label
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
        
        if self.type == .sprite {
            if self.defaultStateSprite!.contains(location) {
                self.event()
            }
            
            self.defaultStateSprite!.isHidden = false
            self.activeStateSprite!.isHidden = true
            
        } else { // self.type == .label
            if self.defaultStateLabel!.contains(location) {
                self.event()
            }
            
            self.defaultStateLabel!.isHidden = false
            self.activeStateLabel!.isHidden = true
        }
    }

    func changeFontColor(to color: UIColor, for state: ButtonState) {
        if state == .standby || state == .both {
            self.defaultStateLabel!.fontColor = color
        }
        if state == .active || state == .both {
            self.activeStateLabel!.fontColor = color
        }
    }
    
    func changeFontName(to name: String, for state: ButtonState) {
        if state == .standby || state == .both {
            self.defaultStateLabel!.fontName = name
        }
        if state == .active || state == .both {
            self.activeStateLabel!.fontName = name
        }
    }
    
    func changeFontSize(to size: Double, for state: ButtonState) {
        if state == .standby || state == .both {
            self.defaultStateLabel!.fontSize = CGFloat(size)
        }
        if state == .active || state == .both {
            self.activeStateLabel!.fontSize = CGFloat(size)
        }
    }
}
