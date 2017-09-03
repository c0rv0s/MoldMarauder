//
//  QuestScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 3/19/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class QuestScene: SKScene {
    var mute = false
    
    var backButton: SKNode! = nil
    var claimQuestButton: SKNode! = nil
    var skipQuestButton: SKNode! = nil
    var facebookButton: SKNode! = nil
    
    var progressLabel: SKLabelNode! = nil
    var questName: SKLabelNode! = nil
    var screenshotHelp: SKLabelNode! = nil
    
    var currentQuest: String!
    var questGoal: Int!
    var questAmount: Int!
    
    let gameLayer = SKNode()
    let labelLayer = SKNode()
    let barLayer = SKNode()
    var point = CGPoint()
    
    var buyDiamondsButton: SKNode! = nil
    
    var cometLayer = SKNode()
    
    //touch handler
    var touchHandler: ((String) -> ())?
    
    //for background animations
    var backframes = [SKTexture]()
    let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "cyber_menu_glow")!))
    //comet sprites
    var cometSprite: SKNode! = nil
    var cometSprite2: SKNode! = nil
    var cometTimer: Timer!
    
    let levelUpSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let cashRegisterSound = SKAction.playSoundFileNamed("cash register.wav", waitForCompletion: false)
    let selectSound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
    let questSound = SKAction.playSoundFileNamed("quest complete.wav", waitForCompletion: false)
    let diamondPopSound = SKAction.playSoundFileNamed("bubble pop.wav", waitForCompletion: false)
    
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
        addChild(barLayer)
        labelLayer.zPosition = 200
        addChild(labelLayer)
        
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
        let Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+190);
        
        self.addChild(backButton)
        
        let title = SKLabelNode(fontNamed: "Lemondrop")
        title.fontSize = 24
        title.fontColor = UIColor.black
        title.text = "Current Quest:   "
        title.position = CGPoint(x:self.frame.midX, y:self.frame.midY+140)
        labelLayer.addChild(title)
        
        screenshotHelp = SKLabelNode(fontNamed: "Lemondrop")
        screenshotHelp.position = CGPoint(x:self.frame.midX, y:self.frame.midY-100)
        screenshotHelp.fontSize = 14
        screenshotHelp.fontColor = UIColor.black
        screenshotHelp.text = ""
        labelLayer.addChild(screenshotHelp)
        
        questName = SKLabelNode(fontNamed: "Lemondrop")
        questName.fontSize = 18
        questName.fontColor = UIColor.black
        if currentQuest[currentQuest.characters.count - 1] == "&" {
            //questName.text = "Buy 2 " + currentQuest.substring(to: currentQuest.index(before: currentQuest.endIndex)) + "s"
            questName.text = "Buy 2 " + currentQuest[..<currentQuest.index(before: currentQuest.endIndex)] + "s"
        }
        if currentQuest == "tap" {
            questName.text = "Tap " + String(questGoal!) + " times"
        }
        if currentQuest == "kill" {
            questName.text = "Kill " + String(questGoal!) + " worms"
        }
        if currentQuest == "discover" {
            questName.text = "Discover a new species"
        }
        if currentQuest == "level" {
            questName.text = "Level up 2 times"
        }
        if currentQuest == "faerie" {
            questName.text = "Capture " + String(questGoal!) +  " faeries."
        }
        if currentQuest == "FB" {
            questName.text = "Like Mold Marauder on Facebook"
            questName.fontSize = 12
        }
        if currentQuest == "screenshot" {
            questName.text = "Share a screenshot"
            screenshotHelp.text = "(Camera button, bottom right corner)"
        }
