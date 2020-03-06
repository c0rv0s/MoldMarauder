//
//  ItemShop.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/21/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class ItemShop: SKScene {
    var mute = false
    
    var backButton: SKNode! = nil
    var repelButton: SKNode! = nil
    var premiumButton: SKNode! = nil
    var xTapButton: SKNode! = nil
    var spritzButton: SKNode! = nil
    var laserButton: SKNode! = nil
    var cashWindfallButton: SKNode! = nil
    
    var buyDiamondsButton: SKNode! = nil
    
    var laserBought = 0
    var laserLabel: SKLabelNode! = nil
    var laserCostLabel: SKLabelNode! = nil
    
    let gameLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = CometLayer()
    var level : Int!
    
    //touch handler
    var touchHandler: ((String) -> ())?
    
    //for background animations
    var background = Background()

    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.start(size: size)
        addChild(background.background)
        
        addChild(cometLayer)
        
        addChild(gameLayer)
        
        
        
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        cometLayer.start(menu: false)
        
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
        let priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 16
        priceLabel.fontColor = UIColor.black
        if level < 3 {
            priceLabel.text = "Cost: 10000"
        }
            
        else if level < 29 {
            priceLabel.text = "Cost: 12000"
        }
        else {
            priceLabel.text = "Cost: 1.8 M"
        }
        //priceLabel.text = "Cost: 10000"
        priceLabel.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-25);
        addChild(priceLabel)
        
        //x100 tap
        // x tap
        Texture = SKTexture(image: UIImage(named: "times tap value")!)
        xTapButton = SKSpriteNode(texture:Texture)
        // Place in scene
        xTapButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+170)
        self.addChild(xTapButton)
        
        let priceLabel2 = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel2.fontSize = 16
        priceLabel2.fontColor = UIColor.black
        priceLabel2.text = "10 Diamods"
        priceLabel2.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+105)
        addChild(priceLabel2)
        
        // spritz
        Texture = SKTexture(image: UIImage(named: "spritz")!)
        spritzButton = SKSpriteNode(texture:Texture)
        // Place in scene
        spritzButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+40)
        self.addChild(spritzButton)
        let priceLabel3 = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel3.fontSize = 16
        priceLabel3.fontColor = UIColor.black
        priceLabel3.text = "12 Diamods"
        priceLabel3.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-25)
        addChild(priceLabel3)
        
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
        let laserfastLabel = SKLabelNode(fontNamed: "Lemondrop")
        laserfastLabel.fontSize = 13
        laserfastLabel.fontColor = UIColor.black
        laserfastLabel.text = "faster"
        laserfastLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-180)
        addChild(laserfastLabel)
        
        var cost = BInt("50000")
        switch laserBought {
        case 0:
            cost = BInt("50000")
            break
        case 1:
            cost = BInt("180000000")
            break
        case 2:
            cost = BInt("30000000000")
            break
        default:
            cost = BInt("30000000000")
            break
        }
        laserCostLabel = SKLabelNode(fontNamed: "Lemondrop")
        laserCostLabel.fontSize = 13
        laserCostLabel.fontColor = UIColor.black
        laserCostLabel.text = "Cost: \(formatNumber(points: cost))"
        laserCostLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-195)
        addChild(laserCostLabel)
        
        // Cash Windfall
        Texture = SKTexture(image: UIImage(named: "cash windfall")!)
        cashWindfallButton = SKSpriteNode(texture:Texture)
        // Place in scene
        cashWindfallButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-100);
        
        //cash winfall
        let windfallLabel = SKLabelNode(fontNamed: "Lemondrop")
        windfallLabel.fontSize = 13
        windfallLabel.fontColor = UIColor.black
        windfallLabel.text = "12 Diamonds"
        windfallLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-165)
        addChild(windfallLabel)
        
        self.addChild(cashWindfallButton)

        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            premiumButton.setScale(0.9)
            repelButton.setScale(0.9)
            xTapButton.setScale(0.9)
            spritzButton.setScale(0.9)
            laserButton.setScale(0.9)
            cashWindfallButton.setScale(0.9)
            priceLabel.setScale(0.85)
            priceLabel2.setScale(0.85)
            priceLabel3.setScale(0.85)
            laserLabel.setScale(0.85)
            laserCostLabel.setScale(0.85)
            laserfastLabel.setScale(0.85)
            windfallLabel.setScale(0.85)
            
            premiumButton.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY+120);
            repelButton.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-5);
            xTapButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+120)
            spritzButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-10)
            laserButton.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-135);
            cashWindfallButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-135)
            priceLabel.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-75);
            priceLabel2.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+55)
            priceLabel3.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-75)
            laserLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-200)
            laserCostLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-230)
            laserfastLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-215)
            windfallLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-200)
            break
        case .iPhone5:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            premiumButton.setScale(0.9)
            repelButton.setScale(0.9)
            xTapButton.setScale(0.9)
            spritzButton.setScale(0.9)
            laserButton.setScale(0.9)
            cashWindfallButton.setScale(0.9)
            priceLabel.setScale(0.85)
            priceLabel2.setScale(0.85)
            priceLabel3.setScale(0.85)
            laserLabel.setScale(0.85)
            laserCostLabel.setScale(0.85)
            laserfastLabel.setScale(0.85)
            windfallLabel.setScale(0.85)
            
            premiumButton.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY+150);
            repelButton.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY+15);
            xTapButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+150)
            spritzButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+20)
            laserButton.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-120);
            cashWindfallButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-120)
            priceLabel.position = CGPoint(x:self.frame.midX-90, y:self.frame.midY-45);
            priceLabel2.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+85)
            priceLabel3.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-45)
            laserLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-185)
            laserCostLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-215)
            laserfastLabel.position = CGPoint(x:self.frame.midX-85, y:self.frame.midY-200)
            windfallLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-185)
            break
        default:
            break
        }
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
        if buyDiamondsButton != nil {
            if buyDiamondsButton.contains(touchLocation) {
                if let handler = touchHandler {
                    handler("addDiamonds")
                }
            }
        }
    }
    
    func playSound(select: String) {
        if mute == false {
        switch select {
        case "levelup":
            run(levelUpSound)
        case "cash register":
            run(cashRegisterSound)
        case "select":
            run(selectSound)
        case "exit":
            run(exitSound)
        case "diamond pop":
            run(diamondPopSound)
        default:
            run(levelUpSound)
        }
        }
    }
    
    func addBuyDiamondsButton() {
        let reappear = SKAction.scale(to: 1.3, duration: 0.2)
        let bounce1 = SKAction.scale(to: 0.8, duration: 0.1)
        let bounce2 = SKAction.scale(to: 1, duration: 0.1)
        //this is the godo case
        let action2 = SKAction.sequence([reappear, bounce1, bounce2])
        
        let Texture = SKTexture(image: UIImage(named: "add diamonds button")!)
        buyDiamondsButton = SKSpriteNode(texture:Texture)
        // Place in scene
        buyDiamondsButton.position = CGPoint(x:self.frame.maxX - 65, y:self.frame.maxY-60);
        
        self.addChild(buyDiamondsButton)
        buyDiamondsButton.run(action2)
        playSound(select: "diamond pop")
        
        _ = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(removeDiamondButton), userInfo: nil, repeats: true)
    }
    
    @objc func removeDiamondButton() {
        let reappear = SKAction.scale(to: 1.3, duration: 0.2)
        let bounce1 = SKAction.scale(to: 0, duration: 0.1)
        let action2 = SKAction.sequence([reappear, bounce1, SKAction.removeFromParent()])
        buyDiamondsButton.run(action2)
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
}
