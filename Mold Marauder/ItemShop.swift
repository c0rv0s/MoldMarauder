//
//  ItemShop.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/21/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class ItemShop: SKScene {
    
    var backButton: SKNode! = nil
    var repelButton: SKNode! = nil
    var premiumButton: SKNode! = nil
    var xTapButton: SKNode! = nil
    var spritzButton: SKNode! = nil
    var laserButton: SKNode! = nil
    var cashWindfallButton: SKNode! = nil
    
    var laserBought = 0
    var laserLabel: SKLabelNode! = nil
    var laserCostLabel: SKLabelNode! = nil
    
    let gameLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = SKNode()
    var cometTimer: Timer!
    
    //touch handler
    var touchHandler: ((String) -> ())?
    
    //for background animations
    var backframes = [SKTexture]()
    let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "cyber_menu_glow")!))
    //comet sprites
    var cometSprite: SKNode! = nil
    var cometSprite2: SKNode! = nil
    
    let levelUpSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let cashRegisterSound = SKAction.playSoundFileNamed("cash register.wav", waitForCompletion: false)
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
        
        addChild(gameLayer)
        
        
        
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        animateComets()
        cometTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(animateComets), userInfo: nil, repeats: true)
        
       createButton()
    }
    
    func createButton()
    {
        // BACK MENU
        var Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+190);
        
        self.addChild(backButton)
        
        // premium
        Texture = SKTexture(image: UIImage(named: "Premium Shop")!)
        premiumButton = SKSpriteNode(texture:Texture)
        // Place in scene
        premiumButton.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY+170);
        self.addChild(premiumButton)

        
        // repellant
        Texture = SKTexture(image: UIImage(named: "repellant")!)
        repelButton = SKSpriteNode(texture:Texture)
        // Place in scene
        repelButton.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY+35);
        self.addChild(repelButton)
        
        //repellant price
        var priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 16
        priceLabel.fontColor = UIColor.black
        priceLabel.text = "Cost: 10000"
        priceLabel.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-25);
        addChild(priceLabel)
        
        //x100 tap
        // x tap
        Texture = SKTexture(image: UIImage(named: "times tap value")!)
        xTapButton = SKSpriteNode(texture:Texture)
        // Place in scene
        xTapButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+170)
        self.addChild(xTapButton)
        
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 16
        priceLabel.fontColor = UIColor.black
        priceLabel.text = "10 Diamods"
        priceLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+105)
        addChild(priceLabel)
        
        // spritz
        Texture = SKTexture(image: UIImage(named: "spritz")!)
        spritzButton = SKSpriteNode(texture:Texture)
        // Place in scene
        spritzButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+40)
        self.addChild(spritzButton)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 16
        priceLabel.fontColor = UIColor.black
        priceLabel.text = "20 Diamods"
        priceLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-25)
        addChild(priceLabel)
        
        // worm laser
        if laserBought < 3 {
            Texture = SKTexture(image: UIImage(named: "upgrade laser \(laserBought + 1)")!)
        }
        else {
            Texture = SKTexture(image: UIImage(named: "upgrade laser bought")!)
        }
        laserButton = SKSpriteNode(texture:Texture)
        // Place in scene
        laserButton.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-100);
        
        self.addChild(laserButton)
        //laser descrip
        laserLabel = SKLabelNode(fontNamed: "Lemondrop")
        laserLabel.fontSize = 13
        laserLabel.fontColor = UIColor.black
        laserLabel.text = "Kill worms \((laserBought + 1)*16)%"
        laserLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-165)
        addChild(laserLabel)
        
        //laser descrip
        var laserfastLabel = SKLabelNode(fontNamed: "Lemondrop")
        laserfastLabel.fontSize = 13
        laserfastLabel.fontColor = UIColor.black
        laserfastLabel.text = "faster"
        laserfastLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-180)
        addChild(laserfastLabel)
        
        var cost = 50000
        switch laserBought {
        case 0:
            cost = 50000
            break
        case 1:
            cost = 180000
            break
        case 2:
            cost = 3000000
            break
        default:
            cost = 3000000
            break
        }
        laserCostLabel = SKLabelNode(fontNamed: "Lemondrop")
        laserCostLabel.fontSize = 13
        laserCostLabel.fontColor = UIColor.black
        laserCostLabel.text = "Cost: \(cost)"
        laserCostLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-195)
        addChild(laserCostLabel)
        
        // Cash Windfall
        Texture = SKTexture(image: UIImage(named: "cash windfall")!)
        cashWindfallButton = SKSpriteNode(texture:Texture)
        // Place in scene
        cashWindfallButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-100);
        
        //cash winfall
        var windfallLabel = SKLabelNode(fontNamed: "Lemondrop")
        windfallLabel.fontSize = 13
        windfallLabel.fontColor = UIColor.black
        windfallLabel.text = "15 Diamonds"
        windfallLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-165)
        addChild(windfallLabel)
        
        self.addChild(cashWindfallButton)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the back button's bounds
        if backButton.contains(touchLocation) {
            print("back")
            if let handler = touchHandler {
                handler("back")
            }
        }
        if repelButton.contains(touchLocation) {
            print("repel")
            if let handler = touchHandler {
                handler("repel")
            }
        }
        if premiumButton.contains(touchLocation) {
            print("premium")
            if let handler = touchHandler {
                handler("premium")
            }
        }
        if xTapButton.contains(touchLocation) {
            print("xTap")
            if let handler = touchHandler {
                handler("xTap")
            }
        }
        if spritzButton.contains(touchLocation) {
            print("spritz")
            if let handler = touchHandler {
                handler("spritz")
            }
        }
        if laserButton.contains(touchLocation) {
            if laserBought < 3 {
                print("laser")
                if let handler = touchHandler {
                    handler("laser")
                }
            }
        }
        if cashWindfallButton.contains(touchLocation) {
            print("smallwindfall")
            if let handler = touchHandler {
                handler("smallwindfall")
            }
        }
        
    }
    
    func playSound(select: String) {
        switch select {
        case "levelup":
            run(levelUpSound)
        case "cash register":
            run(cashRegisterSound)
        case "select":
            run(selectSound)
        case "exit":
            run(exitSound)
        default:
            run(levelUpSound)
        }
    }
    
    func animateName(name: String) {
        // Figure out what the midpoint of the chain is.
        let centerPosition = CGPoint(
            x: (point.x),
            y: (point.y + 10))
        
        // Add a label for the score that slowly floats up.
        let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
        scoreLabel.fontSize = 28
        scoreLabel.text = name
        scoreLabel.position = centerPosition
        scoreLabel.zPosition = 300
        gameLayer.addChild(scoreLabel)
        
        let ranX = Int(arc4random_uniform(40)) - 20
        let ranY = Int(arc4random_uniform(25) + 1)
        let Y = ranY + 120
        let moveAction = SKAction.move(by: CGVector(dx: ranX, dy: Y), duration: 3)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }
    
    func animateComets() {
        let comet = SKTexture(image: UIImage(named: "comet")!)
        let comet180 = SKTexture(image: UIImage(named: "comet180")!)
        let cometUp = SKTexture(image: UIImage(named: "cometUp")!)
        let cometDown = SKTexture(image: UIImage(named: "cometDown")!)
        
        //left or right
        let side = Int(arc4random_uniform(4))
        let y = randomInRange(lo: Int(self.frame.minY), hi: Int(self.frame.maxY))
        let x = randomInRange(lo: Int(self.frame.minX), hi: Int(self.frame.maxX))
        if side == 1{
            cometSprite = SKSpriteNode(texture:comet)
            cometSprite.position = CGPoint(x: -500, y: y)
            cometLayer.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: 500,y: y), duration:0.6)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:comet)
            cometSprite2.position = CGPoint(x: -500, y: y + 30)
            cometLayer.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: 500,y: y + 30), duration:0.6)
            cometSprite2.run(SKAction.sequence([moveTwo]))
            
        }
        if side == 2 {
            cometSprite = SKSpriteNode(texture:cometUp)
            cometSprite.position = CGPoint(x: x, y: -700)
            cometLayer.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: x,y: 700), duration:0.8)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:cometUp)
            cometSprite2.position = CGPoint(x: x + 30, y: -700)
            cometLayer.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: x + 30,y: 700), duration:0.8)
            cometSprite2.run(SKAction.sequence([moveTwo]))
        }
        if side == 3 {
            cometSprite = SKSpriteNode(texture:cometDown)
            cometSprite.position = CGPoint(x: x, y: 700)
            cometLayer.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: x,y: -700), duration:0.8)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:cometDown)
            cometSprite2.position = CGPoint(x: x - 30, y: 700)
            cometLayer.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: x - 30,y: -700), duration:0.8)
            cometSprite2.run(SKAction.sequence([moveTwo]))
        }
        else {
            cometSprite = SKSpriteNode(texture:comet180)
            cometSprite.position = CGPoint(x: 500, y: y)
            cometLayer.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: -500,y: y), duration:0.6)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:comet180)
            cometSprite2.position = CGPoint(x: 500, y: y - 30)
            cometLayer.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: -500,y: y - 30), duration:0.6)
            cometSprite2.run(SKAction.sequence([moveTwo]))
        }
        
    }

    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
}
