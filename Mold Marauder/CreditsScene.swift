//
//  CreditsScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 3/17/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class CreditsScene: SKScene {
    var mute = false
    
    var backButton: SKNode!
    var revButton: SKNode!
    var listenButton: SKNode!
    
    var musicButton: SKNode!
    var soundButton: SKNode!
    
    var musicMute: SKNode!
    var soundMute: SKNode!
    
    let gameLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = CometLayer()
    
    var APP_ID = "com.Spacey-Dreams.Mold-Marauder"
    
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
        
        let labelOne = SKLabelNode(fontNamed: "Lemondrop")
        labelOne.fontSize = 13
        labelOne.fontColor = UIColor.black
        labelOne.text = "Nathan Mueller:"
        labelOne.position = CGPoint(x:self.frame.midX, y:self.frame.midY+150)
        addChild(labelOne)
        
        let labelTwo = SKLabelNode(fontNamed: "Lemondrop")
        labelTwo.fontSize = 13
        labelTwo.fontColor = UIColor.black
        labelTwo.text = "Code, Game Design, Sound Design, Art"
        labelTwo.position = CGPoint(x:self.frame.midX, y:self.frame.midY+136)
        addChild(labelTwo)
        
        let labelThree = SKLabelNode(fontNamed: "Lemondrop")
        labelThree.fontSize = 13
        labelThree.fontColor = UIColor.black
        labelThree.text = "valdez and Spacey Dreams:"
        labelThree.position = CGPoint(x:self.frame.midX, y:self.frame.midY+115)
        addChild(labelThree)

        let labelFour = SKLabelNode(fontNamed: "Lemondrop")
        labelFour.fontSize = 13
        labelFour.fontColor = UIColor.black
        labelFour.text = "Music"
        labelFour.position = CGPoint(x:self.frame.midX, y:self.frame.midY+102)
        addChild(labelFour)
        
        Texture = SKTexture(image: UIImage(named: "listen button")!)
        listenButton = SKSpriteNode(texture:Texture)
        // Place in scene
        listenButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY+85)
        
//    self.addChild(listenButton)
        
        let labelFive = SKLabelNode(fontNamed: "Lemondrop")
        labelFive.fontSize = 13
        labelFive.fontColor = UIColor.black
        labelFive.text = "Special Thanks:"
        labelFive.position = CGPoint(x:self.frame.midX, y:self.frame.midY+40)
        addChild(labelFive)
        
        let labelSix = SKLabelNode(fontNamed: "Lemondrop")
        labelSix.fontSize = 13
        labelSix.fontColor = UIColor.black
        labelSix.text = "Github user mkrd:"
        labelSix.position = CGPoint(x:self.frame.midX, y:self.frame.midY+27)
        addChild(labelSix)
        
        let labelSeven = SKLabelNode(fontNamed: "Lemondrop")
        labelSeven.fontSize = 13
        labelSeven.fontColor = UIColor.black
        labelSeven.text = "for Swift-Big-Integer"
        labelSeven.position = CGPoint(x:self.frame.midX, y:self.frame.midY+14)
        addChild(labelSeven)
        
        let labelEight = SKLabelNode(fontNamed: "Lemondrop")
        labelEight.fontSize = 13
        labelEight.fontColor = UIColor.black
        labelEight.text = "Github user crashoverride777:"
        labelEight.position = CGPoint(x:self.frame.midX, y:self.frame.midY-8)
        addChild(labelEight)
        
        let labelNine = SKLabelNode(fontNamed: "Lemondrop")
        labelNine.fontSize = 13
        labelNine.fontColor = UIColor.black
        labelNine.text = "for SwiftySKScrollView"
        labelNine.position = CGPoint(x:self.frame.midX, y:self.frame.midY-22)
        addChild(labelNine)
        
        let labelTen = SKLabelNode(fontNamed: "Lemondrop")
        labelTen.fontSize = 13
        labelTen.fontColor = UIColor.black
        labelTen.text = "And RayWenderleich.com"
        labelTen.position = CGPoint(x:self.frame.midX, y:self.frame.midY-44)
        addChild(labelTen)
        
        let label11 = SKLabelNode(fontNamed: "Lemondrop")
        label11.fontSize = 13
        label11.fontColor = UIColor.black
        label11.text = "For countless invaluable tutorials"
        label11.position = CGPoint(x:self.frame.midX, y:self.frame.midY-58)
        addChild(label11)
        
        // Review
        Texture = SKTexture(image: UIImage(named: "review button")!)
        revButton = SKSpriteNode(texture:Texture)
        // Place in scene
        revButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-130)
        
        self.addChild(revButton)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            labelOne.setScale(0.75)
            labelTwo.setScale(0.75)
            labelThree.setScale(0.75)
            labelFour.setScale(0.75)
            labelFive.setScale(0.75)
            labelSix.setScale(0.75)
            labelSeven.setScale(0.75)
            labelEight.setScale(0.75)
            labelNine.setScale(0.75)
            labelTen.setScale(0.75)
            label11.setScale(0.75)
            break
        case .iPhone5:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            labelOne.setScale(0.75)
            labelTwo.setScale(0.75)
            labelThree.setScale(0.75)
            labelFour.setScale(0.75)
            labelFive.setScale(0.75)
            labelSix.setScale(0.75)
            labelSeven.setScale(0.75)
            labelEight.setScale(0.75)
            labelNine.setScale(0.75)
            labelTen.setScale(0.75)
            label11.setScale(0.75)
            break
        default:
            break
        }
        
        // music
        Texture = SKTexture(image: UIImage(named: "music_mute")!)
        musicButton = SKSpriteNode(texture:Texture)
        // Place in scene
        musicButton.position = CGPoint(x:self.frame.midX-50, y:self.frame.midY-190)
        
        self.addChild(musicButton)
        
        // sound
        Texture = SKTexture(image: UIImage(named: "sound_mute")!)
        soundButton = SKSpriteNode(texture:Texture)
        // Place in scene
        soundButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-190)
        
        self.addChild(soundButton)
    }
    
    func addMuteMusic() {
        let Texture = SKTexture(image: UIImage(named: "mute_x")!)
        musicMute = SKSpriteNode(texture:Texture)
        // Place in scene
        musicMute.position = musicButton.position
        
        self.addChild(musicMute)
    }
    func removeMuteMusic() {
        musicMute.removeFromParent()
    }
    func addMuteSound() {
        let Texture = SKTexture(image: UIImage(named: "mute_x")!)
        soundMute = SKSpriteNode(texture:Texture)
        // Place in scene
        soundMute.position = soundButton.position
        
        self.addChild(soundMute)
    }
    func removeMuteSound() {
        soundMute.removeFromParent()
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
        if revButton.contains(touchLocation) {
            print("review")
            if let handler = touchHandler {
                handler("review")
            }
        }
        if listenButton.contains(touchLocation) {
            print("listen")
            if let handler = touchHandler {
                handler("listen")
            }
        }
        if musicButton.contains(touchLocation) {
            print("music")
            if let handler = touchHandler {
                handler("music")
            }
        }
        if soundButton.contains(touchLocation) {
            print("sound")
            if let handler = touchHandler {
                handler("sound")
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
        default:
            run(levelUpSound)
        }
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
}
