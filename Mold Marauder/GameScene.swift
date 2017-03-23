//
//  GameScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 1/31/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var header: SKNode! = nil
    var buyButton: SKNode! = nil
    var diamondIcon: SKNode! = nil
    var diamondCLabel: SKLabelNode! = nil
    var diamondBuy: SKNode! = nil
    
    var numDiamonds: Int!
    var diamondShop = false
    
    var backgroundName = "cave"
    
    var diamondTiny: SKNode! = nil
    var diamondSmall: SKNode! = nil
    var diamondMedium: SKNode! = nil
    var diamondLarge: SKNode! = nil
    var exitDiamond: SKNode! = nil
    var diamondShelves: SKSpriteNode!
    
    var menuPopUp: SKSpriteNode!
    
    var inventoryButton: SKNode! = nil
    var cameraButton: SKNode! = nil
    
    var tapPoint: BInt!
    
    var molds: Array<Mold>!
    //var worms = [SKSpriteNode]()
    var wormHP = [Int]()
    var wormChompTimers = [Timer]()
    var eventTimer: Timer!
    var wormDifficulty = 6
    var wormRepel = false
    var wormRepelTimer: Timer!
    var wormRepelCount = 0
    var wormRepelLabel: SKLabelNode! = nil
    var deathRay = false
    var laserPower = 0
    
    //cards
    let cardLayer = SKNode()
    var card1: SKNode! = nil
    var card2: SKNode! = nil
    var card3: SKNode! = nil
    var revealCards: SKNode! = nil
    var cardsActive = false
    var okButton: SKNode! = nil
    var changeEffectButton: SKNode! = nil
    var cardSelected = false
    var cardRevealed = false
    var selectedNum = 0
    var selectedArray = [Int]()
    //card effects
    
    var sleepButton: SKNode! = nil
    
    var xTapCount = 0
    var xTapAmount = 100
    var spritzAmount = 1
    var spritzCount = 0
    var spritzLabel: SKLabelNode! = nil
    var xTapLabel: SKLabelNode! = nil
    
    var center:  CGPoint!
    var tapLoc: CGPoint!
    
    let gameLayer = SKNode()
    let moldLayer = SKNode()
    let diamondLayer = SKNode()
    let wormLayer = SKNode()
    let deadLayer = SKNode()
    let sleepLayer = SKNode()
    let kissOrFightLayer = SKNode()
    var deadFrames = [SKTexture]()
    var laserFrames = [SKTexture]()
    
    let eventLayer = SKNode()
    
    var background: SKSpriteNode!
    
    var touchHandler: ((String) -> ())?
    
    let levelUpSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let cardFlipSound = SKAction.playSoundFileNamed("card flip.wav", waitForCompletion: false)
    let laserSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
    let deadSound = SKAction.playSoundFileNamed("dead.wav", waitForCompletion: false)
    let kissSound = SKAction.playSoundFileNamed("kiss.wav", waitForCompletion: false)
    let fightSound = SKAction.playSoundFileNamed("fight sound_mixdown.wav", waitForCompletion: false)
    let dingSound = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
    let badCardSound = SKAction.playSoundFileNamed("bad card.wav", waitForCompletion: false)
    let gemCollectSound = SKAction.playSoundFileNamed("gem collect.wav", waitForCompletion: false)
    let crunchSound = SKAction.playSoundFileNamed("crunch.wav", waitForCompletion: false)
    let gemCaseSound = SKAction.playSoundFileNamed("gem case.wav", waitForCompletion: false)
    let chestSound = SKAction.playSoundFileNamed("chest.wav", waitForCompletion: false)
    let wormAppearSound = SKAction.playSoundFileNamed("worm appear.wav", waitForCompletion: false)
    let selectSound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
    let cameraSound = SKAction.playSoundFileNamed("camera.wav", waitForCompletion: false)
    let exitSound = SKAction.playSoundFileNamed("exit.mp3", waitForCompletion: false)
    
    var animateTimer: Timer!
    
    var selectedNode = SKNode()
    
    var isActive = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background = SKSpriteNode(imageNamed: backgroundName)
        background.size = size//CGSize(width: CGFloat(Int(size.width) * 2), height: size.height)
        addChild(background)
        
        
        if ((molds) != nil) {
            updateMolds()
        }
        
        wormRepelLabel = SKLabelNode(fontNamed: "Lemondrop")
        wormRepelLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+190)
        self.addChild(wormRepelLabel)
        
        spritzLabel = SKLabelNode(fontNamed: "Lemondrop")
        spritzLabel.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+190)
        spritzLabel.fontColor = UIColor.yellow
        self.addChild(spritzLabel)
        
        xTapLabel = SKLabelNode(fontNamed: "Lemondrop")
        xTapLabel.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+190)
        xTapLabel.fontColor = UIColor.green
        self.addChild(xTapLabel)
        
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
        
        addChild(gameLayer)
        addChild(moldLayer)
        diamondLayer.zPosition = 300
        addChild(diamondLayer)
        
        addChild(wormLayer)
        addChild(deadLayer)
        cardLayer.zPosition = 300
        addChild(cardLayer)
        sleepLayer.zPosition = 800
        addChild(sleepLayer)
        
        createButton()
        
        center = CGPoint(x:self.frame.midX, y:self.frame.midY)
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    override func didMove(to view: SKView) {
        //EVENT TRIGGER TIMER
        //setDiamondLabel()
        reactivateTimer()
    }
    
    func setBackground() {
        let disappear = SKAction.scale(to: 0, duration: 0.3)
        let action = SKAction.sequence([disappear])
        _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(GameScene.backgroundPartTwo), userInfo: nil, repeats: false)
        background.run(action)
    }
    
    func backgroundPartTwo() {
        background.texture = SKTexture(imageNamed: backgroundName)
        
        let reappear = SKAction.scale(to: 1.1, duration: 0.2)
        let bounce1 = SKAction.scale(to: 0.89, duration: 0.1)
        let bounce2 = SKAction.scale(to: 1, duration: 0.1)
        //this is the godo case
        let action2 = SKAction.sequence([reappear, bounce1, bounce2])
        background.run(action2)
    }
    
    func createButton() {
        var Texture = SKTexture(image: UIImage(named: "header")!)
        header = SKSpriteNode(texture: Texture)
        header.setScale(0.38)
        // Place in scene
        header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+270);
        
        self.addChild(header)
        // BUY
        Texture = SKTexture(image: UIImage(named: "BUY")!)
        buyButton = SKSpriteNode(texture: Texture)
        // Place in scene
        buyButton.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY+270);
        
        self.addChild(buyButton)
        //DIAMOND ICON
        Texture = SKTexture(image: UIImage(named: "diamond")!)
        diamondIcon = SKSpriteNode(texture: Texture)
        diamondIcon.position = CGPoint(x:self.frame.midX-105, y:self.frame.midY+270);
        self.addChild(diamondIcon)
        
        //DIAMOND BUY
        Texture = SKTexture(image: UIImage(named: "plus")!)
        diamondBuy = SKSpriteNode(texture: Texture)
        diamondBuy.position = CGPoint(x:self.frame.midX-140, y:self.frame.midY+270);
        self.addChild(diamondBuy)
       
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
        
        // DIAMOND LABEL
        diamondCLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondCLabel.fontSize = 18
        diamondCLabel.fontColor = UIColor.black
        diamondCLabel.text = ""//String(numDiamonds)
        diamondCLabel.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY+262);
        self.addChild(diamondCLabel)
        
        self.diamondShop = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Stop node from moving to touch
        if let handler = touchHandler {
            handler("tap ended")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard let touch = touches.first else { return }
        tapLoc = touch.location(in: gameLayer)
        if let handler = touchHandler {
            handler("tap")
        }
        
        
        
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            print("tap")
            if sleepButton != nil {
                if node == sleepButton {
                    if let handler = touchHandler {
                        handler("awake")
                    }
                }
            }
            
            if cardsActive {
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
                //Boop the worms
                let wormBoop = touch.location(in: wormLayer)
                let boopedWorm = self.atPoint(wormBoop)
                if boopedWorm is SKSpriteNode {
                    // 2
                    var index = 0   //this is for trackign something
                    for worm in wormLayer.children {
                        if worm.position == boopedWorm.position {
                            if index < wormHP.count {

                                //laser animation
                                let rotation = Int(arc4random_uniform(15)) * 24
                                let finalLaserFrame = laserFrames[3]
                                let laserPic = SKSpriteNode(texture:finalLaserFrame)
                                laserPic.position = worm.position
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
                                    wormHP[index] = 0
                                }
                                else {
                                    wormHP[index] -= 1
                                }
                                
                                if wormHP[index] == 0 {
                                    //wurm ded
                                    if let handler = touchHandler {
                                        handler("wurmded")
                                    }
                                    wormHP.remove(at: index)
                                    wormChompTimers[index].invalidate()
                                    wormChompTimers.remove(at: index)
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
                                        wormLayer.addChild(animDiamond)
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
                                        wormLayer.addChild(animDiamond)
                                        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                                        moveAction.timingMode = .easeOut
                                        playSound(select: "gem collect")
                                        animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                                    }
                                    
                                }
                            }
                        }
                        index += 1
                    }
                }
                //booping complete
                
                if node == buyButton {
                    eventTimer.invalidate()
                    eventTimer = nil
                    if let handler = touchHandler {
                        handler("game_scene_buy")
                    }
                }
                if node == inventoryButton {
                    eventTimer.invalidate()
                    eventTimer = nil
                    if let handler = touchHandler {
                        handler("game_scene_inventory")
                    }
                }
                if node == cameraButton {
                    if let handler = touchHandler {
                        handler("game_scene_camera")
                    }
                }
                if node == diamondBuy {
                    eventTimer.invalidate()
                    eventTimer = nil
                    if let handler = touchHandler {
                        handler("diamond_buy")
                    }
                }
                
                
                if diamondShop {
                    if exitDiamond != nil {
                        if node == exitDiamond {
                            reactivateTimer()
                            if let handler = touchHandler {
                                handler("diamond_exit")
                            }
                        }
                    }
                    if diamondTiny != nil {
                        if node == diamondTiny {
                            if let handler = touchHandler {
                                handler("diamond_tiny")
                            }
                        }
                    }
                    if diamondSmall != nil {
                        if node == diamondSmall {
                            if let handler = touchHandler {
                                handler("diamond_small")
                            }
                        }
                    }
                    if diamondMedium != nil {
                        if node == diamondMedium {
                            if let handler = touchHandler {
                                handler("diamond_medium")
                            }
                        }
                    }
                    if diamondLarge != nil {
                        if node == diamondLarge {
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
        }
    }

    func endRepelTimer() {
        wormRepelCount = 0
        wormRepel = false
    }
    
    func playSound(select: String) {
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
        default:
            run(levelUpSound)
        }
    }
    
    func sleep() {
        wormHP = []
        wormLayer.removeAllChildren()
        for timer in wormChompTimers {
            timer.invalidate()
        }
        wormChompTimers = []
        eventTimer.invalidate()
        
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
    }
    
    func doDiamondShop() {
        print("do the shop")
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
        exitDiamond.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+235);
        diamondLayer.addChild(exitDiamond)
        
        Texture = SKTexture(image: UIImage(named: "tiny diamonds")!)
        diamondTiny = SKSpriteNode(texture:Texture)
        // Place in scene
        diamondTiny.position = CGPoint(x: -75, y: 155)
        diamondLayer.addChild(diamondTiny)
        var diamondLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel.fontSize = 20
        diamondLabel.text = "5 Diamonds"
        diamondLabel.position = CGPoint(x: 30, y: 160)
        diamondLabel.color = UIColor.black
        diamondLayer.addChild(diamondLabel)
        var priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        priceLabel.text = "0.99$"
        priceLabel.position = CGPoint(x: 30, y: 135)
        diamondLayer.addChild(priceLabel)
        priceLabel.fontColor = UIColor.black
        diamondLabel.fontColor = UIColor.black
        
        Texture = SKTexture(image: UIImage(named: "small diamonds")!)
        diamondSmall = SKSpriteNode(texture:Texture)
        // Place in scene
        diamondSmall.position = CGPoint(x: -75, y: 45)
        diamondLayer.addChild(diamondSmall)
        diamondLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel.fontSize = 20
        diamondLabel.text = "16 Diamonds"
        diamondLabel.position = CGPoint(x: 30, y: 50)
        diamondLabel.color = UIColor.black
        diamondLayer.addChild(diamondLabel)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        priceLabel.text = "2.99$"
        priceLabel.position = CGPoint(x: 30, y: 25)
        diamondLayer.addChild(priceLabel)
        priceLabel.fontColor = UIColor.black
        diamondLabel.fontColor = UIColor.black
        
        Texture = SKTexture(image: UIImage(named: "medium diamonds")!)
        diamondMedium = SKSpriteNode(texture:Texture)
        // Place in scene
        diamondMedium.position = CGPoint(x: -75, y: -65)
        diamondLayer.addChild(diamondMedium)
        diamondLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel.fontSize = 20
        diamondLabel.text = "57 Diamonds"
        diamondLabel.position = CGPoint(x: 30, y: -60)
        diamondLabel.color = UIColor.black
        diamondLayer.addChild(diamondLabel)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        priceLabel.text = "9.99$"
        priceLabel.position = CGPoint(x: 30, y: -85)
        diamondLayer.addChild(priceLabel)
        priceLabel.fontColor = UIColor.black
        diamondLabel.fontColor = UIColor.black
        
        Texture = SKTexture(image: UIImage(named: "big diamonds")!)
        diamondLarge = SKSpriteNode(texture:Texture)
        // Place in scene
        diamondLarge.position = CGPoint(x: -75, y: -175)
        diamondLayer.addChild(diamondLarge)
        diamondLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel.fontSize = 16
        diamondLabel.text = "301 Diamonds"
        diamondLabel.position = CGPoint(x: 30, y: -170)
        diamondLabel.color = UIColor.black
        diamondLayer.addChild(diamondLabel)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 16
        priceLabel.text = "49.99$"
        priceLabel.position = CGPoint(x: 30, y: -195)
        diamondLayer.addChild(priceLabel)
        priceLabel.fontColor = UIColor.black
        diamondLabel.fontColor = UIColor.black
        
        print("diamons shop dome")
    }
    
    func updateMolds() {
        
        var i = 0
        var j = 0
        
        var quantity = 0
        
        if molds.count != moldLayer.children.count {
            moldLayer.removeAllChildren()
            mainLoop: while(moldLayer.children.count < molds.count){
                quantity = moldLayer.children.count
                let moldData = molds[quantity]
                    //molds w/ no animation
                    if (moldData.moldType == MoldType.invisible || moldData.moldType == MoldType.disaffected || moldData.moldType == MoldType.dead) {
                        let imName = String(moldData.name)
                        let Image = UIImage(named: imName!)
                        let Texture = SKTexture(image: Image!)
                        
                        let moldPic = SKSpriteNode(texture:Texture)
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        
                        var i = 2
                        while(i<11) {
                            var j = 1
                            let numFrames = (Int(arc4random_uniform(6)) + 2)*2
                            while(j < numFrames) {
                                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                                j += 1
                            }
                            i += 1
                        }
                        
                        let firstFrame = frames[0]
                        let moldPic = SKSpriteNode(texture:firstFrame)
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
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
                        moldPic.position = CGPoint(x:self.frame.midX+CGFloat(i), y:self.frame.midY+CGFloat(j))
                        moldLayer.addChild(moldPic)
                        moldPic.run(SKAction.repeatForever(
                            SKAction.animate(with: blinkFrames,
                                             timePerFrame: 0.1,
                                             resize: false,
                                             restore: true)),
                                    withKey:"moldBlinking")
                        
                    }
                    
                    print(moldData.name + " added to scene")
                    i = Int(arc4random_uniform(200)) - 100
                    j = Int(arc4random_uniform(200)) - 200
                quantity += 1
                if quantity > 42 {
                    break mainLoop
                }
            }
        }
    }
    
    func animateSpritz() {
        let particle = SKTexture(image: UIImage(named: "glowing particle")!)
        for mold in moldLayer.children {
            var counter = 0
            while (counter < 15) {
                var partNode = SKSpriteNode(texture: particle)
                var size = Double.random0to1() * 0.8
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
    
    //every 8 seconds trigger event
    /*
     EVENTS:
     some chance of each:
        - WORM ATTACK: USE THE LASRS TO DEFEAT THE DEATH WORMS BEFORE THEY DEVOUR YOU!
        - three cards appear, pick one for buff or debuff. pay diamonds to see all cards
        - idk tbh
     */
    func triggerEvent() {
        print("event triggered")
        let ran = Int(arc4random_uniform(100))
        //make sure user isn't buying diamonds
        if diamondShop == false {
            //worm attak
            if ran <= 40 {
                if wormRepel == false {
                    wormAttack()
                }
            }
            if ran > 40 && ran < 60 {
                //text message
                
            }
            //card pick
            if ran >  95 {
                if let handler = touchHandler {
                    handler("touchOFF")
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
                eventTimer.invalidate()
                playSound(select: "card flip")
            }
        }
    }
    
    //do le wirm atek
    func wormAttack() {
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
        wormChompTimers.append(Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GameScene.eatMold), userInfo: nil, repeats: true))
        wormHP.append(wormDifficulty)
        wormPic.position = CGPoint(x: x, y: y)
        wormLayer.addChild(wormPic)
        playSound(select: "worm appear")
        wormPic.run(SKAction.animate(with: wormFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true))
    }
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    //eat mold
    func eatMold() {
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
    
    //animate the little numbers wiggling up
    func animateScore(point: CGPoint, amount: BInt, tap: Bool) {
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
        else if xTapCount > 0 {
            scoreLabel.fontColor = UIColor.green
            scoreLabel.fontSize = 20
        }
        gameLayer.addChild(scoreLabel)
        
        let ranX = Int(arc4random_uniform(40)) - 20
        let ranY = Int(arc4random_uniform(25) + 1)
        let Y = ranY + 120
        let moveAction = SKAction.move(by: CGVector(dx: ranX, dy: Y), duration: 3)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        
        //coin
        if tap {
            var coinFrames = [SKTexture]()
            coinFrames.append(SKTexture(image: UIImage(named: "coin")!))
            coinFrames.append(SKTexture(image: UIImage(named: "coin 2")!))
            coinFrames.append(SKTexture(image: UIImage(named: "coin 3")!))
            //laser animation
            let finalFrame = coinFrames[2]
            let coinPic = SKSpriteNode(texture:finalFrame)
            coinPic.position = CGPoint(x: scoreLabel.position.x + CGFloat(ranX), y: scoreLabel.position.y)
            coinPic.zPosition = 200
            gameLayer.addChild(coinPic)
            coinPic.run(SKAction.repeatForever(SKAction.animate(with: coinFrames,
                                                             timePerFrame: 0.02,
                                                             resize: false,
                                                             restore: true)))
            coinPic.run(SKAction.sequence([SKAction.move(to: CGPoint(x: frame.midX,y: frame.maxY - 90), duration:0.9),SKAction.removeFromParent()]))
        }
 
    }
    
    //add suffix to long numbers
    func formatNumber(points: BInt) -> String {
        var cashString = String(describing: points)
        if (cashString.characters.count < 4) {
            return String(describing: points)
        }
        else {
            let charsCount = cashString.characters.count
            var cashDisplayString = cashString[0]
            
            var suffix = ""
            switch charsCount {
            case 4:
                suffix = "K"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 5:
                suffix = "K"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 6:
                suffix = "K"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 7:
                suffix = "M"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 8:
                suffix = "M"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 9:
                suffix = "M"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 10:
                suffix = "B"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 11:
                suffix = "B"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 12:
                suffix = "B"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 13:
                suffix = "T"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 14:
                suffix = "T"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 15:
                suffix = "T"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 16:
                suffix = "Q"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 17:
                suffix = "Q"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 18:
                suffix = "Q"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 19:
                suffix = "Qi"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 20:
                suffix = "Qi"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 21:
                suffix = "Qi"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 22:
                suffix = "Se"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 23:
                suffix = "Se"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 24:
                suffix = "Se"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 25:
                suffix = "Sp"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 26:
                suffix = "Sp"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 27:
                suffix = "Sp"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 28:
                suffix = "Oc"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 29:
                suffix = "Oc"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 30:
                suffix = "Oc"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            case 31:
                suffix = "No"
                cashDisplayString = cashDisplayString + "." + cashString[1]
                break
            case 32:
                suffix = "No"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
                break
            case 33:
                suffix = "No"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
                break
            default:
                suffix = "D"
                break
            }
            cashDisplayString += " "
            cashDisplayString += suffix
            
            return cashDisplayString
        }
    }
    
    //CARD FLIP STUff
    func flipTile(node : SKSpriteNode, reveal: Bool) {
        let flip = SKAction.scaleY(to: -1, duration: 0.4)
        node.setScale(1.0)
        let flipback = SKAction.scaleY(to: 1, duration: 0.01)
        let cardNum = Int(arc4random_uniform(12)) + 1
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
        else {
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
    
    //restart the event timer (mostly when reentering the scene or unpausing after the card event
    func reactivateTimer() {
        eventTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(GameScene.triggerEvent), userInfo: nil, repeats: true)
    }
    
    //
    func kissOrFight() {
        //find the midpoint between the two sprites that are nearest each other on the screen and also within the maxdistance
        let kfPoint = findTwoClosestSprites(maxDistance: CGFloat(100))
        if kfPoint.x < CGFloat(10000) {
            //kiss
            if Int(arc4random_uniform(2)) == 1 {
                //animate haert
                let Texture = SKTexture(image: UIImage(named: "heart_emoji")!)
                let animheart = SKSpriteNode(texture:Texture)
                animheart.position = kfPoint
                deadLayer.addChild(animheart)
                let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                moveAction.timingMode = .easeOut
                animheart.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                playSound(select: "kiss")
                //small chance for a baby
                if Int(arc4random_uniform(250)) == 100 {
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
                if Int(arc4random_uniform(250)) == 100 {
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
    
    
}

extension Double {
    private static let arc4randomMax = Double(UInt32.max)
    
    static func random0to1() -> Double {
        return Double(arc4random()) / arc4randomMax
    }
}

