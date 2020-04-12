//
//  GameScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 1/31/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
import StoreKit

class GameScene: SKScene {
    var mute = false
    var header: SKNode!
    var buyButton: SKNode!
    var diamondIcon: SKNode!
    var diamondCLabel: SKLabelNode!
    var diamondBuy: SKNode!
    
    var buyEnabled = true
    var claimQuestButton: SKNode!
    
    var numDiamonds: Int!
    var diamondShop = false
    
    var backgroundName = "cave"
    
    var diamondTiny: SKNode!
    var diamondSmall: SKNode!
    var diamondMedium: SKNode!
    var diamondLarge: SKNode!
    var exitDiamond: SKNode!
    var diamondShelves: SKSpriteNode!
    var products = [SKProduct]()
    
    var tinyButton: SKSpriteNode!
    var smallButton: SKSpriteNode!
    var mediumButton: SKSpriteNode!
    var largeButton: SKSpriteNode!
    
    var menuPopUp: SKSpriteNode!
    
    var inventoryButton: SKNode!
    var cameraButton: SKNode!
    
    var tapPoint: BInt!
    
    var molds: Array<Mold>!
    //var worms = [SKSpriteNode]()
    var wormHP = [Int]()
    var wormChompTimers = [Timer]()
    var wormRepel = false
    var eventTimer: Timer!
    var wormDifficulty = 6
    var wormRepelLabel: SKLabelNode!
    var deathRay = false
    var laserPower = 0
    
    var reinvestCount = 0
    
    var xTap = false
    
    //cards
    let cardLayer = SKNode()
    var card1: SKNode!
    var card2: SKNode!
    var card3: SKNode!
    var revealCards: SKNode!
    var cardsActive = false
    var okButton: SKNode!
    var changeEffectButton: SKNode!
    var cardSelected = false
    var cardRevealed = false
    var selectedNum = 0
    var selectedArray = [Int]()
    //card effects
    
    //fairy
    let fairyLayer = SKNode()
    var fairyCounter = 0
    var fairyTimer: Timer!
    
    var touchedPoints = [CGPoint]() // point history
    var fitResult = CircleResult() // information about how circle-like is the path
    var tolerance: CGFloat = 0.2 // circle wiggle room
    var isCircle = false
    var path = CGMutablePath() // running CGPath - helps with drawing

    
    //sleep
    var sleepButton: SKNode!
    
    //spritz and xtap
    var spritzLabel: SKLabelNode!
    var xTapLabel: SKLabelNode!
    
    var center:  CGPoint!
    var tapLoc: CGPoint!
    
    var kfPoint: CGPoint!
    
    let gameLayer = SKNode()
    let holeLayer = SKNode()
    let moldLayer = SKNode()
    let diamondLayer = SKNode()
    let wormLayer = SKNode()
    let deadLayer = SKNode()
    let sleepLayer = SKNode()
    let kissOrFightLayer = SKNode()
    let tutorialLayer = SKNode()
    var deadFrames = [SKTexture]()
    var laserFrames = [SKTexture]()
    
    let eventLayer = SKNode()
    
    var background: SKSpriteNode!
    
    var touchHandler: ((String) -> ())?

    var animateTimer: Timer!
    
    var selectedNode = SKNode()
    
    var isActive = true
//    hold the mold name to level it
    var currType = ""
    
    //tutorial
    var tutorial = 0
    
    var dream: Dream!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background = SKSpriteNode(imageNamed: backgroundName)
        background.size = size
        addChild(background)
        
        if ((molds) != nil) {
            updateMolds()
        }
        
        var i = 1
        let numFrames = 3
        while(i <= numFrames) {
            deadFrames.append(SKTexture(image: UIImage(named: "worm dead")!))
            deadFrames.append(SKTexture(image: UIImage(named: "worm dead 2")!))
            i += 1
        }

        i = 1
        let numFramesLaser = 4
        while(i <= numFramesLaser) {
            laserFrames.append(SKTexture(image: UIImage(named: "aShot \(i)")!))
            i += 1
        }
        
        dream = Dream(midY: self.frame.midY, maxY: self.frame.maxY, minX: self.frame.minX, maxX: self.frame.maxX)
        addChild(dream)
        addChild(gameLayer)
        addChild(moldLayer)
        diamondLayer.zPosition = 700
        addChild(diamondLayer)
        
        addChild(wormLayer)
        wormLayer.zPosition = 500
        addChild(deadLayer)
        deadLayer.zPosition = 500
        addChild(fairyLayer)
        cardLayer.zPosition = 600
        addChild(cardLayer)
        sleepLayer.zPosition = 800
        addChild(sleepLayer)
        addChild(holeLayer)
        holeLayer.zPosition = 400
        
        createButton()
        
        center = CGPoint(x:self.frame.midX, y:self.frame.midY)
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    override func didMove(to view: SKView) {
        //EVENT TRIGGER TIMER
        if let handler = touchHandler {
            handler("reactivate timers")
        }
    }
    
    func setBackground() {
        let disappear = SKAction.scale(to: 0, duration: 0.3)
        let action = SKAction.sequence([disappear])
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.background.texture = SKTexture(imageNamed: self.backgroundName)
            let reappear = SKAction.scale(to: 1.1, duration: 0.2)
            let bounce1 = SKAction.scale(to: 0.89, duration: 0.1)
            let bounce2 = SKAction.scale(to: 1, duration: 0.1)
            //this is the godo case
            let action2 = SKAction.sequence([reappear, bounce1, bounce2])
            self.background.run(action2)
        }
        background.run(action)
        dream.reset()
        if backgroundName == "dream" {
            dream.start(stars: true, clouds: true, starsHigher: false)
        }
        if backgroundName == "yurt" {
            dream.start(stars: false, clouds: true, starsHigher: false)
        }
        if backgroundName == "apartment" {
            dream.start(stars: true, clouds: false, starsHigher: true)
        }
    }
    
    func createButton() {
        //HEADER
        var Texture = SKTexture(image: UIImage(named: "header")!)
        header = SKSpriteNode(texture: Texture)
        header.setScale(0.42)
        // Place in scene
        header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+350);
        
        // BUY
        Texture = SKTexture(image: UIImage(named: "BUY")!)
        buyButton = SKSpriteNode(texture: Texture)
        // Place in scene
        buyButton.position = CGPoint(x:self.frame.midX+110, y:self.frame.midY+350);
        
        //DIAMOND ICON
        Texture = SKTexture(image: UIImage(named: "diamond")!)
        diamondIcon = SKSpriteNode(texture: Texture)
        diamondIcon.position = CGPoint(x:self.frame.midX-120, y:self.frame.midY+350);
        
        //DIAMOND BUY
        Texture = SKTexture(image: UIImage(named: "plus")!)
        diamondBuy = SKSpriteNode(texture: Texture)
        diamondBuy.position = CGPoint(x:self.frame.midX-155, y:self.frame.midY+350);
        
        // DIAMOND LABEL
        diamondCLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondCLabel.fontSize = 18
        diamondCLabel.fontColor = UIColor.black
        diamondCLabel.text = ""
        diamondCLabel.position = CGPoint(x:self.frame.midX-75, y:self.frame.midY+342);
       
//    adjust for screen sizes
        switch UIDevice().screenType {
        case .iPhone4:
            header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+235);
            buyButton.position = CGPoint(x:self.frame.midX+110, y:self.frame.midY+235);
            diamondIcon.position = CGPoint(x:self.frame.midX-120, y:self.frame.midY+235);
            diamondBuy.position = CGPoint(x:self.frame.midX-155, y:self.frame.midY+235);
            diamondCLabel.position = CGPoint(x:self.frame.midX-75, y:self.frame.midY+227);
            break
        case .iPhone5:
            //iPhone 5
            header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+275);
            buyButton.position = CGPoint(x:self.frame.midX+110, y:self.frame.midY+275);
            diamondIcon.position = CGPoint(x:self.frame.midX-120, y:self.frame.midY+275);
            diamondBuy.position = CGPoint(x:self.frame.midX-155, y:self.frame.midY+275);
            diamondCLabel.position = CGPoint(x:self.frame.midX-75, y:self.frame.midY+267);
            break
        case .iPhone8Plus:
            // Code for iPhone 6 Plus & iPhone 7 Plus
            buyButton.setScale(0.9)
            diamondIcon.setScale(0.7)
            diamondBuy.setScale(0.9)
            diamondCLabel.fontSize = 15
            header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+300)
            buyButton.position = CGPoint(x:self.frame.midX+105, y:self.frame.midY+300)
            diamondIcon.position = CGPoint(x:self.frame.midX-120, y:self.frame.midY+300)
            diamondBuy.position = CGPoint(x:self.frame.midX-150, y:self.frame.midY+300)
            diamondCLabel.position = CGPoint(x:self.frame.midX-80, y:self.frame.midY+292)
            break
        case .iPhoneX:
            header.setScale(0.4)
            buyButton.setScale(0.9)
            diamondIcon.setScale(0.8)
            diamondBuy.setScale(0.9)
            diamondCLabel.fontSize = 15
            diamondIcon.position = CGPoint(x:self.frame.midX-110, y:self.frame.midY+350);
            diamondBuy.position = CGPoint(x:self.frame.midX-142, y:self.frame.midY+350);
            diamondCLabel.position = CGPoint(x:self.frame.midX-75, y:self.frame.midY+342);
            header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+350);
            buyButton.position = CGPoint(x:self.frame.midX+110, y:self.frame.midY+350);
            break
        default:
            break
        }
