//
//  MenuScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/3/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class MenuScene: SKScene {
    
    var buyButton: SKNode! = nil
    var exitButton: SKNode! = nil
    var cheatButton: SKNode! = nil
    var resetButton: SKNode! = nil
    var breedButton: SKNode! = nil
    var levelButton: SKNode! = nil
    var itemButton: SKNode! = nil
    var achieveButton: SKNode! = nil
    var creditsButton: SKNode! = nil
    var questButton: SKNode! = nil
    
    //comet sprites
    var cometSprite1: SKNode! = nil
    var cometSprite2: SKNode! = nil
    var cometTimer: Timer!
    
    var touchHandler: ((String) -> ())?
    
    var backframes = [SKTexture]()
    let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "cyber_menu_glow")!))
    var cometLayer = SKNode()
    
    let levelUpSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let selectSound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
    let exitSound = SKAction.playSoundFileNamed("exit.mp3", waitForCompletion: false)
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.size = size
        backframes.append(SKTexture(image: UIImage(named: "cyber_menu_glow")!))
        backframes.append(SKTexture(image: UIImage(named: "cyber_menu_glow F2")!))
        backframes.append(SKTexture(image: UIImage(named: "cyber_menu_glow F3")!))
        addChild(background)
        background.run(SKAction.repeatForever(
            SKAction.animate(with: backframes,
                             timePerFrame: 0.15,
                             resize: false,
                             restore: true)),
                       withKey:"background")
        
        addChild(cometLayer)
        
        createButton()
        
        
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        animateComets()
        cometTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(animateComets), userInfo: nil, repeats: true)
        
    }
    
    func animateComets() {
        let comet = SKTexture(image: UIImage(named: "comet")!)
        let comet180 = SKTexture(image: UIImage(named: "comet180")!)
        let cometUp = SKTexture(image: UIImage(named: "cometUp")!)
        let cometDown = SKTexture(image: UIImage(named: "cometDown")!)
        
        //left or right
        let side = Int(arc4random_uniform(2))
        let y = randomInRange(lo: Int(self.frame.minY), hi: Int(self.frame.maxY))
        if side == 1{
            cometSprite1 = SKSpriteNode(texture:comet)
            cometSprite1.position = CGPoint(x: -500, y: y)
            cometLayer.addChild(cometSprite1)
            
            let moveHoriz = SKAction.move(to: CGPoint(x: 500,y: y), duration:0.7)
            cometSprite1.run(moveHoriz)
            
            let up = Int(arc4random_uniform(2))
            let x = randomInRange(lo: Int(self.frame.minX), hi: Int(self.frame.maxX))
            if up == 1 {
                cometSprite2 = SKSpriteNode(texture:cometUp)
                cometSprite2.position = CGPoint(x: x, y: -700)
                cometLayer.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: 700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
            else {
                cometSprite2 = SKSpriteNode(texture:cometDown)
                cometSprite2.position = CGPoint(x: x, y: 700)
                cometLayer.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: -700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
            
        }
        else {
            cometSprite1 = SKSpriteNode(texture:comet180)
            cometSprite1.position = CGPoint(x: 500, y: y)
            cometLayer.addChild(cometSprite1)
            
            let moveHoriz = SKAction.move(to: CGPoint(x: -500,y: y), duration:0.7)
            cometSprite1.run(moveHoriz)
            
            let up = Int(arc4random_uniform(2))
            let x = randomInRange(lo: Int(self.frame.minX), hi: Int(self.frame.maxX))
            if up == 1 {
                cometSprite2 = SKSpriteNode(texture:cometUp)
                cometSprite2.position = CGPoint(x: x, y: -700)
                cometLayer.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: 700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
            else {
                cometSprite2 = SKSpriteNode(texture:cometDown)
                cometSprite2.position = CGPoint(x: x, y: 700)
                cometLayer.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: -700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
        }
    }
    
    func createButton()
    {
        // BUY
        var Texture = SKTexture(image: UIImage(named: "mold shoppe")!)
        buyButton = SKSpriteNode(texture:Texture)
        // Place in scene
        buyButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+100);
        
        self.addChild(buyButton)
        
        // EXIT MENU
        Texture = SKTexture(image: UIImage(named: "exit")!)
        exitButton = SKSpriteNode(texture:Texture)
        // Place in scene
        exitButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+190);
        
        self.addChild(exitButton)
        
        // BREED BUTTON
        Texture = SKTexture(image: UIImage(named: "breed")!)
        breedButton = SKSpriteNode(texture:Texture)
        // Place in scene
        breedButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+50);
        
        self.addChild(breedButton)
        
        // ITEMS BUTTON
        Texture = SKTexture(image: UIImage(named: "items")!)
        itemButton = SKSpriteNode(texture:Texture)
        // Place in scene
        itemButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY);
        
        self.addChild(itemButton)
        
        // ACHIEVEMETNS BUTTON
        Texture = SKTexture(image: UIImage(named: "achievements")!)
        achieveButton = SKSpriteNode(texture:Texture)
        // Place in scene
        achieveButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY-50);
        
        self.addChild(achieveButton)
        
        // CREDITS BUTTON
        Texture = SKTexture(image: UIImage(named: "credits button")!)
        creditsButton = SKSpriteNode(texture:Texture)
        // Place in scene
        creditsButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY-100);
        
        self.addChild(creditsButton)
        
        // QUEST BUTTON
        Texture = SKTexture(image: UIImage(named: "quest button")!)
        questButton = SKSpriteNode(texture:Texture)
        // Place in scene
        questButton.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+150)
        
        self.addChild(questButton)
        
        // CHEAT BUTTON
        Texture = SKTexture(image: UIImage(named: "cheat")!)
        cheatButton = SKSpriteNode(texture:Texture)
        // Place in scene
        cheatButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-150);
        
        self.addChild(cheatButton)
        
        // RESET BUTTON
        Texture = SKTexture(image: UIImage(named: "reset")!)
        resetButton = SKSpriteNode(texture:Texture)
        // Place in scene
        resetButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-200);
        
        self.addChild(resetButton)
        
        //level button
        Texture = SKTexture(image: UIImage(named: "level_up")!)
        levelButton = SKSpriteNode(texture: Texture)
        // Place in scene
        levelButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+150);
        
        self.addChild(levelButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if buyButton.contains(touchLocation) {
            print("buy!")
            if let handler = touchHandler {
                handler("buy")
            }
        }
        if exitButton.contains(touchLocation) {
            print("E X I T")
            if let handler = touchHandler {
                handler("exit")
            }
        }
        if cheatButton.contains(touchLocation) {
            print("cheater :(")
            if let handler = touchHandler {
                handler("cheat")
            }
        }
        if resetButton.contains(touchLocation) {
            print("reset")
            if let handler = touchHandler {
                handler("reset")
            }
        }
        if breedButton.contains(touchLocation) {
            print("sexy-tieemmm")
            if let handler = touchHandler {
                handler("breed")
            }
        }
        if levelButton.contains(touchLocation) {
            print("levle")
            if let handler = touchHandler {
                handler("level")
            }
        }
        if itemButton.contains(touchLocation) {
            print("item shop entrance")
            if let handler = touchHandler {
                handler("item")
            }
        }
        if achieveButton.contains(touchLocation) {
            print("achievemnts")
            if let handler = touchHandler {
                handler("achieve")
            }
        }
        if creditsButton.contains(touchLocation) {
            print("credits")
            if let handler = touchHandler {
                handler("credits")
            }
        }
        if questButton.contains(touchLocation) {
            print("quest")
            if let handler = touchHandler {
                handler("quest")
            }
        }
        
    }
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    func playSound(select: String) {
        switch select {
        case "levelup":
            run(levelUpSound)
        case "select":
            run(selectSound)
        case "exit":
            run(exitSound)
        default:
            run(levelUpSound)
        }
    }
    
}
