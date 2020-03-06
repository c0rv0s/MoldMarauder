//
//  ARScene.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 9/7/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
import ARKit

class ARScene: SKScene {
    var creationTime : TimeInterval = 0
    var ARdisplayCount: Int!
    //var sceneView: ARSKView!
    
//    gameScene stuff
    var mute = false
    var header: SKNode! = nil
    var buyButton: SKNode! = nil
    var diamondIcon: SKNode! = nil
    var diamondCLabel: SKLabelNode! = nil
    var diamondBuy: SKNode! = nil
    
    var buyEnabled = true
    var claimQuestButton: SKNode! = nil
    
    var numDiamonds: Int = 0
    var diamondShop = false
    
    var diamondTiny: SKNode! = nil
    var diamondSmall: SKNode! = nil
    var diamondMedium: SKNode! = nil
    var diamondLarge: SKNode! = nil
    var exitDiamond: SKNode! = nil
    var diamondShelves: SKSpriteNode!
    
    var tinyButton: SKSpriteNode! = nil
    var smallButton: SKSpriteNode! = nil
    var mediumButton: SKSpriteNode! = nil
    var largeButton: SKSpriteNode! = nil
    
    var menuPopUp: SKSpriteNode!
    
    var inventoryButton: SKNode! = nil
    var cameraButton: SKNode! = nil
    
    var tapPoint: BInt!
    
    var center:  CGPoint!
    
    //spritz and xtap
    var wormRepelLabel: SKLabelNode! = nil
    var spritzLabel: SKLabelNode! = nil
    var xTapLabel: SKLabelNode! = nil
    
//    worm
    var deadFrames = [SKTexture]()
    var laserFrames = [SKTexture]()
    
    var wormChompTimers = [Timer]()
    var wormDifficulty = 6
    var deathRay = false
    var laserPower = 0
    
    var wormCollection = [SKNode]()
    var moldCollection = [SKNode]()
    var holeCollection = [BlackHole]()
    var wormHole = false
    var wormBottom: Float = 4.0
    var wormTop: Float = 8.0
//    for levels
    var moldName = ""
    
    var touchHandler: ((String) -> ())?
    //    MARK: - init stuff
    
    override init(size: CGSize) {
        super.init(size: size)
        //sceneView = self.view as? ARSKView
        center = CGPoint(x:self.frame.midX, y:self.frame.midY)
        //createButton()
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        print("ar scene loadaded ")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if currentTime > creationTime {
            createAnchor()
            if ARdisplayCount > 0 {
                creationTime = currentTime + 0.1
            }
            else {
                creationTime = currentTime + TimeInterval(Float.random(in: wormBottom ..< wormTop))
            }
        }
    }

