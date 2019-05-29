//
//  GameScene.swift
//  TestGame
//
//  Created by Justin Vo on 5/23/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol GameEscapeDelegate {
    func escapeToMap()
}

class GameScene: SKScene {
    
    var gameEscapeDelegate: GameEscapeDelegate?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    let player = SKSpriteNode(imageNamed: "cms")
    
    override func sceneDidLoad() {
        /*
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        */
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.player.position = CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.8)
        addChild(player)
        
        let escapeButton = ButtonNode(defaultStateText: "Escape!", activeStateText: "Escaping...", color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {
            print("Trying to escape...")
            self.gameEscapeDelegate?.escapeToMap()
        }
        escapeButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        addChild(escapeButton)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
