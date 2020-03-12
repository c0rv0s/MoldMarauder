//
//  MenuScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/3/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class MenuScene: SKScene {
    var mute = false
    
    var buyButton: SKNode!
    var exitButton: SKNode!
    var cheatButton: SKNode!
    //var resetButton: SKNode!
    var breedButton: SKNode!
    var levelButton: SKNode!
    var itemButton: SKNode!
    var achieveButton: SKNode!
    var creditsButton: SKNode!
    var questButton: SKNode!
    var helpButton: SKNode!
    var reinvestButton: SKNode!
    var arButton: SKNode!
    var leaderboards: SKNode!
    
//    rmeber ar state
    var arSwitch = false
    
    var touchHandler: ((String) -> ())?
    
    var background = Background()
    var cometLayer = CometLayer()
    
    var tutorialLayer = SKNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.start(size: size)
        addChild(background.background)
        addChild(cometLayer)
        createButton()
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        cometLayer.start(menu: true)
        arSwitch = false
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
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            exitButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            exitButton.setScale(0.75)
            break
        case .iPhone5:
            //iPhone 5
            exitButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            exitButton.setScale(0.75)
            break
        default:
            break
        }

        
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
        achieveButton.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+100);
        
        self.addChild(achieveButton)
        
//    leaderboards
        Texture = SKTexture(image: UIImage(named: "leaderboards button")!)
        leaderboards = SKSpriteNode(texture: Texture)
//    place in scene
        leaderboards.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+50);
        self.addChild(leaderboards)
        
        // CREDITS BUTTON
        Texture = SKTexture(image: UIImage(named: "credits button")!)
        creditsButton = SKSpriteNode(texture:Texture)
        // Place in scene
        creditsButton.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY-50);
        
        self.addChild(creditsButton)
        
        // QUEST BUTTON
        Texture = SKTexture(image: UIImage(named: "quest button")!)
        questButton = SKSpriteNode(texture:Texture)
        // Place in scene
        questButton.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY+150)
        
        self.addChild(questButton)
        
        // HELP BUTTON
        Texture = SKTexture(image: UIImage(named: "help button")!)
        helpButton = SKSpriteNode(texture:Texture)
        // Place in scene
        helpButton.position = CGPoint(x:self.frame.midX+65, y:self.frame.midY)
        
        self.addChild(helpButton)
        
        // CHEAT BUTTON
        Texture = SKTexture(image: UIImage(named: "cheat")!)
        cheatButton = SKSpriteNode(texture:Texture)
        // Place in scene
        cheatButton.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-150);
        
        //self.addChild(cheatButton)

        //level button
        Texture = SKTexture(image: UIImage(named: "level_up")!)
        levelButton = SKSpriteNode(texture: Texture)
        // Place in scene
        levelButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+150);
        
        self.addChild(levelButton)
        
        //REINVEST button
        Texture = SKTexture(image: UIImage(named: "reinvest button")!)
        reinvestButton = SKSpriteNode(texture: Texture)
        // Place in scene
        reinvestButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY-50);
        
        self.addChild(reinvestButton)
        
        //AR button
        Texture = SKTexture(image: UIImage(named: "armodeoff")!)
        arButton = SKSpriteNode(texture: Texture)
        // Place in scene
        arButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY-100);
        
        self.addChild(arButton)
 
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
        if leaderboards.contains(touchLocation) {
            print("leaderboards")
            if let handler = touchHandler {
                handler("leaderboards")
            }
        }
        if questButton.contains(touchLocation) {
            print("quest")
            if let handler = touchHandler {
                handler("quest")
            }
        }
        if helpButton.contains(touchLocation) {
            print("help")
            if let handler = touchHandler {
                handler("help")
            }
        }
        if reinvestButton.contains(touchLocation) {
            print("reinvest")
            if let handler = touchHandler {
                handler("reinvest")
            }
        }
        
        if arButton.contains(touchLocation) {
            print("ar")
            if let handler = touchHandler {
                if arSwitch {
                    arSwitch = false
                }
                else {
                    arSwitch = true
                }
                handler("ar")
            }
        }
 
    }
    
    //MARK: - TUTORIAL
    
    func buyMoldTut() {
        self.addChild(tutorialLayer)
        let appear = SKAction.scale(to: 1.1, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "intro box")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY-100);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)

        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.buyMoldTut2()
        }
        
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            
            introNode.setScale(0.9)
            
            break
        default:
            break
        }
    }
    func buyMoldTut2() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 15
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "This is the Menu Screen"
        welcomeTitle.position = CGPoint(x:self.frame.midX, y:self.frame.midY+15);
        tutorialLayer.addChild(welcomeTitle)
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 15
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "From here you can levelup"
        welcomeTitle2.position = CGPoint(x:self.frame.midX, y:self.frame.midY-20);
        tutorialLayer.addChild(welcomeTitle2)
        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 15
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "to increase your earnings"
        welcomeTitle3.position = CGPoint(x:self.frame.midX, y:self.frame.midY-40);
        tutorialLayer.addChild(welcomeTitle3)
        let welcomeTitle35 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle35.fontSize = 15
        welcomeTitle35.fontColor = UIColor.black
        welcomeTitle35.text = "from taps,"
        welcomeTitle35.position = CGPoint(x:self.frame.midX, y:self.frame.midY-60);
        tutorialLayer.addChild(welcomeTitle35)

        let welcomeTitle4 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle4.fontSize = 15
        welcomeTitle4.fontColor = UIColor.black
        welcomeTitle4.text = "buy buffs in the Item Shop,"
        welcomeTitle4.position = CGPoint(x:self.frame.midX, y:self.frame.midY-80);
        tutorialLayer.addChild(welcomeTitle4)
        let welcomeTitle5 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle5.fontSize = 15
        welcomeTitle5.fontColor = UIColor.black
        welcomeTitle5.text = "view achievemnets and quests"
        welcomeTitle5.position = CGPoint(x:self.frame.midX, y:self.frame.midY-100);
        tutorialLayer.addChild(welcomeTitle5)
        let welcomeTitle6 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle6.fontSize = 15
        welcomeTitle6.fontColor = UIColor.black
        welcomeTitle6.text = "and buy molds, to breed"
        welcomeTitle6.position = CGPoint(x:self.frame.midX, y:self.frame.midY-120);
        tutorialLayer.addChild(welcomeTitle6)
        let welcomeTitle7 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle7.fontSize = 15
        welcomeTitle7.fontColor = UIColor.black
        welcomeTitle7.text = "and discover new species"
        welcomeTitle7.position = CGPoint(x:self.frame.midX, y:self.frame.midY-140);
        tutorialLayer.addChild(welcomeTitle7)
        
        let welcomeTitle8 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle8.fontSize = 20
        welcomeTitle8.fontColor = UIColor.black
        welcomeTitle8.text = "Tap on the Mold Shop"
        welcomeTitle8.position = CGPoint(x:self.frame.midX, y:self.frame.midY-190);
        tutorialLayer.addChild(welcomeTitle8)
        
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            welcomeTitle35.setScale(0.9)
            welcomeTitle4.setScale(0.9)
            welcomeTitle5.setScale(0.9)
            welcomeTitle6.setScale(0.9)
            welcomeTitle7.setScale(0.9)
            welcomeTitle8.setScale(0.9)
            break
        default:
            break
        }

    }
    
    //MARK: - UTILITIES
    
    func playSound(select: String) {
        if mute == false {
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
    
}