    func createAnchor(){
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Define 360º in radians
        let _360degrees = 2.0 * Float.pi
        
        // Create a rotation matrix in the X-axis
        let rotateX = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * Float.random(in: 0.0 ..< 1.0), 1, 0, 0))
        
        // Create a rotation matrix in the Y-axis
        let rotateY = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * Float.random(in: 0.0 ..< 1.0), 0, 1, 0))
        
        // Combine both rotation matrices
        let rotation = simd_mul(rotateX, rotateY)
        
        // Create a translation matrix in the Z-axis with a value between 1 and 2 meters
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1 - Float.random(in: 0.0 ..< 1.0)
        
        // Combine the rotation and translation matrices
        let transform = simd_mul(rotation, translation)
        
        // Create an anchor
        let anchor = ARAnchor(transform: transform)
        
        // Add the anchor
        sceneView.session.add(anchor: anchor)
    }
    
   
    //    MARK: - TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the first touch
        guard let touch = touches.first else {
            return
        }
        // Get the location in the AR scene
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node == buyButton {
            if let handler = touchHandler {
                print("buy butt")
                handler("ar_scene_buy")
            }
        }
        if node == cameraButton {
            if let handler = touchHandler {
                handler("ar_camera")
            }
        }
        if node == inventoryButton {
            if let handler = touchHandler {
                handler("ar_inventory")
            }
        }
        if node == diamondBuy {
            
            if let handler = touchHandler {
                handler("diamond_buy")
            }
        }
        
        // Get the nodes at that location
        let hit = nodes(at: location)
        // Get the first node (if any)
        if let node = hit.first {
//            what if its a black hole?
            if node.name == "hole" {
                if randomInRange(lo: 1, hi: 20) == 5 {
                    if let handler = touchHandler {
                        handler("addDiamond")
                    }
                    //animate dimmond
                    let Texture = SKTexture(image: UIImage(named: "diamond_glow")!)
                    let animDiamond = SKSpriteNode(texture:Texture)
                    animDiamond.name = "naw"
                    animDiamond.position =  CGPoint(x:self.frame.midX, y:self.frame.midY)
                    self.addChild(animDiamond)
                    let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                    moveAction.timingMode = .easeOut
                    playSound(select: "gem collect")
                    animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                }
            }
            // what if its a mold?
            if node.name!.count > 5 {
                print("hey it mold")
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
                heart.name = "naw"
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
                //                    level up mold
                if let handler = touchHandler {
                    moldName = node.name!
                    handler("level_mold")
                }
            }
            else if node.name == "button" {
                print("hey it button")
            }
            else if node.name == "label" {
                print("hey it label")
            }
            // Check if the node is a worm
            else {
                if node.name!.count == 1 {
                    print("HIT")
                    let wormNum = Int(node.name!)
                    
                    node.name = String(wormNum! - 1)
                    if deathRay {
                        node.name = "0"
                    }
                    let rotation = Int(arc4random_uniform(15)) * 24
                    let finalLaserFrame = laserFrames[3]
                    let laserPic = SKSpriteNode(texture:finalLaserFrame)
                    laserPic.name = "naw"
                    laserPic.position = node.position
                    self.addChild(laserPic)
                    let rotateR = SKAction.rotate(byAngle: CGFloat(rotation), duration: 0.01)
                    let actionST = SKAction.sequence([rotateR])
                    laserPic.run(actionST)
                    
                    playSound(select: "laser")
                    laserPic.run(SKAction.sequence([SKAction.animate(with: laserFrames,
                                                                     timePerFrame: 0.1,
                                                                     resize: false,
                                                                     restore: true), SKAction.removeFromParent()]))
                    
                    if Int(node.name!)! < 1 {
                        if wormChompTimers.count > 0 {
                            wormChompTimers[wormChompTimers.count - 1].invalidate()
                            wormChompTimers.remove(at: wormChompTimers.count - 1)
                        }
                        
                        if let handler = touchHandler {
                            handler("wurmded")
                        }
                        //animate dead worm
                        var index = 0
                        loop: for pNode in wormCollection {
                            if pNode == node {
                                wormCollection.remove(at: index)
                                break loop
                            }
                            index += 1
                        }
                        playSound(select: "dead")
                        node.run(SKAction.sequence([SKAction.animate(with: deadFrames,
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
                            animDiamond.position = node.position
                            animDiamond.name = "naw"
                            self.addChild(animDiamond)
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
                            animDiamond.position = node.position
                            animDiamond.name = "naw"
                            self.addChild(animDiamond)
                            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                            moveAction.timingMode = .easeOut
                            playSound(select: "gem collect")
                            animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
    //    MARK: - SPRITEKIT HANDLERS
    //do le wirm atek
    func wormAttack() -> (frames:[SKTexture], wormPic: SKNode) {

        var wormFrames = [SKTexture]()
        
        var i = 1
        let numFrames = 4
        while(i <= numFrames) {
            wormFrames.append(SKTexture(image: UIImage(named: "hole F\(i)")!))
            i += 1
        }
        let x = Float.random(in: 0.0 ..< 1.0)
        if x < 1{
            wormFrames.append(SKTexture(image: UIImage(named: "worm right")!))
        }
        else {
            wormFrames.append(SKTexture(image: UIImage(named: "worm left")!))
        }
        
        let finalFrame = wormFrames[4]
        let wormPic = SKSpriteNode(texture:finalFrame)
        
        return (wormFrames, wormPic)
    }
    
    func createButton() {
        //HEADER
        var Texture = SKTexture(image: UIImage(named: "header")!)
        header = SKSpriteNode(texture: Texture)
        header.name = "naw"
        header.setScale(0.38)
        // Place in scene
        header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+270);
        
        // BUY
        Texture = SKTexture(image: UIImage(named: "BUY")!)
        buyButton = SKSpriteNode(texture: Texture)
        buyButton.name = "naw"
        // Place in scene
        buyButton.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY+270);
        
        //DIAMOND ICON
        Texture = SKTexture(image: UIImage(named: "diamond")!)
        diamondIcon = SKSpriteNode(texture: Texture)
        diamondIcon.name = "naw"
        diamondIcon.position = CGPoint(x:self.frame.midX-105, y:self.frame.midY+270);
        
        //DIAMOND BUY
        Texture = SKTexture(image: UIImage(named: "plus")!)
        diamondBuy = SKSpriteNode(texture: Texture)
        diamondBuy.name = "naw"
        diamondBuy.position = CGPoint(x:self.frame.midX-140, y:self.frame.midY+270);
        
        // DIAMOND LABEL
        diamondCLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondCLabel.fontSize = 18
        diamondCLabel.name = "naw"
        diamondCLabel.fontColor = UIColor.black
        diamondCLabel.text = String(describing: numDiamonds)
        
        
        diamondCLabel.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY+262);
        
        //        adjust for screen sizes
        switch UIDevice().screenType {
        case .iPhone4:
            header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+195)
            buyButton.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY+195)
            diamondIcon.position = CGPoint(x:self.frame.midX-105, y:self.frame.midY+195)
            diamondBuy.position = CGPoint(x:self.frame.midX-140, y:self.frame.midY+195)
            diamondCLabel.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY+187)
            break
        case .iPhone5:
            //iPhone 5
            header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+230)
            buyButton.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY+230)
            diamondIcon.position = CGPoint(x:self.frame.midX-105, y:self.frame.midY+230)
            diamondBuy.position = CGPoint(x:self.frame.midX-140, y:self.frame.midY+230)
            diamondCLabel.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY+222)
            break
        case .iPhone6Plus:
            // Code for iPhone 6 Plus & iPhone 7 Plus
            header.position = CGPoint(x:self.frame.midX, y:self.frame.midY+310)
            buyButton.position = CGPoint(x:self.frame.midX+100, y:self.frame.midY+310)
            diamondIcon.position = CGPoint(x:self.frame.midX-105, y:self.frame.midY+310)
            diamondBuy.position = CGPoint(x:self.frame.midX-140, y:self.frame.midY+310)
            diamondCLabel.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY+302)
            break
        default:
            break
        }
        //        now place the elements
        self.addChild(header)
        self.addChild(buyButton)
        self.addChild(diamondIcon)
        self.addChild(diamondBuy)
        self.addChild(diamondCLabel)
        /*
        //CAMERA
        Texture = SKTexture(image: UIImage(named: "camera")!)
        cameraButton = SKSpriteNode(texture: Texture)
        cameraButton.position = CGPoint(x:self.frame.maxX - 40, y:self.frame.minY + 100);
        self.addChild(cameraButton)
        */
        //INVENTORY BUTTON
        Texture = SKTexture(image: UIImage(named: "inventory button")!)
        inventoryButton = SKSpriteNode(texture: Texture)
        inventoryButton.name = "naw"
        inventoryButton.position = CGPoint(x:self.frame.maxX - 40, y:self.frame.minY + 40);
        self.addChild(inventoryButton)
        
        wormRepelLabel = SKLabelNode(fontNamed: "Lemondrop")
        wormRepelLabel.name = "naw"
        wormRepelLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+190)
        self.addChild(wormRepelLabel)
        
        spritzLabel = SKLabelNode(fontNamed: "Lemondrop")
        spritzLabel.name = "naw"
        spritzLabel.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+190)
        spritzLabel.fontColor = UIColor.yellow
        self.addChild(spritzLabel)
        
        xTapLabel = SKLabelNode(fontNamed: "Lemondrop")
        xTapLabel.name = "naw"
        xTapLabel.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+190)
        xTapLabel.fontColor = UIColor.green
        self.addChild(xTapLabel)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 4
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
        default:
            break
        }
        
        self.diamondShop = false
    }
    
    func animateMold(moldData: Mold) -> (pic:SKSpriteNode, frames:[SKTexture]) {
        var moldPic: SKSpriteNode! = nil
        var frames = [SKTexture]()
        //molds w/ no animation
        if (moldData.moldType == MoldType.invisible || moldData.moldType == MoldType.disaffected || moldData.moldType == MoldType.dead) {
            let imName = String(moldData.name)
            let Image = UIImage(named: imName)
            let Texture = SKTexture(image: Image!)
            
            frames.append(Texture)
            moldPic = SKSpriteNode(texture:Texture)
        }
            //MOLDS WITH CUSTOM ANIMATION INSTRUCTIONS
        else if (moldData.moldType == MoldType.circuit || moldData.moldType == MoldType.nuclear) {
            let textureOn = SKTexture(image: UIImage(named: moldData.name)!)
            let textureOff = SKTexture(image: UIImage(named: moldData.name + " Off")!)
            let textureTwo = SKTexture(image: UIImage(named: moldData.name + " T Blink")!)
            let textureThree = SKTexture(image: UIImage(named: moldData.name + " B Blink")!)
            let textureFour = SKTexture(image: UIImage(named: moldData.name + " F Blink")!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.samurai) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.magma) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.cryptid) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.cloud) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            let textureTwo = SKTexture(image: UIImage(named: moldData.name + " T Blink")!)
            let textureThree = SKTexture(image: UIImage(named: moldData.name + " B Blink")!)
            let textureFour = SKTexture(image: UIImage(named: moldData.name + " F Blink")!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.hologram) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            //            frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.storm) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.coconut) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.angry) {
            //            var frames = [SKTexture]()
            
            var i = 1
            let numFrames = 5
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            moldPic = SKSpriteNode(texture:firstFrame)
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.astronaut) {
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.zombie) {
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.virus) {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.x) {
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.hypno || moldData.moldType == MoldType.flower || moldData.moldType == MoldType.water) {
            //            var frames = [SKTexture]()
            
            var i = 2
            let numFrames = 21
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.pimply) {
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.crystal) {
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
        }
        else if (moldData.moldType == MoldType.alien) {
            
            let textureOne = SKTexture(image: UIImage(named: "Alien Mold")!)
            let textureTwo = SKTexture(image: UIImage(named: "Alien Mold F2")!)
            let textureThree = SKTexture(image: UIImage(named: "Alien Mold F3")!)
            let textureFour = SKTexture(image: UIImage(named: "Alien Mold F4")!)
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.rainbow) {
            //            var frames = [SKTexture]()
            
            var i = 1
            let numFrames = 11
            while(i<numFrames) {
                frames.append(SKTexture(image: UIImage(named: "Rainbow Mold F\(i)")!))
                i += 1
            }
            
            let firstFrame = frames[0]
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.slinky) {
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.coffee) {
            //            var frames = [SKTexture]()
            
            frames.append(SKTexture(image: UIImage(named: "Coffee Mold F1")!))
            frames.append(SKTexture(image: UIImage(named: "Coffee Mold F2")!))
            
            let firstFrame = frames[0]
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.angel) {
            //            var frames = [SKTexture]()
            
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
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        else if (moldData.moldType == MoldType.star) {
            //            var frames = [SKTexture]()
            
            frames.append(SKTexture(image: UIImage(named: "Star Mold")!))
            var i = 1
            while(i<8) {
                frames.append(SKTexture(image: UIImage(named: String(moldData.name + " F\(i)"))!))
                i += 1
            }
            
            let firstFrame = frames[0]
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
            //THIS IS FOR MOLDS THAT JUST BLINK
        else {
            let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
            let textureTwo = SKTexture(image: UIImage(named: moldData.name + " T Blink")!)
            let textureThree = SKTexture(image: UIImage(named: moldData.name + " B Blink")!)
            let textureFour = SKTexture(image: UIImage(named: moldData.name + " F Blink")!)
            //            var blinkFrames = [SKTexture]()
            
            var i = 0
            let numFrames = (Int(arc4random_uniform(6)) + 8)*10
            while(i<numFrames) {
                frames.append(textureOne)
                i += 1
            }
            frames.append(textureTwo)
            frames.append(textureThree)
            frames.append(textureFour)
            frames.append(textureThree)
            frames.append(textureTwo)
            
            let firstFrame = frames[0]
            moldPic = SKSpriteNode(texture:firstFrame)
            
            
        }
        return (moldPic, frames)
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
}