//questName.text = currentQuest
        questName.position = CGPoint(x:self.frame.midX, y:self.frame.midY+90)
        labelLayer.addChild(questName)
        
        if currentQuest == "FB" {
            let Texture = SKTexture(image: UIImage(named: "facebook_like")!)
            facebookButton = SKSpriteNode(texture:Texture)
            // Place in scene
            facebookButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY+50)
            labelLayer.addChild(facebookButton)
        }
        else {
            //set up progress bars
            //current quest
            progressLabel = SKLabelNode(fontNamed: "Lemondrop")
            progressLabel.fontSize = 18
            progressLabel.fontColor = UIColor.black
            if questAmount < questGoal {
                progressLabel.text = "\(questAmount!)/\(questGoal!)"
            }
            else {
                progressLabel.text = "Complete!"
            }
            progressLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+43);
            labelLayer.addChild(progressLabel)
            let progressBar = ProgressBar(color: SKColor.green, size:CGSize(width:250, height:25))
            let goal = Double(questAmount!) / Double(questGoal!)
            progressBar.progress = CGFloat(goal)
            progressBar.position = CGPoint(x:self.frame.midX, y:self.frame.midY+50);
            barLayer.addChild(progressBar)
        }
        
        if questAmount! >= questGoal {
            addClaimButton()
        }
        else {
            let Texture = SKTexture(image: UIImage(named: "skip quest")!)
            skipQuestButton = SKSpriteNode(texture:Texture)
            // Place in scene
            skipQuestButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-50)
            labelLayer.addChild(skipQuestButton)
        }
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            break
        case .iPhone5:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            break
        default:
            break
        }
    }
    
    func addClaimButton() {
        if skipQuestButton != nil {
            skipQuestButton.removeFromParent()
        }
        screenshotHelp.text = ""
        let reappear = SKAction.scale(to: 1.3, duration: 0.2)
        let bounce1 = SKAction.scale(to: 0.8, duration: 0.1)
        let bounce2 = SKAction.scale(to: 1, duration: 0.1)
        //this is the godo case
        let action2 = SKAction.sequence([reappear, bounce1, bounce2])
        
        let Texture = SKTexture(image: UIImage(named: "claim quest")!)
        claimQuestButton = SKSpriteNode(texture:Texture)
        // Place in scene
        claimQuestButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-50);
        
        labelLayer.addChild(claimQuestButton)
        claimQuestButton.run(action2)
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
        if claimQuestButton != nil {
            if claimQuestButton.contains(touchLocation) {
                if let handler = touchHandler {
                    handler("claim quest")
                }
            }
        }
        if skipQuestButton != nil {
            if skipQuestButton.contains(touchLocation) {
                if let handler = touchHandler {
                    handler("skip quest")
                }
            }
        }
        if facebookButton != nil {
            if facebookButton.contains(touchLocation) {
                if let handler = touchHandler {
                    handler("facebook")
                }
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
    
    func playSound(select: String) {
        if mute == false {
        switch select {
        case "levelup":
            run(levelUpSound)
        case "cash register":
            run(cashRegisterSound)
        case "select":
            run(selectSound)
        case "quest":
            run(questSound)
        case "diamond pop":
            run(diamondPopSound)
        default:
            run(levelUpSound)
        }
        }
    }
    
    func animateCoins() {
        var counter = 50
        while ( counter > 0) {
            var coinFrames = [SKTexture]()
            coinFrames.append(SKTexture(image: UIImage(named: "coin")!))
            coinFrames.append(SKTexture(image: UIImage(named: "coin 2")!))
            coinFrames.append(SKTexture(image: UIImage(named: "coin 3")!))
            //laser animation
            let finalFrame = coinFrames[2]
            let coinPic = SKSpriteNode(texture:finalFrame)
            let coinX = randomInRange(lo: Int(-250), hi: Int(250))
            let coinY = randomInRange(lo: Int(-1000), hi: Int(-200))
            coinPic.position = CGPoint(x: coinX, y: coinY)
            coinPic.zPosition = 200
            let size = Double.random0to1() * 2.5
            coinPic.setScale(CGFloat(size))
            gameLayer.addChild(coinPic)
            coinPic.run(SKAction.repeatForever(SKAction.animate(with: coinFrames,
                                                                timePerFrame: 0.02,
                                                                resize: false,
                                                                restore: true)))
            coinPic.run(SKAction.sequence([SKAction.move(to: CGPoint(x: CGFloat(coinX),y: frame.maxY + 90 ), duration:1.2),SKAction.removeFromParent()]))
            counter -= 1
        }
    }

    func animateName(name: String) {
        // Figure out what the midpoint of the chain is.
        let centerPosition = CGPoint(
            x: (self.frame.midX),
            y: (self.frame.midY))
        
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
    
    @objc func animateComets() {
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

extension Double {
    private static let arc4randomMax = Double(UInt32.max)
    
    static func random0to1() -> Double {
        return Double(arc4random()) / arc4randomMax
    }
}