//    now place the elements
        self.addChild(header)
        self.addChild(buyButton)
        self.addChild(diamondIcon)
        self.addChild(diamondBuy)
        self.addChild(diamondCLabel)
        
        //CAMERA
        Texture = SKTexture(image: UIImage(named: "camera")!)
        cameraButton = SKSpriteNode(texture: Texture)
        cameraButton.position = CGPoint(x:self.frame.maxX - 40, y:self.frame.minY + 100);
        self.addChild(cameraButton)
        
        //INVENTORY BUTTON
        Texture = SKTexture(image: UIImage(named: "inventory button")!)
        inventoryButton = SKSpriteNode(texture: Texture)
        inventoryButton.position = CGPoint(x:self.frame.maxX - 40, y:self.frame.minY + 40);
        self.addChild(inventoryButton)
        
        wormRepelLabel = SKLabelNode(fontNamed: "Lemondrop")
        wormRepelLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+250)
        self.addChild(wormRepelLabel)
        
        spritzLabel = SKLabelNode(fontNamed: "Lemondrop")
        spritzLabel.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+250)
        spritzLabel.fontColor = UIColor.yellow
        self.addChild(spritzLabel)
        
        xTapLabel = SKLabelNode(fontNamed: "Lemondrop")
        xTapLabel.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+250)
        xTapLabel.fontColor = UIColor.green
        self.addChild(xTapLabel)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 4
            cameraButton.position = CGPoint(x:self.frame.maxX - 40, y:self.frame.minY + 140);
            inventoryButton.position = CGPoint(x:self.frame.maxX - 40, y:self.frame.minY + 80);
            wormRepelLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+130)
            spritzLabel.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+130)
            xTapLabel.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+130)
            wormRepelLabel.setScale(0.75)
            spritzLabel.setScale(0.75)
            xTapLabel.setScale(0.75)
            break
        case .iPhone5:
            //iPhone 5
            wormRepelLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+170)
            spritzLabel.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+170)
            xTapLabel.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+170)
            wormRepelLabel.setScale(0.75)
            spritzLabel.setScale(0.75)
            xTapLabel.setScale(0.75)
            break
        case .iPhone8:
            cameraButton.position.y += 80
            inventoryButton.position.y += 80
            header.position.y -= 50
            buyButton.position.y -= 50
            diamondIcon.position.y -= 50
            diamondIcon.setScale(0.8)
            diamondCLabel.fontSize = 14
            diamondBuy.position.y -= 50
            diamondCLabel.position.y -= 50
            diamondCLabel.position.x -= 10
            wormRepelLabel.position.y -= 20
            spritzLabel.position.y -= 20
            xTapLabel.position.y -= 20
            break
        case .iPhone8Plus:
            cameraButton.position.y += 80
            inventoryButton.position.y += 80
            wormRepelLabel.position.y -= 20
            spritzLabel.position.y -= 20
            xTapLabel.position.y -= 20
            break
        default:
            break
        }
        
        self.diamondShop = false
    }
    
    //MARK: - TOUCHES
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
        // now that the user has stopped touching, figure out if the path was a circle
        fitResult = fitCircle(touchedPoints)
        isCircle = fitResult.error <= tolerance
        
        // Stop node from moving to touch
        if let handler = touchHandler {
            handler("tap ended")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard let touch = touches.first else { return }
        tapLoc = touch.location(in: gameLayer)

        if tutorial == 1 {
            if let handler = touchHandler {
                handler("tutorial next")
            }
        }
        if tutorial > 1 && tutorial < 10 {
            tutorial += 1
        }
        if tutorial == 10 {
            buyEnabled = true
            tutorialLayer.removeAllChildren()
            buyMoldTutorial()
        }
        
        //metaphase mold tapped
        if atPoint(touch.location(in: moldLayer)).name == MoldType.metaphase.spriteName {
            let hex = SKSpriteNode(imageNamed: "hex_pattern")
            hex.size = self.size
            hex.alpha = 0.0
            gameLayer.addChild(hex)
            hex.run(SKAction.sequence([SKAction.fadeIn(withDuration: 0.2), SKAction.fadeOut(withDuration: 0.8), SKAction.removeFromParent()]))
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            

// do te buttons
            if sleepButton != nil {
                if node == sleepButton {
                    if let handler = touchHandler {
                        handler("awake")
                    }
                }
            }
            else if node == buyButton {
                if eventTimer != nil {
                    eventTimer.invalidate()
                }
                eventTimer = nil
                if let handler = touchHandler {
                    handler("game_scene_buy")
                }
            }
            else if node == inventoryButton {
                if eventTimer != nil {
                    eventTimer.invalidate()
                }
                eventTimer = nil
                if let handler = touchHandler {
                    handler("game_scene_inventory")
                }
            }
            else if node == cameraButton {
                if let handler = touchHandler {
                    handler("game_scene_camera")
                }
            }
            else if node == diamondBuy {
                if eventTimer != nil {
                    eventTimer.invalidate()
                }
                eventTimer = nil
                if let handler = touchHandler {
                    handler("diamond_buy")
                }
            }
            else if claimQuestButton != nil {
                if node == claimQuestButton {
                    
                    if eventTimer != nil {
                        eventTimer.invalidate()
                    }
                    eventTimer = nil
                    if let handler = touchHandler {
                        handler("claim quest")
                    }
                }
            }
// hadnel the cards
            else if cardsActive {
                if cardSelected == false{
                    if card1 != nil {
                        if node == card1 {
                            if let handler = touchHandler {
                                handler("card1")
                            }
                            cardSelected = true
                        }
                    }
                    if card2 != nil {
                        if node == card2 {
                            if let handler = touchHandler {
                                handler("card2")
                            }
                            cardSelected = true
                        }
                    }
                    if card3 != nil {
                        if node == card3 {
                            if let handler = touchHandler {
                                handler("card3")
                            }
                            cardSelected = true
                        }
                    }
                    if revealCards != nil {
                        if node == revealCards {
                            //cardRevealed = true
                            if let handler = touchHandler {
                                handler("revealCards")
                            }
                        }
                    }
                    
                }
                if cardSelected {
                    if okButton != nil {
                        if node == okButton {
                            if let handler = touchHandler {
                                handler("okButton")
                            }
                        }
                    }
                    if changeEffectButton != nil {
                        if node == changeEffectButton {
                            if let handler = touchHandler {
                                handler("changeEffect")
                            }
                        }
                    }
                }
            }
            else {
                // tap for point and coins
                if let handler = touchHandler {
                    handler("tap")
                }
                //Boop the worms
                let wormBoop = touch.location(in: wormLayer)
                let boopedWorm = wormLayer.atPoint(wormBoop)
                if boopedWorm is SKSpriteNode {
                    let index = wormLayer.children.firstIndex(of: boopedWorm)
                    //laser animation
                    let rotation = Int(arc4random_uniform(15)) * 24
                    let finalLaserFrame = laserFrames[3]
                    let laserPic = SKSpriteNode(texture:finalLaserFrame)
                    laserPic.position = boopedWorm.position
                    let rotateR = SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.01)
                    let actionST = SKAction.sequence([rotateR])
                    laserPic.run(actionST)
                    deadLayer.addChild(laserPic)
                    playSound(select: "laser")
                    laserPic.run(SKAction.sequence([SKAction.animate(with: laserFrames,
                                                                    timePerFrame: 0.1,
                                                                    resize: false,
                                                                    restore: true), SKAction.removeFromParent()]))
                    if deathRay {
                        wormHP[index ?? 0] = 0
                    }
                    else {
                        wormHP[index ?? 0] -= 1
                    }
                                
                    if wormHP[index ?? 0] == 0 {
                        //wurm ded
                        if let handler = touchHandler {
                            handler("wurmded")
                        }
                        wormHP.remove(at: index ?? 0)
                        wormChompTimers[index ?? 0].invalidate()
                        wormChompTimers.remove(at: index ?? 0)
                        wormLayer.removeChildren(in: [boopedWorm])
                        //animate dead worm
                        let finalFrame = deadFrames[0]
                        let deadPic = SKSpriteNode(texture:finalFrame)
                        deadPic.position = boopedWorm.position
                        deadLayer.addChild(deadPic)
                        playSound(select: "dead")
                        deadPic.run(SKAction.sequence([SKAction.animate(with: deadFrames,
                                                                         timePerFrame: 0.1,
                                                                         resize: false,
                                                                         restore: true), SKAction.removeFromParent()]))
                        //one in 6 chance to get diamond
                        let diamondGrab = Int(arc4random_uniform(15))
                        if  diamondGrab == 1 ||  diamondGrab == 2 {
                            if let handler = touchHandler {
                                handler("addDiamond")
                            }
                            //animate dimmond
                            let Texture = SKTexture(image: UIImage(named: "diamond_glow")!)
                            let animDiamond = SKSpriteNode(texture:Texture)
                            animDiamond.position = wormBoop
                            deadLayer.addChild(animDiamond)
                            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                            moveAction.timingMode = .easeOut
                            playSound(select: "gem collect")
                            animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                        }
                        // 1 in 12 t oget 2 diamonds
                        if  diamondGrab == 3 {
                            if let handler = touchHandler {
                                handler("add2Diamond")
                            }
                            //animate dimmond
                            let Texture = SKTexture(image: UIImage(named: "diamond_glow_double")!)
                            let animDiamond = SKSpriteNode(texture:Texture)
                            animDiamond.position = wormBoop
                            deadLayer.addChild(animDiamond)
                            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                            moveAction.timingMode = .easeOut
                            playSound(select: "gem collect")
                            animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                        }
                    }
                }

                // black hole, chance to get a diamond
                let holeBonk = touch.location(in: holeLayer)
                for hole in holeLayer.children {
                    if hole.contains(holeBonk) {
                        if randomInRange(lo: 1, hi: 20) == 5 {
                            if let handler = touchHandler {
                                handler("addDiamond")
                            }
                            //animate dimmond
                            let Texture = SKTexture(image: UIImage(named: "diamond_glow")!)
                            let animDiamond = SKSpriteNode(texture:Texture)
                            animDiamond.position = holeBonk
                            deadLayer.addChild(animDiamond)
                            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                            moveAction.timingMode = .easeOut
                            playSound(select: "gem collect")
                            animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                        }
                    }
                }
// diamonds purchase in the shop
                if diamondShop {
                    if exitDiamond != nil {
                        if node == exitDiamond {
                            reactivateTimer()
                            if let handler = touchHandler {
                                handler("diamond_exit")
                            }
                        }
                    }
                    if tinyButton != nil {
                        if node == tinyButton {
                            if let handler = touchHandler {
                                handler("diamond_tiny")
                            }
                        }
                    }
                    if smallButton != nil {
                        if node == smallButton {
                            if let handler = touchHandler {
                                handler("diamond_small")
                            }
                        }
                    }
                    if mediumButton != nil {
                        if node == mediumButton {
                            if let handler = touchHandler {
                                handler("diamond_medium")
                            }
                        }
                    }
                    if largeButton != nil {
                        if node == largeButton {
                            if let handler = touchHandler {
                                handler("diamond_large")
                            }
                        }
                    }
                }
                else {
                    selectNodeForTouch(touchLocation: location)
                }
            }
            // if its a mold animate the heart
            if node.name != nil {
                if node.name!.count > 5 {
                    //animate heart
                    var Texture = SKTexture(image: UIImage(named: "heart_emoji")!)
                    let rando = randomInRange(lo: 1, hi: 6)
                    switch rando {
                    case 1:
                        Texture = SKTexture(image: UIImage(named: "heart_emoji_aqua")!)
                        break
                    case 2:
                        Texture = SKTexture(image: UIImage(named: "heart_emoji_gold")!)
                        break
                    case 3:
                        Texture = SKTexture(image: UIImage(named: "heart_emoji_indigo")!)
                        break
                    case 4:
                        Texture = SKTexture(image: UIImage(named: "heart_emoji_red")!)
                        break
                    case 5:
                        Texture = SKTexture(image: UIImage(named: "heart_emoji_seafoam")!)
                        break
                    default:
                        Texture = SKTexture(image: UIImage(named: "heart_emoji")!)
                        break
                    }
                    
                    let heart = SKSpriteNode(texture:Texture)
                    heart.position = node.position
                    self.addChild(heart)
                    let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 80), duration: 1.2)
                    moveAction.timingMode = .easeOut
                    playSound(select: "kiss")
                    let rando2 = randomInRange(lo: 0, hi: 1)
                    if rando2 == 0 {
                        heart.run(SKAction.sequence([
                            .group([ moveAction,
                                     .sequence([.rotate(byAngle: .pi / 8, duration: 0.3),
                                                .rotate(byAngle: .pi / (-4), duration: 0.6),
                                                .rotate(byAngle: .pi / 8, duration: 0.3)
                                        ])
                                ]),
                            SKAction.fadeOut(withDuration: (0.35)),
                            SKAction.removeFromParent()]))
                    }
                    else {
                        heart.run(SKAction.sequence([
                            .group([ moveAction,
                                     .sequence([.rotate(byAngle: .pi / (-8), duration: 0.3),
                                                .rotate(byAngle: .pi / (4), duration: 0.6),
                                                .rotate(byAngle: .pi / (-8), duration: 0.3)
                                        ])
                                ]),
                            SKAction.fadeOut(withDuration: (0.35)),
                            SKAction.removeFromParent()]))
                    }
                    // level up mold
                    if let handler = touchHandler {
                        currType = node.name!
                        handler("level_mold")
                    }
                }
            }
        }
    }
    
    //helper clean up method
    func wormKill() {
            for worm in wormLayer.children {
                wormLayer.removeChildren(in: [worm])
                //animate dead worm
                let finalFrame = deadFrames[0]
                let deadPic = SKSpriteNode(texture:finalFrame)
                deadPic.position = worm.position
                deadLayer.addChild(deadPic)
                playSound(select: "dead")
                deadPic.run(SKAction.sequence([SKAction.animate(with: deadFrames,
                                                                timePerFrame: 0.1,
                                                                resize: false,
                                                                restore: true), SKAction.removeFromParent()]))
            }
    }

    func endRepelTimer() {
        wormRepel = false
    }
    
    func playSound(select: String) {
        if mute == false {
            switch select {
            case "levelup":
                run(levelUpSound)
                break
            case "card flip":
                run(cardFlipSound)
                break
            case "laser":
                run(laserSound)
                break
            case "dead":
                run(deadSound)
                break
            case "kiss":
                run(kissSound)
                break
            case "fight":
                run(fightSound)
                break
            case "ding":
                run(dingSound)
                break
            case "bad card":
                run(badCardSound)
                break
            case "gem collect":
                run(gemCollectSound)
                break
            case "crunch":
                run(crunchSound)
                break
            case "gem case":
                run(gemCaseSound)
                break
            case "chest":
                run(chestSound)
                break
            case "worm appear":
                run(wormAppearSound)
                break
            case "select":
                run(selectSound)
            case "camera":
                run(cameraSound)
            case "exit":
                run(exitSound)
            case "powerdown":
                run(powerDownSound)
            case "fairy":
                run(fairySound)
            case "plinking":
                //run(plinkingSound)
                print("no")
            case "reinvest":
                run(reinvest)
            case "black hole hi":
                run(blackHoleAppear)
            case "black hole bye":
                run(blackHoleBye)
            case "mold succ":
                run(moldSucc)
            default:
                run(levelUpSound)
            }
        }
    }
    
    func sleep() {
        wormHP = []
        wormLayer.removeAllChildren()
        for timer in wormChompTimers {
            timer.invalidate()
        }
        wormChompTimers = []
        if eventTimer != nil {
            eventTimer.invalidate()
        }
        
        var texture = SKTexture(image: UIImage(named: "grey out")!)
        let greyOut = SKSpriteNode(texture:texture)
        greyOut.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        sleepLayer.addChild(greyOut)
        
        texture = SKTexture(image: UIImage(named: "sleep mode message")!)
        let sleepMessage = SKSpriteNode(texture:texture)
        sleepMessage.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        sleepLayer.addChild(sleepMessage)
        
        texture = SKTexture(image: UIImage(named: "sleep mode button")!)
        sleepButton = SKSpriteNode(texture:texture)
        sleepButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        sleepLayer.addChild(sleepButton)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            sleepMessage.setScale(0.6)
            sleepButton.setScale(0.6)
            break
        case .iPhone5:
            //iPhone 5
            sleepMessage.setScale(0.8)
            sleepButton.setScale(0.8)
            break
        
        default:
            break
        }

    }
    
    func doDiamondShop() {
        //turn of score animation
        diamondShop = true
        //present shop
        diamondShelves = SKSpriteNode(imageNamed: "diamond_shelves")
        diamondShelves.size = background.size
        diamondLayer.addChild(diamondShelves)
        
        // EXIT MENU
        var Texture = SKTexture(image: UIImage(named: "exit")!)
        exitDiamond = SKSpriteNode(texture:Texture)
        // Place in scene
        exitDiamond.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+285);
        diamondLayer.addChild(exitDiamond)
        
        Texture = SKTexture(image: UIImage(named: "tiny diamonds")!)
        diamondTiny = SKSpriteNode(texture:Texture)
        let diamondTinyProduct = products.first(where: { $0.productIdentifier.contains("_99_") })
        guard let diamondTinyPrice = IAPManager.shared.getPriceFormatted(for: diamondTinyProduct ?? SKProduct()) else { return }
        // Place in scene
        diamondTiny.position = CGPoint(x: -90, y: 190)
        diamondLayer.addChild(diamondTiny)
        let diamondLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel.fontSize = 20
        diamondLabel.text = diamondTinyProduct?.localizedDescription
        diamondLabel.position = CGPoint(x: 30, y: 190)
        diamondLabel.color = UIColor.black
        diamondLayer.addChild(diamondLabel)
        let priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        priceLabel.text = diamondTinyPrice
        priceLabel.position = CGPoint(x: 30, y: 170)
        diamondLayer.addChild(priceLabel)
        priceLabel.fontColor = UIColor.black
        diamondLabel.fontColor = UIColor.black
        //tiny diamond button
        tinyButton = SKSpriteNode(texture:SKTexture(image: UIImage(named: "diamond_button_invisible")!))
        tinyButton.position = CGPoint(x: 0, y: 200)
        //tinyButton.fillColor = SKColor.white
        diamondLayer.addChild(tinyButton)
        
        Texture = SKTexture(image: UIImage(named: "small diamonds")!)
        diamondSmall = SKSpriteNode(texture:Texture)
        let diamondSmallProduct = products.first(where: { $0.productIdentifier.contains("_299_") })
        guard let diamondSmallPrice = IAPManager.shared.getPriceFormatted(for: diamondSmallProduct ?? SKProduct()) else { return }
        // Place in scene
        diamondSmall.position = CGPoint(x: -90, y: 45)
        diamondLayer.addChild(diamondSmall)
        let diamondLabel2 = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel2.fontSize = 20
        diamondLabel2.text = diamondSmallProduct?.localizedDescription
        diamondLabel2.position = CGPoint(x: 30, y: 50)
        diamondLabel2.color = UIColor.black
        diamondLayer.addChild(diamondLabel2)
        let priceLabel2 = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel2.fontSize = 20
        priceLabel2.text = diamondSmallPrice
        priceLabel2.position = CGPoint(x: 30, y: 25)
        diamondLayer.addChild(priceLabel2)
        priceLabel2.fontColor = UIColor.black
        diamondLabel2.fontColor = UIColor.black
        //small diamond button
        smallButton = SKSpriteNode(texture:SKTexture(image: UIImage(named: "diamond_button_invisible")!))
        smallButton.position = CGPoint(x: 0, y: 55)
        //smallButton.fillColor = SKColor.white
        diamondLayer.addChild(smallButton)
        
        Texture = SKTexture(image: UIImage(named: "medium diamonds")!)
        diamondMedium = SKSpriteNode(texture:Texture)
        let diamondMediumProduct = products.first(where: { $0.productIdentifier.contains("_999_") })
        guard let diamondMediumPrice = IAPManager.shared.getPriceFormatted(for: diamondMediumProduct ?? SKProduct()) else { return }
        // Place in scene
        diamondMedium.position = CGPoint(x: -90, y: -95)
        diamondLayer.addChild(diamondMedium)
        let diamondLabel3 = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel3.fontSize = 20
        diamondLabel3.text = diamondMediumProduct?.localizedDescription
        diamondLabel3.position = CGPoint(x: 30, y: -90)
        diamondLabel3.color = UIColor.black
        diamondLayer.addChild(diamondLabel3)
        let priceLabel3 = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel3.fontSize = 20
        priceLabel3.text = diamondMediumPrice
        priceLabel3.position = CGPoint(x: 30, y: -115)
        diamondLayer.addChild(priceLabel3)
        priceLabel3.fontColor = UIColor.black
        diamondLabel3.fontColor = UIColor.black
        //medium diamond button
        mediumButton = SKSpriteNode(texture:SKTexture(image: UIImage(named: "diamond_button_invisible")!))
        mediumButton.position = CGPoint(x: 0, y: -80)
        //mediumButton.fillColor = SKColor.white
        diamondLayer.addChild(mediumButton)
        
        Texture = SKTexture(image: UIImage(named: "big diamonds")!)
        diamondLarge = SKSpriteNode(texture:Texture)
        let diamondLargeProduct = products.first(where: { $0.productIdentifier.contains("_4999_") })
        guard let diamondLargePrice = IAPManager.shared.getPriceFormatted(for: diamondLargeProduct ?? SKProduct()) else { return }
        // Place in scene
        diamondLarge.position = CGPoint(x: -90, y: -240)
        diamondLayer.addChild(diamondLarge)
        let diamondLabel4 = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel4.fontSize = 16
        diamondLabel4.text = diamondLargeProduct?.localizedDescription
        diamondLabel4.position = CGPoint(x: 30, y: -235)
        diamondLabel4.color = UIColor.black
        diamondLayer.addChild(diamondLabel4)
        let priceLabel4 = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel4.fontSize = 16
        priceLabel4.text = diamondLargePrice
        priceLabel4.position = CGPoint(x: 30, y: -260)
        diamondLayer.addChild(priceLabel4)
        priceLabel4.fontColor = UIColor.black
        diamondLabel4.fontColor = UIColor.black
        //large diamond button
        largeButton = SKSpriteNode(texture:SKTexture(image: UIImage(named: "diamond_button_invisible")!))
        largeButton.position = CGPoint(x: 0, y: -225)
        //largeButton.fillColor = SKColor.white
        diamondLayer.addChild(largeButton)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            for child in diamondLayer.children {
                child.setScale(0.7)
            }
            diamondShelves.size = background.size
            exitDiamond.position = CGPoint(x:self.frame.midX+120, y:self.frame.midY+200)
            
            diamondTiny.position = CGPoint(x: -75, y: 130)
            diamondLabel.position = CGPoint(x: 30, y: 135)
            priceLabel.position = CGPoint(x: 30, y: 120)
            tinyButton.position = CGPoint(x: 0, y: 140)
            
            diamondSmall.position = CGPoint(x: -75, y: 35)
            diamondLabel2.position = CGPoint(x: 30, y: 40)
            priceLabel2.position = CGPoint(x: 30, y: 25)
            smallButton.position = CGPoint(x: 0, y: 45)
            
            diamondMedium.position = CGPoint(x: -75, y: -60)
            diamondLabel3.position = CGPoint(x: 30, y: -55)
            priceLabel3.position = CGPoint(x: 30, y: -70)
            mediumButton.position = CGPoint(x: 0, y: -50)
            
            diamondLarge.position = CGPoint(x: -75, y: -155)
            diamondLabel4.position = CGPoint(x: 30, y: -150)
            priceLabel4.position = CGPoint(x: 30, y: -165)
            largeButton.position = CGPoint(x: 0, y: -145)
            break
        case .iPhone5:
            //iPhone 5
            for child in diamondLayer.children {
                child.setScale(0.9)
            }
            diamondShelves.size = background.size
            exitDiamond.position = CGPoint(x:self.frame.midX+120, y:self.frame.midY+200)
            
            diamondTiny.position = CGPoint(x: -75, y: 130)
            diamondLabel.position = CGPoint(x: 30, y: 135)
            priceLabel.position = CGPoint(x: 30, y: 120)
            tinyButton.position = CGPoint(x: 0, y: 140)
            
            diamondSmall.position = CGPoint(x: -75, y: 35)
            diamondLabel2.position = CGPoint(x: 30, y: 40)
            priceLabel2.position = CGPoint(x: 30, y: 25)
            smallButton.position = CGPoint(x: 0, y: 45)
            
            diamondMedium.position = CGPoint(x: -75, y: -60)
            diamondLabel3.position = CGPoint(x: 30, y: -55)
            priceLabel3.position = CGPoint(x: 30, y: -70)
            mediumButton.position = CGPoint(x: 0, y: -50)
            
            diamondLarge.position = CGPoint(x: -75, y: -155)
            diamondLabel4.position = CGPoint(x: 30, y: -150)
            priceLabel4.position = CGPoint(x: 30, y: -165)
            largeButton.position = CGPoint(x: 0, y: -145)
            break
        case .iPhone8:
            for child in diamondLayer.children {
                child.setScale(0.9)
            }
            diamondTiny.position.y -= 15
            diamondLabel.position.y -= 15
            priceLabel.position.y -= 15
            diamondLarge.position.y += 20
            diamondLabel4.position.y += 20
            priceLabel4.position.y += 20
            break
        case .iPhone8Plus:
            // Code for iPhone 6 Plus & iPhone 7 Plus
            for child in diamondLayer.children {
                child.setScale(0.9)
            }
            diamondTiny.position.y -= 15
            diamondLabel.position.y -= 15
            priceLabel.position.y -= 15
            diamondMedium.position.y += 10
            diamondLabel3.position.y += 10
            priceLabel3.position.y += 10
            diamondLarge.position.y += 20
            diamondLabel4.position.y += 20
            priceLabel4.position.y += 20
            break
        case .iPhoneX:
            // Code for iPhone X and 11
            diamondShelves.size = background.size
            diamondTiny.position.x -= 10
            diamondSmall.position.y += 0
            diamondSmall.position.x -= 10
            diamondLabel2.position.y += 0
            priceLabel2.position.y += 0
            diamondMedium.position.y -= 10
            diamondMedium.position.x -= 10
            diamondLabel3.position.y -= 10
            priceLabel3.position.y -= 0
            diamondLarge.position.y -= 10
            diamondLarge.position.x -= 10
            diamondLabel4.position.y -= 10
            priceLabel4.position.y -= 10
            break
        default:
            break
        }
    }
    
    func updateMolds() {
        if molds.count != moldLayer.children.count {
            moldLayer.removeAllChildren()
            for newMold in molds {
                addMold(moldData: newMold)
            }
        }
    }
    
    func addMold(moldData: Mold) {
        let ranX = randomInRange(lo: -125, hi: 125)
        let ranY = randomInRange(lo: -200, hi: 175)
        //molds w/ no animation
        if (moldData.moldType == MoldType.invisible || moldData.moldType == MoldType.disaffected || moldData.moldType == MoldType.dead) {
            let imName = String(moldData.name)
            let Image = UIImage(named: imName)
            let Texture = SKTexture(image: Image!)
            
            let moldPic = SKSpriteNode(texture:Texture)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
        }
            //MOLDS WITH CUSTOM ANIMATION INSTRUCTIONS
        else if (moldData.moldType == MoldType.circuit || moldData.moldType == MoldType.nuclear) {
            let textureOn = SKTexture(image: UIImage(named: moldData.name)!)
            let textureOff = SKTexture(image: UIImage(named: moldData.name + " Off")!)
            let textureTwo = SKTexture(image: UIImage(named: moldData.name + " T Blink")!)
            let textureThree = SKTexture(image: UIImage(named: moldData.name + " B Blink")!)
            let textureFour = SKTexture(image: UIImage(named: moldData.name + " F Blink")!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 2)*10
            while(i<numFrames) {
                frames.append(textureOn)
                frames.append(textureOff)
                i += 2
            }
            
            frames.append(textureTwo)
            frames.append(textureThree)
            frames.append(textureFour)
            frames.append(textureThree)
            frames.append(textureTwo)
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldCircuit")
        }
        else if (moldData.moldType == MoldType.samurai) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(3)) + 8)*10
            while(i<numFrames) {
                frames.append(textureOne)
                i += 1
            }
            
            frames.append(SKTexture(image: UIImage(named: "Samurai Mold F1")!))
            frames.append(SKTexture(image: UIImage(named: "Samurai Mold F1")!))
            frames.append(SKTexture(image: UIImage(named: "Samurai Mold F1")!))
            frames.append(SKTexture(image: UIImage(named: "Samurai Mold F2")!))
            frames.append(SKTexture(image: UIImage(named: "Samurai Mold F2")!))
            frames.append(SKTexture(image: UIImage(named: "Samurai Mold F2")!))
            frames.append(SKTexture(image: UIImage(named: "Samurai Mold F2")!))
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldSamurai")
            
        }
        else if (moldData.moldType == MoldType.magma) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(3)) + 8)*10
            while(i<numFrames) {
                frames.append(textureOne)
                i += 1
            }
            
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F2")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F4")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F5")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F6")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F5")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F6")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F5")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F6")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F4")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Magma Mold F2")!))
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldMagma")
            
        }
        else if (moldData.moldType == MoldType.cryptid) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(3)) + 8)*10
            while(i<numFrames) {
                frames.append(textureOne)
                i += 1
            }
            
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F2")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F2")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F3")!))
            frames.append(SKTexture(image: UIImage(named: "Cryptid Mold F2")!))
            
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldCryptid")
            
        }
        else if (moldData.moldType == MoldType.cloud) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            let textureTwo = SKTexture(image: UIImage(named: moldData.name + " T Blink")!)
            let textureThree = SKTexture(image: UIImage(named: moldData.name + " B Blink")!)
            let textureFour = SKTexture(image: UIImage(named: moldData.name + " F Blink")!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 2)*4
            while(i<numFrames) {
                frames.append(textureOne)
                var j = 1
                while(j <= 5) {
                    frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(j)"))!))
                    j += 1
                }
                i += 1
            }
            
            frames.append(textureTwo)
            frames.append(textureThree)
            frames.append(textureFour)
            frames.append(textureThree)
            frames.append(textureTwo)
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldCloud")
        }
        else if (moldData.moldType == MoldType.hologram) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 2)*4
            while(i<numFrames) {
                frames.append(textureOne)
                var j = 2
                while(j < 8) {
                    frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(j)"))!))
                    j += 1
                }
                i += 1
            }
            
            frames.append(SKTexture(image: UIImage(named: "Hologram Mold F8")!))
            frames.append(SKTexture(image: UIImage(named: "Hologram Mold F9")!))
            frames.append(SKTexture(image: UIImage(named: "Hologram Mold F10")!))
            frames.append(SKTexture(image: UIImage(named: "Hologram Mold F11")!))
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldHologram")
        }
        else if (moldData.moldType == MoldType.storm) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 2)*4
            while(i<numFrames) {
                frames.append(textureOne)
                var j = 1
                while(j < 6) {
                    frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(j)"))!))
                    j += 1
                }
                i += 1
            }
            
            frames.append(SKTexture(image: UIImage(named: "Storm Mold L1")!))
            frames.append(SKTexture(image: UIImage(named: "Storm Mold L2")!))
            frames.append(SKTexture(image: UIImage(named: "Storm Mold L3")!))
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldStorm")
        }
        else if (moldData.moldType == MoldType.coconut) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 2)*4
            while(i<numFrames) {
                frames.append(textureOne)
                var j = 1
                while(j < 4) {
                    frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(j)"))!))
                    j += 1
                }
                i += 1
            }
            
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C1")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C2")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C3")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C4")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C5")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C5")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C5")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C4")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C3")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C2")!))
            frames.append(SKTexture(image: UIImage(named: "Coconut Mold C1")!))
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldCoconut")
        }
        else if (moldData.moldType == MoldType.angry) {
            var frames = [SKTexture]()
            
            var i = 1
            let numFrames = 5
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldAngry")
        }
        else if (moldData.moldType == MoldType.bacteria || moldData.moldType == MoldType.bee) {
            var frames = [SKTexture]()
            
            var i = 1
            let numFrames = 6
            while(i <= numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            i -= 1
            while(i > 0) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i -= 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldBacteria")
        }
        else if (moldData.moldType == MoldType.astronaut) {
            var frames = [SKTexture]()
            
            var i = 1
            let numFrames = (Int(arc4random_uniform(5)) + 6)*10
            while(i <= numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name))!))
                i += 1
            }
            i = 1
            while(i < 22) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F2"))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldAstronaut")
        }
        else if (moldData.moldType == MoldType.zombie) {
            var frames = [SKTexture]()
            
            var i = 0
            var numFrames = (Int(arc4random_uniform(3)) + 1)*10
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name))!))
                i += 1
            }
            
            i = 1
            numFrames = 8
            while(i <= numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            i -= 1
            while(i > 0) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i -= 1
            }
            
            i = 0
            numFrames = (Int(arc4random_uniform(3)) + 1)*10
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldZombie")
        }
        else if (moldData.moldType == MoldType.virus) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            var frames = [SKTexture]()
            
            frames.append(SKTexture(image: UIImage(named: "Virus Mold T Blink")!))
            frames.append(SKTexture(image: UIImage(named: "Virus Mold B Blink")!))
            frames.append(SKTexture(image: UIImage(named: "Virus Mold F Blink")!))
            frames.append(SKTexture(image: UIImage(named: "Virus Mold B Blink")!))
            frames.append(SKTexture(image: UIImage(named: "Virus Mold T Blink")!))
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 2)*4
            while(i<numFrames) {
                frames.append(textureOne)
                var j = 1
                while(j < 8) {
                    frames.append(SKTexture(image: UIImage(named: "Virus Mold F\(j)")!))
                    j += 1
                }
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldVirus")
        }
        else if (moldData.moldType == MoldType.x) {
            var frames = [SKTexture]()
            
            var i = 0
            var arr = Array(2...10)
            arr.shuffle()
            while(i<arr.count) {
                var j = 1
                let numFrames = (Int(arc4random_uniform(6)) + 2)*2
                while(j < numFrames) {
                    frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(arr[i])"))!))
                    j += 1
                }
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldX")
        }
        else if (moldData.moldType == MoldType.hypno || moldData.moldType == MoldType.flower || moldData.moldType == MoldType.water) {
            var frames = [SKTexture]()
            
            var i = 2
            let numFrames = 21
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldHypno")
        }
        else if (moldData.moldType == MoldType.pimply) {
            var frames = [SKTexture]()
            
            var i = 1
            let numFrames = 16
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            var j = 1
            let numFrames2 = (Int(arc4random_uniform(2)) + 3)*10
            while(j<numFrames2) {
                frames.append(SKTexture(image: UIImage(named: "Slime Mold")!))
                j += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldPimply")
        }
        else if (moldData.moldType == MoldType.crystal) {
            var frames = [SKTexture]()
            
            var i = 2
            let numFrames = 8
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            var j = 1
            let numFrames2 = (Int(arc4random_uniform(2)) + 3)*10
            while(j<numFrames2) {
                frames.append(SKTexture(image: UIImage(named: "Crystal Mold")!))
                j += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldCrystal")
        }
        else if (moldData.moldType == MoldType.alien) {
            
            let textureOne = SKTexture(image: UIImage(named: "Alien Mold")!)
            let textureTwo = SKTexture(image: UIImage(named: "Alien Mold F2")!)
            let textureThree = SKTexture(image: UIImage(named: "Alien Mold F3")!)
            let textureFour = SKTexture(image: UIImage(named: "Alien Mold F4")!)
            var frames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 8)*10
            while(i<numFrames) {
                frames.append(textureOne)
                frames.append(textureTwo)
                frames.append(textureFour)
                i += 3
            }
            
            frames.append(textureThree)
            frames.append(textureFour)
            frames.append(textureThree)
            frames.append(textureFour)
            frames.append(textureThree)
            frames.append(textureFour)
            frames.append(textureTwo)
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldAlien")
            
        }
        else if (moldData.moldType == MoldType.rainbow) {
            var frames = [SKTexture]()
            
            var i = 1
            let numFrames = 11
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: "Rainbow Mold F\(i)")!))
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldRainbow")
            
        }
        else if (moldData.moldType == MoldType.slinky) {
            var frames = [SKTexture]()
            
            var i = 1
            var numFrames = 11
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: "Slinky Mold F\(i)")!))
                i += 1
            }
            
            i = 0
            numFrames = (Int(arc4random_uniform(6)) + 8)*10
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: "Slinky Mold")!))
                i += 3
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldSlinky")
            
        }
        else if (moldData.moldType == MoldType.coffee) {
            var frames = [SKTexture]()
            
            frames.append(SKTexture(image: UIImage(named: "Coffee Mold F1")!))
            frames.append(SKTexture(image: UIImage(named: "Coffee Mold F2")!))
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldCoffee")
            
        }
        else if (moldData.moldType == MoldType.angel) {
            var frames = [SKTexture]()
            
            frames.append(SKTexture(image: UIImage(named: "Angel Mold")!))
            frames.append(SKTexture(image: UIImage(named: "Angel Mold")!))
            frames.append(SKTexture(image: UIImage(named: "Angel Mold")!))
            var i = 2
            while(i<7) {
                var j = 1
                while(j < 4) {
                    frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                    j += 1
                }
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldAngel")
            
        }
        else if (moldData.moldType == MoldType.star) {
            var frames = [SKTexture]()
            
            frames.append(SKTexture(image: UIImage(named: "Star Mold")!))
            var i = 1
            while(i<8) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.15,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldStar")
            
        }
            //THIS IS FOR MOLDS THAT JUST BLINK
        else {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            let textureTwo = SKTexture(image: UIImage(named: moldData.name + " T Blink")!)
            let textureThree = SKTexture(image: UIImage(named: moldData.name + " B Blink")!)
            let textureFour = SKTexture(image: UIImage(named: moldData.name + " F Blink")!)
            var blinkFrames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 8)*10
            while(i<numFrames) {
                blinkFrames.append(textureOne)
                i += 1
            }
            blinkFrames.append(textureTwo)
            blinkFrames.append(textureThree)
            blinkFrames.append(textureFour)
            blinkFrames.append(textureThree)
            blinkFrames.append(textureTwo)
            
            let firstFrame = blinkFrames[0]
            let moldPic = SKSpriteNode(texture:firstFrame)
            moldPic.name = moldData.name
            moldPic.position = CGPoint(x:self.frame.midX+CGFloat(ranX), y:self.frame.midY+CGFloat(ranY))
            moldLayer.addChild(moldPic)
            moldPic.run(SKAction.repeatForever(
                SKAction.animate(with: blinkFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                        withKey:"moldBlinking")
            
        }
    }
    
    
    // MARK: - TUTORIAL
    func beginTut() {
        
        //eventTimer.invalidate()
        tutorial = 1
        self.addChild(tutorialLayer)
        let appear = SKAction.scale(to: 1.15, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "intro box")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addTitle1()
        }
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            introNode.setScale(0.7)
        case .iPhone5:
            //iPhone 5
            introNode.setScale(0.9)
            break
        default:
            break
        }

    }
    
    func addTitle1() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 15
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Welcome to"
        welcomeTitle.position = CGPoint(x:self.frame.midX, y:self.frame.midY+115);
        tutorialLayer.addChild(welcomeTitle)
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 28
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "Mold Marauder"
        welcomeTitle2.position = CGPoint(x:self.frame.midX, y:self.frame.midY+80);
        tutorialLayer.addChild(welcomeTitle2)
        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 15
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "Your goal is to become the"
        welcomeTitle3.position = CGPoint(x:self.frame.midX, y:self.frame.midY+45);
        tutorialLayer.addChild(welcomeTitle3)
        let welcomeTitle4 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle4.fontSize = 15
        welcomeTitle4.fontColor = UIColor.black
        welcomeTitle4.text = "richest mold breeder in the "
        welcomeTitle4.position = CGPoint(x:self.frame.midX, y:self.frame.midY+25);
        tutorialLayer.addChild(welcomeTitle4)
        let welcomeTitle5 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle5.fontSize = 15
        welcomeTitle5.fontColor = UIColor.black
        welcomeTitle5.text = "world."
        welcomeTitle5.position = CGPoint(x:self.frame.midX, y:self.frame.midY+5);
        tutorialLayer.addChild(welcomeTitle5)
        let welcomeTitle6 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle6.fontSize = 15
        welcomeTitle6.fontColor = UIColor.black
        welcomeTitle6.text = "Tap to Continue"
        welcomeTitle6.position = CGPoint(x:self.frame.midX, y:self.frame.midY-40);
        tutorialLayer.addChild(welcomeTitle6)
        
        let Texture = SKTexture(image: UIImage(named: "Hypno Mold")!)
        let moldNode = SKSpriteNode(texture:Texture)
        // Place in scene
        moldNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY-95);
        tutorialLayer.addChild(moldNode)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle.setScale(0.7)
            welcomeTitle2.setScale(0.7)
            welcomeTitle3.setScale(0.7)
            welcomeTitle4.setScale(0.7)
            welcomeTitle5.setScale(0.7)
            welcomeTitle6.setScale(0.7)
            moldNode.setScale(0.7)
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            welcomeTitle4.setScale(0.9)
            welcomeTitle5.setScale(0.9)
            welcomeTitle6.setScale(0.9)
            moldNode.setScale(0.9)
            break
        default:
            break
        }
    }
    
    func tapTut() {
        tutorial += 1
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:diamondIcon.position.x+75, y:diamondIcon.position.y - 100)
        tutorialLayer.addChild(introNode)
        
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 13
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Tap the screen to earn points:"
        welcomeTitle.position = CGPoint(x:introNode.position.x, y:introNode.position.y);
        tutorialLayer.addChild(welcomeTitle)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle.setScale(0.7)
            introNode.setScale(0.7)
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            introNode.setScale(0.9)
            break
        case .iPhoneX:
            //iPhone 5
            welcomeTitle.setScale(0.75)
            introNode.setScale(0.75)
            break
        default:
            break
        }
    }
    
    func buyMoldTutorial() {
        print("derp")
        tutorial = 11
        
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        introNode.setScale(1.15)
        // Place in scene
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            introNode.setScale(1)
            break
        default:
            break
        }
        
        introNode.position = CGPoint(x:frame.midX, y:frame.midY);
        tutorialLayer.addChild(introNode)
        
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 13
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Good! Now lets buy your first mold"
        welcomeTitle.position = CGPoint(x:introNode.position.x, y:introNode.position.y+12);
        tutorialLayer.addChild(welcomeTitle)
        
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 13
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "Tap the \"Buy\" Button in the top right"
        welcomeTitle2.position = CGPoint(x:introNode.position.x, y:introNode.position.y-12);
        tutorialLayer.addChild(welcomeTitle2)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle.setScale(0.7)
            welcomeTitle2.setScale(0.7)
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            break
        default:
            break
        }
    }
    
    func wormTutorial() {
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:diamondIcon.position.x+75, y:diamondIcon.position.y - 100);
        tutorialLayer.addChild(introNode)
        
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 13
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Congrats you have a Mold!"
        welcomeTitle.position = CGPoint(x:introNode.position.x, y:introNode.position.y+25);
        tutorialLayer.addChild(welcomeTitle)
        
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 18
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "But BE CAREFUL!"
        welcomeTitle2.position = CGPoint(x:introNode.position.x, y:introNode.position.y);
        tutorialLayer.addChild(welcomeTitle2)
        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 14
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "Evil worms want to eat it!"
        welcomeTitle3.position = CGPoint(x:introNode.position.x, y:introNode.position.y-25);
        tutorialLayer.addChild(welcomeTitle3)
        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.killWormTutorial()
        }
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle.setScale(0.7)
            welcomeTitle2.setScale(0.7)
            welcomeTitle3.setScale(0.7)
            introNode.setScale(0.8)
            
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            introNode.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func killWormTutorial() {
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:diamondIcon.position.x+75, y:diamondIcon.position.y - 200);
        tutorialLayer.addChild(introNode)
        
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 14
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Tap the worm to fire"
        welcomeTitle.position = CGPoint(x:introNode.position.x, y:introNode.position.y+18);
        tutorialLayer.addChild(welcomeTitle)
        
        let welcomeTitle25 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle25.fontSize = 14
        welcomeTitle25.fontColor = UIColor.black
        welcomeTitle25.text = "your laser"
        welcomeTitle25.position = CGPoint(x:introNode.position.x, y:introNode.position.y);
        tutorialLayer.addChild(welcomeTitle25)
        
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 14
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "A couple shots should do it"
        welcomeTitle2.position = CGPoint(x:introNode.position.x, y:introNode.position.y-18);
        tutorialLayer.addChild(welcomeTitle2)
        wormAttack(tutorial: true)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle.setScale(0.7)
            welcomeTitle2.setScale(0.7)
            welcomeTitle25.setScale(0.7)
            introNode.setScale(0.7)
            
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle25.setScale(0.9)
            introNode.setScale(0.9)
            
            break
        default:
            break
        }
    }

    func killWormCongrats() {
        let appear = SKAction.scale(to: 1.1, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "intro box")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addWormDeadCongrats()
        }
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            introNode.setScale(0.7)
            
            break
        case .iPhone5:
            //iPhone 5
            introNode.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func addWormDeadCongrats() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 16
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Nice! You got it!"
        welcomeTitle.position = CGPoint(x:frame.midX, y:frame.midY+115);
        tutorialLayer.addChild(welcomeTitle)
        
        let welcomeTitle25 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle25.fontSize = 14
        welcomeTitle25.fontColor = UIColor.black
        welcomeTitle25.text = "Watch out, worms will get"
        welcomeTitle25.position = CGPoint(x:frame.midX, y:frame.midY+95);
        tutorialLayer.addChild(welcomeTitle25)
        
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 14
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "harder to kill"
        welcomeTitle2.position = CGPoint(x:frame.midX, y:frame.midY+80);
        tutorialLayer.addChild(welcomeTitle2)
        
        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 14
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "but you can upgrade"
        welcomeTitle3.position = CGPoint(x:frame.midX, y:frame.midY+65)
        tutorialLayer.addChild(welcomeTitle3)
        
        let welcomeTitle4 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle4.fontSize = 14
        welcomeTitle4.fontColor = UIColor.black
        welcomeTitle4.text = "your weapons."
        welcomeTitle4.position = CGPoint(x:frame.midX, y:frame.midY+45);
        tutorialLayer.addChild(welcomeTitle4)
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addWormDeadCongrats2()
        }
       
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle.setScale(0.7)
            welcomeTitle2.setScale(0.7)
            welcomeTitle3.setScale(0.7)
            welcomeTitle4.setScale(0.7)
            welcomeTitle25.setScale(0.7)
            
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            welcomeTitle4.setScale(0.9)
            welcomeTitle25.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func addWormDeadCongrats2() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 16
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Earn some cash and then"
        welcomeTitle.position = CGPoint(x:frame.midX, y:frame.midY+15);
        tutorialLayer.addChild(welcomeTitle)
        
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 14
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "0nce you've got a few molds"
        welcomeTitle2.position = CGPoint(x:frame.midX, y:frame.midY);
        tutorialLayer.addChild(welcomeTitle2)

        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 14
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "head to the breeding chamber"
        welcomeTitle3.position = CGPoint(x:frame.midX, y:frame.midY-15);
        tutorialLayer.addChild(welcomeTitle3)
        
        
        let Texture = SKTexture(image: UIImage(named: "breed")!)
        let moldNode = SKSpriteNode(texture:Texture)
        // Place in scene
        moldNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY-60);
        tutorialLayer.addChild(moldNode)
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addWormDeadCongrats3()
        }
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle.setScale(0.7)
            welcomeTitle2.setScale(0.7)
            welcomeTitle3.setScale(0.7)
            moldNode.setScale(0.7)
            
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            moldNode.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func addWormDeadCongrats3() {
        let welcomeTitle4 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle4.fontSize = 18
        welcomeTitle4.fontColor = UIColor.black
        welcomeTitle4.text = "Tap to Continue"
        welcomeTitle4.position = CGPoint(x:frame.midX, y:frame.midY-135);
        tutorialLayer.addChild(welcomeTitle4)
        if let handler = touchHandler {
            handler("increment tutorial worm congrats")
        }
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            welcomeTitle4.setScale(0.7)
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle4.setScale(0.9)
            break
        default:
            break
        }
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.fairyTut()
        }
    }
    
    func fairyTut() {
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:diamondIcon.position.x+75, y:diamondIcon.position.y - 100)
        tutorialLayer.addChild(introNode)
        
        let welcomeTitle4 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle4.fontSize = 14
        welcomeTitle4.fontColor = UIColor.black
        welcomeTitle4.text = "Draw a circle around"
        welcomeTitle4.position = CGPoint(x:introNode.position.x, y:introNode.position.y + 10);
        tutorialLayer.addChild(welcomeTitle4)
        
        let welcomeTitle5 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle5.fontSize = 14
        welcomeTitle5.fontColor = UIColor.black
        welcomeTitle5.text = "faeries to capture them"
        welcomeTitle5.position = CGPoint(x:introNode.position.x, y:introNode.position.y - 10);
        tutorialLayer.addChild(welcomeTitle5)
        
        let when = DispatchTime.now() + 3.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.removeWormCongrats()
        }
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 4
            welcomeTitle4.setScale(0.7)
            welcomeTitle5.setScale(0.7)
            break
        case .iPhone5:
            //iPhone 5
            welcomeTitle4.setScale(0.9)
             welcomeTitle5.setScale(0.9)
            break
        case .iPhoneX:
            //iPhone 4
            welcomeTitle4.setScale(0.75)
            welcomeTitle5.setScale(0.75)
            break
        default:
            break
        }
    }
    
    func removeWormCongrats() {
        let disappear = SKAction.scale(to: 0.0, duration: 0.3)
        for child in tutorialLayer.children {
            child.run(SKAction.sequence([disappear, SKAction.removeFromParent()]))
        }
        
    }

    //MARK: - EVENT
    
    //every 8 seconds trigger event
    /*
     EVENTS:
     some chance of each:
        - WORM ATTACK: USE THE LASRS TO DEFEAT THE DEATH WORMS BEFORE THEY DEVOUR YOU!
        - three cards appear, pick one for buff or debuff. pay diamonds to see all cards
        - idk tbh
     */
    @objc func triggerEvent() {
        print("event triggered")
        let ran = Int(arc4random_uniform(100))
        //make sure user isn't buying diamonds
        if diamondShop == false {
            //worm attak
            print(ran)
            if ran <= 40 {
                if wormRepel == false && wormHP.count < 6 {
                    wormAttack(tutorial: false)
                    //vibrateWithHaptic()
                    if reinvestCount >= 1 {
                        wormAttack(tutorial: false)
                    }
                }
            }
            //add faerie
            if ran > 35 && ran < 85 {
                addFaerie()
            }
            //add lots of faeries
            if ran == 85 {
                let amount = randomInRange(lo: 4, hi: 14)
                var counter = 0
                while(counter < amount) {
                    addFaerie()
                    counter += 1
                }
            }
            // blak hole
            if ran > 85 && ran <= 95 {
                if isPaused == false {
                    print("ad black hole")
                    addBlackHole()
                }
            }
            //card pick
            if ran >  95 {
                if let handler = touchHandler {
                    handler("touchOFF")
                    handler("tap ended")
                }
                //create event cards
                cardsActive = true
                cardSelected = false
                var texture = SKTexture(image: UIImage(named: "card")!)
                card1 = SKSpriteNode(texture:texture)
                card1.position = CGPoint(x:self.frame.midX-122, y:self.frame.midY)
                cardLayer.addChild(card1)
                card2 = SKSpriteNode(texture:texture)
                card2.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
                cardLayer.addChild(card2)
                card3 = SKSpriteNode(texture:texture)
                card3.position = CGPoint(x:self.frame.midX+122, y:self.frame.midY)
                cardLayer.addChild(card3)
                texture = SKTexture(image: UIImage(named: "reveal cards button")!)
                revealCards = SKSpriteNode(texture:texture)
                revealCards.position = CGPoint(x:self.frame.midX, y:self.frame.midY-170)
                cardLayer.addChild(revealCards)
                if eventTimer != nil {
                    eventTimer.invalidate()
                }
                playSound(select: "card flip")
            }
        }
    }
    
    //add faerie
    func addFaerie() {
        var fairyFrames = [SKTexture]()
        
        fairyFrames.append(SKTexture(image: UIImage(named: "fairy")!))
        fairyFrames.append(SKTexture(image: UIImage(named: "fairy2")!))
        fairyFrames.append(SKTexture(image: UIImage(named: "fairy3")!))
        fairyFrames.append(SKTexture(image: UIImage(named: "fairy2")!))
        
        let firstFrame = fairyFrames[0]
        let fairyNode = SKSpriteNode(texture:firstFrame)
        let y = randomInRange(lo: Int(self.frame.minY) + 60, hi: Int(self.frame.maxY) - 120)
        let x = randomInRange(lo: Int(self.frame.minX) + 60, hi: Int(self.frame.maxX) - 60)
        fairyNode.position = CGPoint(x:x, y:y)
        fairyLayer.addChild(fairyNode)
        fairyNode.run(SKAction.repeatForever(
            SKAction.animate(with: fairyFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                      withKey:"fairyFlap")
        
        let appear = SKAction.scale(to: 1.0, duration: 0.15)
        // Place in scene
        fairyNode.setScale(0.0)
        fairyNode.run(SKAction.sequence([appear]))
        if fairyTimer == nil {
            fairyTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(moveFairy), userInfo: nil, repeats: true)
        }
    }
    
//    add black hole blackhole
    func addBlackHole() {
        let y = randomInRange(lo: Int(self.frame.minY) + 50, hi: Int(self.frame.maxY) - 160)
        let x = randomInRange(lo: Int(self.frame.minX) + 50, hi: Int(self.frame.maxX) - 50)
        let hole = BlackHole(size:CGSize(width:250, height:250))
        hole.position = CGPoint(x: x, y: y)
        
        holeLayer.addChild(hole)
        hole.place()
        playSound(select: "black hole hi")
        let when = DispatchTime.now() + 0.8
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.succMold()
        }
    }
    
    func succMold() {
        if let handler = touchHandler {
            handler("succ_mold")
        }
//    remove black hole
        if randomInRange(lo: 0, hi: 2) == 1 {
            var when = DispatchTime.now() + 1.35
            DispatchQueue.main.asyncAfter(deadline: when) {
                if let hole = self.holeLayer.children[0] as? BlackHole {
                    hole.disappear()
                    self.playSound(select: "black hole bye")
                }
                
                when = DispatchTime.now() + 0.55
                DispatchQueue.main.asyncAfter(deadline: when) {
                    if self.holeLayer.children.count > 0 {
                        if let hole = self.holeLayer.children[0] as? BlackHole {
                            hole.removeFromParent()
                        }
                        else {
                            var index = 0
                            checkHole: while true {
                                if let hole = self.holeLayer.children[index] as? BlackHole {
                                    hole.removeFromParent()
                                    break checkHole
                                }
                                index += 1
                                if index == self.holeLayer.children.count {
                                    break checkHole
                                }
                            }
                        }
                    }
                }
            }
        }
// succ another mold
        else {
            let when = DispatchTime.now() + 1.25
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.succMold()
            }
            if wormRepel == false {
                var worms = randomInRange(lo: 0, hi: 3)
                while worms > 0 {
                    let when = DispatchTime.now() + TimeInterval(Double.random(in: 0.2 ..< 1.4))
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        if self.wormHP.count < 6 {
                            self.wormAttack(tutorial: false)
                        }
                    }
                    worms -= 1
                }
            }
        }
        
    }
    
    //do le wirm atek
    func wormAttack(tutorial: Bool) {
        //pick random location on scren
        let y = randomInRange(lo: Int(self.frame.minY) + 40, hi: Int(self.frame.maxY) - 150)
        let x = randomInRange(lo: Int(self.frame.minX) + 40, hi: Int(self.frame.maxX) - 40)
        //put a worm there
        var wormFrames = [SKTexture]()
        
        var i = 1
        let numFrames = 4
        while(i <= numFrames) {
            wormFrames.append(SKTexture(image: UIImage(named: "hole F\(i)")!))
            i += 1
        }
        if x < Int(self.frame.midX) {
            wormFrames.append(SKTexture(image: UIImage(named: "worm right")!))
        }
        else {
            wormFrames.append(SKTexture(image: UIImage(named: "worm left")!))
        }
        
        let finalFrame = wormFrames[4]
        let wormPic = SKSpriteNode(texture:finalFrame)
        let timterval = Double.random(in: 1.8 ..< 3.6)
        wormChompTimers.append(Timer.scheduledTimer(timeInterval: TimeInterval(timterval), target: self, selector: #selector(GameScene.eatMold), userInfo: nil, repeats: true))
        wormHP.append(wormDifficulty)
        if tutorial {
            wormPic.position = CGPoint(x: self.frame.midX+50, y: self.frame.midY-75)
        }
        else {
            wormPic.position = CGPoint(x: x, y: y)
        }
        
        wormLayer.addChild(wormPic)
        playSound(select: "worm appear")
        wormPic.run(SKAction.animate(with: wormFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true))
    }

    //eat mold
    @objc func eatMold() {
        let index = randomInRange(lo: 0, hi: wormLayer.children.count - 1)
        var left = true
        if wormLayer.children[index].position.x < frame.midX {
            left = false
        }
        var attackFrames = [SKTexture]()
        if left {
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep left")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm strike left")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep left")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm left")!))
        }
        else {
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep right")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm strike right")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep right")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm right")!))
        }
        let finalFrame = attackFrames[2]
        let attackPic = SKSpriteNode(texture:finalFrame)
        attackPic.position = CGPoint(x: wormLayer.children[index].position.x, y: wormLayer.children[index].position.y)//wormLayer.children[index].position
        wormLayer.removeChildren(in: [wormLayer.children[index]])
        wormLayer.addChild(attackPic)
        //playSound(select: "worm appear")
        attackPic.run(SKAction.animate(with: attackFrames,
                                       timePerFrame: 0.1,
                                       resize: false,
                                       restore: true))
        if let handler = touchHandler {
            handler("eat_mold")
        }
    }
    
    @objc func moveFairy() {
        //var counter = 0
        for fairy in fairyLayer.children {
            if fairyCounter == 48 {
                //if counter == 0 {
                    let disappear = SKAction.scale(to: 0.0, duration: 0.3)
                    fairy.run(SKAction.sequence([disappear, SKAction.removeFromParent()]))
                    fairyCounter = 0
                    if fairyLayer.children.count == 1 {
                        fairyTimer.invalidate()
                        fairyTimer = nil
                    }
                    
                    //if theres too many faeries
                    if fairyLayer.children.count > 6 {
                        for fairy in fairyLayer.children {
                            fairy.run(SKAction.sequence([disappear, SKAction.removeFromParent()]))
                        }
                    }
                //}
            }
            let y = CGFloat(randomInRange(lo: -24, hi: 24))
            let x = CGFloat(randomInRange(lo: -24, hi: 24))
            let newPosition = CGPoint(x:fairy.position.x+x, y:fairy.position.y+y)
            let move = SKAction.move(to: newPosition, duration:0.15)
            fairy.run(move)
            //counter += 1
        }
        fairyCounter += 1
    }
    
    //MARK: - ANIMATIONS
    
    func animateSpritz() {
        let particle = SKTexture(image: UIImage(named: "glowing particle")!)
        for mold in moldLayer.children {
            var counter = 0
            while (counter < 15) {
                let partNode = SKSpriteNode(texture: particle)
                let size = Double.random0to1() * 0.8
                partNode.setScale(CGFloat(size))
                let posX = Int(arc4random_uniform(300)) - 150
                let posY = Int(arc4random_uniform(60))
                let ranX = Int(arc4random_uniform(40)) - 20
                let ranY = Int(arc4random_uniform(100) + 1) + 120
                partNode.position = CGPoint(x: mold.position.x + CGFloat(posX), y: mold.position.y + CGFloat(posY))
                diamondLayer.addChild(partNode)
                let moveAction = SKAction.move(by: CGVector(dx: ranX, dy: ranY), duration: 2.0)
                // moveAction.timingMode = .easeOut
                
                partNode.run(SKAction.sequence([moveAction, SKAction.fadeOut(withDuration: (1.0-size)), SKAction.removeFromParent()]))
                counter += 1
            }
        }
    }
    
    //animate the little numbers wiggling up
    func animateScore(point: CGPoint, amount: BInt, tap: Bool, fairy: Bool, offline: Bool) {
        // Figure out what the midpoint of the chain is.
        let centerPosition = CGPoint(
            x: (point.x),
            y: (point.y + 25))
        
        // Add a label for the score that slowly floats up.
        let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
        scoreLabel.fontSize = 16
        scoreLabel.text = formatNumber(points: amount)
        scoreLabel.position = centerPosition
        scoreLabel.zPosition = 300
        if tap == false {
            scoreLabel.fontColor = UIColor(red: 1, green: 213/255, blue: 0, alpha: 1)
            scoreLabel.fontSize = 20
        }
        else if xTap {
            scoreLabel.fontColor = UIColor.green
            scoreLabel.fontSize = 20
        }
        if fairy {
            scoreLabel.fontColor = UIColor.yellow
            scoreLabel.fontSize = 18
        }
        if offline == true {
            let extraLabel = SKLabelNode(fontNamed: "Lemondrop")
            extraLabel.fontColor = UIColor.green
            scoreLabel.fontColor = UIColor.green
            extraLabel.fontSize = 28
            scoreLabel.fontSize = 28
            extraLabel.zPosition = 300
            extraLabel.position = CGPoint(x: (point.x), y: (point.y + 50))
            extraLabel.text = "Offline Earnings"
            gameLayer.addChild(extraLabel)
            gameLayer.addChild(scoreLabel)
            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 35), duration: 2.5)
            scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
            extraLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
        if offline == false {
            gameLayer.addChild(scoreLabel)
            
            let ranX = Int(arc4random_uniform(40))
            let ranY = Int(arc4random_uniform(25) + 1)
            let Y = ranY + 120
            let moveAction = SKAction.move(by: CGVector(dx: ranX, dy: Y), duration: 3)
            moveAction.timingMode = .easeOut
            scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
    }
    
    func animateCoins(point: CGPoint) {
        let ran = CGFloat(arc4random_uniform(40)) - 20
        var coinFrames = [SKTexture]()
        coinFrames.append(SKTexture(image: UIImage(named: "coin")!))
        coinFrames.append(SKTexture(image: UIImage(named: "coin 2")!))
        coinFrames.append(SKTexture(image: UIImage(named: "coin 3")!))
        //laser animation
        let finalFrame = coinFrames[2]
        let coinPic = SKSpriteNode(texture:finalFrame)
        coinPic.position = CGPoint(x: point.x + ran, y: point.y + ran)
        coinPic.zPosition = 200
        gameLayer.addChild(coinPic)
        coinPic.run(SKAction.repeatForever(SKAction.animate(with: coinFrames,
                                                            timePerFrame: 0.02,
                                                            resize: false,
                                                            restore: true)))
        coinPic.run(SKAction.sequence([SKAction.move(to: CGPoint(x: frame.midX,y: header.position.y - 50), duration:0.9),SKAction.removeFromParent()]))
        coinPic.run(SKAction.fadeOut(withDuration: 0.9))
    }
    
    //CARD FLIP STUff
    func flipTile(node : SKSpriteNode, reveal: Bool) {
        let flip = SKAction.scaleY(to: -1, duration: 0.4)
        node.setScale(1.0)
        let flipback = SKAction.scaleY(to: 1, duration: 0.01)
        let cardNum = Int(arc4random_uniform(13)) + 1
        if reveal {
            selectedArray.append(cardNum)
        }
        else {
            self.selectedNum = cardNum
        }
        //this is the godo case
        let setfront = SKAction.run( { node.texture = SKTexture(imageNamed: "card \(cardNum)")})
        let action = SKAction.sequence([flip,flipback, setfront])
        
        node.run(action)
    }
    
    func addOkButtons() {
        //ok button
        var texture = SKTexture(image: UIImage(named: "ok")!)
        okButton = SKSpriteNode(texture:texture)
        okButton.position = CGPoint(x:self.frame.midX + 70, y:self.frame.midY - 120)
        cardLayer.addChild(okButton)
        if selectedNum <= 7 {
            texture = SKTexture(image: UIImage(named: "double card button")!)
        }
        else if selectedNum <= 12 && selectedNum > 7 {
            texture = SKTexture(image: UIImage(named: "negate bad card")!)
        }
        changeEffectButton = SKSpriteNode(texture:texture)
        changeEffectButton.position = CGPoint(x:self.frame.midX - 70, y:self.frame.midY - 120)
        cardLayer.addChild(changeEffectButton)
        if revealCards != nil {
            cardLayer.removeChildren(in: [revealCards])
            revealCards = nil
        }
        
    }
    
    func addQuestClaimButton() {
        let reappear = SKAction.scale(to: 1.3, duration: 0.2)
        let bounce1 = SKAction.scale(to: 0.8, duration: 0.1)
        let bounce2 = SKAction.scale(to: 1, duration: 0.1)

        let action2 = SKAction.sequence([reappear, bounce1, bounce2])
        
        let Texture = SKTexture(image: UIImage(named: "claim quest")!)
        claimQuestButton = SKSpriteNode(texture:Texture)
        // Place in scene
        claimQuestButton.position = CGPoint(x:self.frame.minX+65, y:self.frame.minY+60);
        
        switch UIDevice().screenType {
        case .iPhone8:
            claimQuestButton.position.y += 80
        case .iPhoneX:
            claimQuestButton.position = CGPoint(x:self.frame.minX+80, y:self.frame.minY+60);
            break
        default:
            break
        }
        self.addChild(claimQuestButton)
        claimQuestButton.run(action2)
    }
    
    func removeQuestButton() {
        let reappear = SKAction.scale(to: 1.3, duration: 0.2)
        let bounce1 = SKAction.scale(to: 0, duration: 0.1)
        let action2 = SKAction.sequence([reappear, bounce1, SKAction.removeFromParent()])
        if claimQuestButton != nil {
            claimQuestButton.run(action2)
        }
        
    }
    
    //restart the event timer (mostly when reentering the scene or unpausing after the card event
    func reactivateTimer() {
        eventTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(GameScene.triggerEvent), userInfo: nil, repeats: true)
    }
    
    //
    func kissOrFight() {
        //find the midpoint between the two sprites that are nearest each other on the screen and also within the maxdistance
        kfPoint = findTwoClosestSprites(maxDistance: CGFloat(50))
        if kfPoint.x < CGFloat(10000) {
            //kiss
            if Int(arc4random_uniform(3)) <= 1 {
                //animate haert
                var Texture = SKTexture(image: UIImage(named: "heart_emoji")!)
                let rando = randomInRange(lo: 1, hi: 6)
                switch rando {
                case 1:
                    Texture = SKTexture(image: UIImage(named: "heart_emoji_aqua")!)
                    break
                case 2:
                    Texture = SKTexture(image: UIImage(named: "heart_emoji_gold")!)
                    break
                case 3:
                    Texture = SKTexture(image: UIImage(named: "heart_emoji_indigo")!)
                    break
                case 4:
                    Texture = SKTexture(image: UIImage(named: "heart_emoji_red")!)
                    break
                case 5:
                    Texture = SKTexture(image: UIImage(named: "heart_emoji_seafoam")!)
                    break
                default:
                    Texture = SKTexture(image: UIImage(named: "heart_emoji")!)
                    break
                }
                let animheart = SKSpriteNode(texture:Texture)
                animheart.position = kfPoint
                deadLayer.addChild(animheart)
                let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 40), duration: 1.2)
                moveAction.timingMode = .easeOut
                playSound(select: "kiss")
                let rando2 = randomInRange(lo: 0, hi: 1)
                if rando2 == 0 {
                    animheart.run(SKAction.sequence([
                        .group([ moveAction,
                                 .sequence([.rotate(byAngle: .pi / 8, duration: 0.3),
                                            .rotate(byAngle: .pi / (-4), duration: 0.6),
                                            .rotate(byAngle: .pi / 8, duration: 0.3)
                                    ])
                            ]),
                        SKAction.fadeOut(withDuration: (0.35)),
                        SKAction.removeFromParent()]))
                }
                else {
                    animheart.run(SKAction.sequence([
                        .group([ moveAction,
                                 .sequence([.rotate(byAngle: .pi / (-8), duration: 0.3),
                                            .rotate(byAngle: .pi / (4), duration: 0.6),
                                            .rotate(byAngle: .pi / (-8), duration: 0.3)
                                    ])
                            ]),
                        SKAction.fadeOut(withDuration: (0.35)),
                        SKAction.removeFromParent()]))
                }
                
                //small chance for a baby
                if Int(arc4random_uniform(8)) <= 1 {
                    if let handler = touchHandler {
                        handler("kiss baby")
                    }
                }
            }
            //fight
            else {
                var fightFrames = [SKTexture]()
                var i = 1
                let numFrames = 5
                while(i <= numFrames) {
                    fightFrames.append(SKTexture(image: UIImage(named: "fight \(i)")!))
                    i += 1
                }
                let killChance = Int(arc4random_uniform(10))
                if killChance <= 1 {
                    fightFrames.append(SKTexture(image: UIImage(named: "knockout")!))
                    if let handler = touchHandler {
                        handler("knockout")
                    }
                }
                else {
                    fightFrames.append(SKTexture(image: UIImage(named: "punch")!))
                }
                
                let firstFrame = fightFrames[0]
                let fightPic = SKSpriteNode(texture:firstFrame)
                fightPic.position = kfPoint
                deadLayer.addChild(fightPic)
                playSound(select: "fight")
                fightPic.run(SKAction.sequence([SKAction.animate(with: fightFrames,
                                             timePerFrame: 0.4,
                                             resize: false,
                                             restore: true), SKAction.removeFromParent()]))
            }
        }
    }
    
    func findTwoClosestSprites(maxDistance: CGFloat) -> CGPoint {
        var dist  = maxDistance
        var spriteOne: SKNode? = nil
        var spriteTwo: SKNode? = nil
        var closeEnough = false
        var outerCount = 0
        for mold in moldLayer.children {
            var innerCount = 0
            for sMold in moldLayer.children {
                if innerCount != outerCount {
                    let sDist = CGPointDistance(from: mold.position, to: sMold.position)
                    if sDist < dist {
                        dist  = sDist
                        spriteOne = mold
                        spriteTwo = sMold
                        closeEnough = true
                    }
                }
                innerCount += 1
            }
            outerCount += 1
        }
        if closeEnough {
            return halfPoint(a: (spriteOne?.position)!, b: (spriteTwo?.position)!)
        }
        else {
            return CGPoint(x: 200000, y: 0 )
        }
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y);
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to));
    }
    
    func halfPoint(a: CGPoint, b: CGPoint) -> CGPoint {
        let xT = (a.x + b.x) / CGFloat(2)
        let yT = (a.y + b.y) / CGFloat(2)
        return CGPoint(x: xT, y: yT)
    }
    
    //MARK: - MOVE SPRITES
    //these next four methods are for moving molds around, nothing more
    func selectNodeForTouch(touchLocation: CGPoint) {
        // 1
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                selectedNode = touchedNode as! SKSpriteNode
            }
        }
    }
 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else { return }
        
        for touch in touches {
            
            let positionInScene = touch.location(in: moldLayer)
            let previousPosition = touch.previousLocation(in: moldLayer)
            let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
            
            panForTranslation(translation: translation)
            
            let loc = touch.location(in: fairyLayer)
            touchedPoints.append(loc)
        }

    }
    
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedNode.position
        
        if selectedNode.parent == moldLayer {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            
        }
    }
    
    //MARK: - VIBRATE
    func vibrateWithHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        //generator.prepare()
    
        generator.impactOccurred()
    }
    
}


