//
//  GameScene.swift
//  TestGame
//
//  Created by Justin Vo on 5/23/19.
//  Copyright © 2019 Justin Vo. All rights reserved.
//

import SpriteKit
import GameplayKit
import Firebase

protocol GameEscapeDelegate {
    func escapeToMap()
}

class GameScene: SKScene {
    
    var gameEscapeDelegate: GameEscapeDelegate?
    var firebase: DatabaseReference?
    
    var attackButton: ButtonNode?
    
    let battleCleared = false
    
    // User and Enemy should already be created by GameViewController
    var user: User?
    var enemy: Enemy?
    
    var userHealthLabel: SKLabelNode?
    var enemyHealthLabel: SKLabelNode?
    
    var currentUserHealth = 0.0 {
        didSet {
            let maxHealth = user!.health
            self.userHealthLabel?.text = "Health: \(self.currentUserHealth) / \(maxHealth)"
            self.userHealthBar.currentHealth = self.currentUserHealth
        }
    }
    
    var currentEnemyHealth = 0.0 {
        didSet {
            let maxHealth = enemy!.health
            self.enemyHealthLabel?.text = "Health: \(currentEnemyHealth) / \(maxHealth)"
            self.enemyHealthBar.currentHealth = self.currentEnemyHealth
        }
    }
    
    var userHealthBar = HealthBarNode(currentHealth: 0, maxHealth: 1, width: 1)
    var enemyHealthBar = HealthBarNode(currentHealth: 0, maxHealth: 1, width: 1)
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    let userNode = SKSpriteNode(imageNamed: "cms")
    let enemyNode = SKSpriteNode(imageNamed:"aegis")
    
    override func sceneDidLoad() {
        print("GameScene: sceneDidLoad()")
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
        print("GameScene: didMove()")
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Firebase
        self.firebase = Database.database().reference()
        
        // User node
        self.userNode.position = CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.55)
        addChild(userNode)
        
        // User health
        self.userHealthLabel = SKLabelNode(text: "userHealthLabel")
        self.currentUserHealth = self.user!.health
        
        userHealthLabel!.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        userHealthLabel!.fontSize = 17.0
        
        let userHealthLabelX = self.userNode.position.x
        let userHealthLabelY = self.userNode.position.y + 100
        userHealthLabel!.position = CGPoint(x: userHealthLabelX, y: userHealthLabelY)
        addChild(userHealthLabel!)
        
        // User health bar
        self.userHealthBar = HealthBarNode(currentHealth: self.currentUserHealth, maxHealth: self.user!.health, width: 120)
        let userHealthBarX = self.userNode.position.x - (self.userHealthBar.frontBar.size.width / 2.0)
        let userHealthBarY = self.userNode.position.y + 120
        self.userHealthBar.position = CGPoint(x: userHealthBarX, y: userHealthBarY)
        addChild(self.userHealthBar)
        
        // Enemy node
        self.enemyNode.xScale *= 0.8
        self.enemyNode.yScale *= 0.8
        self.enemyNode.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.55)
        addChild(enemyNode)
        
        // Enemy health
        self.enemyHealthLabel = SKLabelNode(text: "enemyHealthLabel")
        self.currentEnemyHealth = self.enemy!.health
        
        enemyHealthLabel!.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        enemyHealthLabel!.fontSize = 17.0
        
        let enemyHealthLabelX = self.enemyNode.position.x
        let enemyHealthLabelY = self.enemyNode.position.y + 100
        enemyHealthLabel!.position = CGPoint(x: enemyHealthLabelX, y: enemyHealthLabelY)
        addChild(enemyHealthLabel!)
        
        // Enemy health bar
        self.enemyHealthBar = HealthBarNode(currentHealth: self.currentEnemyHealth, maxHealth: self.enemy!.health, width: 120)
        let enemyHealthBarX = self.enemyNode.position.x - (self.enemyHealthBar.frontBar.size.width / 2)
        let enemyHealthBarY = self.enemyNode.position.y + 120
        self.enemyHealthBar.position = CGPoint(x: enemyHealthBarX, y: enemyHealthBarY)

        addChild(self.enemyHealthBar)
        
        // Escape button
        let escapeButton = ButtonNode(defaultStateText: "Escape!", activeStateText: "Escaping...", color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {
            print("escaping?")
            self.gameEscapeDelegate?.escapeToMap()
        }
        
        escapeButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.15)
        // escapeButton.changeFontColor(to: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .standby)
        // escapeButton.changeFontColor(to: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: .active)
        addChild(escapeButton)
        
        // Attack button
        self.attackButton = ButtonNode(defaultStateText: "Attack!", activeStateText: "Attack!", color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) {
            self.currentEnemyHealth -= self.user!.power // User attacks Enemy
            self.attackButton?.isHidden = true
            
            // Wait one second and then Enemy attacks User, if Enemy is alive
            if self.currentEnemyHealth > 0 {
                let waitOne = SKAction.wait(forDuration: 1)
                self.enemyHealthLabel?.run(waitOne, completion: {
                    self.currentUserHealth -= self.enemy!.power
                    self.attackButton?.isHidden = false
                })
                
            } else {
                self.removeEnemyFromFirebase()
            }
        }
        
        let attackButtonX = escapeButton.position.x
        let attackButtonY = escapeButton.position.y + 100
        self.attackButton!.position = CGPoint(x: attackButtonX, y: attackButtonY)
        addChild(self.attackButton!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func removeEnemyFromFirebase() {
        firebase!.child("enemies").child(self.enemy!.identifier).removeValue()
    }
}
