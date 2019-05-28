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
    
    var defaultState: SKSpriteNode
    var activeState: SKSpriteNode
    var event: () -> Void
    
    init(defaultStateImage: String, activeStateImage: String, event: @escaping () -> Void) {
        // Set properties
        self.defaultState = SKSpriteNode(imageNamed: defaultStateImage)
        self.activeState = SKSpriteNode(imageNamed: activeStateImage)
        self.event = event
        
        self.activeState.isHidden = true
        
        super.init()
        
        self.isUserInteractionEnabled = true
        addChild(self.defaultState)
        addChild(self.activeState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.defaultState.isHidden = true
        self.activeState.isHidden = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch = touches.first!
        var location: CGPoint = touch.location(in: self)
        
        if self.defaultState.contains(location) {
            self.defaultState.isHidden = true
            self.activeState.isHidden = false
        } else {
            self.defaultState.isHidden = false
            self.activeState.isHidden = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch = touches.first!
        var location: CGPoint = touch.location(in: self)
        
        if self.defaultState.contains(location) {
            self.event()
        }
        
        self.defaultState.isHidden = false
        self.activeState.isHidden = true
    }
}
