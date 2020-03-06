//
//  LevelScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 3/10/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class LevelScene: SKScene {
    var mute = false
    
    var backButton: SKNode! = nil
    var levelButton: SKNode! = nil
    var levelLabel: SKLabelNode! = nil
    var currentScorePerTapLabel: SKLabelNode! = nil
    var currentLevelUpCostLabel: SKLabelNode! = nil
    var nextScorePerTapLabel: SKLabelNode! = nil
    
    var cash = BInt(0)
    var diamonds = 0
    var currentLevel = 0
    var currentScorePerTap = BInt(0)
    var levelUpCost = BInt(0)
    var levelUpCostActual = BInt(0) // use this variable (sorry for the confusion)
    var nextScorePerTap = BInt(0)
    
    let gameLayer = SKNode()
    let buttonLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = CometLayer()
    
    var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    var page1ScrollView = SKSpriteNode()
    
    var lastButton : CGPoint!
    
    var caveButton: SKNode! = nil
    var yachtExButton: SKNode! = nil
    var crysForestButton: SKNode! = nil
    var apartmentButton: SKNode! = nil
    var apartment2Button: SKNode! = nil
    var yurtButton:SKNode! = nil
    var sandButton: SKNode! = nil
    var spaceButton: SKNode! = nil
    var space2Button: SKNode! = nil
    
    var checkmark: SKNode! = nil
    var current: String!
    
    //offlien level
    
    var offlineLevelButton: SKNode! = nil
    var offlineLev = 0
    var buyDiamondsButton: SKNode! = nil
    
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
        
        addChild(buttonLayer)
        addChild(gameLayer)
        
        let _ = SKLabelNode(fontNamed: "Lemondrop")
        //calculateScorePerTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        cometLayer.start(menu: false)
        
        createButton()
        erectScroll()
    }
    
    func createButton()
    {
        // BACK MENU
        var Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+190);
        
        buttonLayer.addChild(backButton)
        
        //level button
        let levelLabel2 = SKLabelNode(fontNamed: "Lemondrop")
        levelLabel2.fontSize = 21
        levelLabel2.fontColor = UIColor.black
        levelLabel2.text = "Online Earnings"
        levelLabel2.position = CGPoint(x:self.frame.midX, y:self.frame.midY+180);
        buttonLayer.addChild(levelLabel2)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            levelLabel2.setScale(0)
            break
        case .iPhone5:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            break
        default:
            break
        }
        
        Texture = SKTexture(image: UIImage(named: "level_up")!)
        if cash < levelUpCostActual {
            Texture = SKTexture(image: UIImage(named: "level_up_grey")!)
        }
        levelButton = SKSpriteNode(texture: Texture)
        // Place in scene
        levelButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY+150);
        
        buttonLayer.addChild(levelButton)
        
        levelLabel = SKLabelNode(fontNamed: "Lemondrop")
        levelLabel.fontSize = 28
        levelLabel.fontColor = UIColor.black
        levelLabel.text = "Lv: \(currentLevel)"
        levelLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY+135);
        buttonLayer.addChild(levelLabel)
        
        currentLevelUpCostLabel = SKLabelNode(fontNamed: "Lemondrop")
        currentLevelUpCostLabel.fontSize = 16
        currentLevelUpCostLabel.fontColor = UIColor.black
        if currentLevel < 75 {
            currentLevelUpCostLabel.text = "LevelUp Cost: \(formatNumber(points: levelUpCostActual))"
        }
        else {
            currentLevelUpCostLabel.text = "MAX LEVEL"
        }
        currentLevelUpCostLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+80);
        buttonLayer.addChild(currentLevelUpCostLabel)
        
        currentScorePerTapLabel = SKLabelNode(fontNamed: "Lemondrop")
        currentScorePerTapLabel.fontSize = 16
        currentScorePerTapLabel.fontColor = UIColor.black
        currentScorePerTapLabel.text = "Current Score/Tap: \(formatNumber(points: currentScorePerTap))"
        currentScorePerTapLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+60);
        buttonLayer.addChild(currentScorePerTapLabel)
        
        nextScorePerTapLabel = SKLabelNode(fontNamed: "Lemondrop")
        nextScorePerTapLabel.fontSize = 16
        nextScorePerTapLabel.fontColor = UIColor.black
        if currentLevel < 75 {
            nextScorePerTapLabel.text = "Next ScorePerTap: \(formatNumber(points: nextScorePerTap))"
        }
        else {
            nextScorePerTapLabel.text = "MAX LEVEL"
        }
        nextScorePerTapLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+40);
        buttonLayer.addChild(nextScorePerTapLabel)
        
        //offlien earnings
        Texture = SKTexture(image: UIImage(named: "offline level")!)
        
        offlineLevelButton = SKSpriteNode(texture: Texture)
        // Place in scene
        offlineLevelButton.position = CGPoint(x:self.frame.midX-65, y:self.frame.midY-45);
        
        buttonLayer.addChild(offlineLevelButton)
        
        let levelLabel1 = SKLabelNode(fontNamed: "Lemondrop")
        levelLabel1.fontSize = 21
        levelLabel1.fontColor = UIColor.black
        levelLabel1.text = "Offline Earnings"
        levelLabel1.position = CGPoint(x:self.frame.midX, y:self.frame.midY-10);
        buttonLayer.addChild(levelLabel1)
        
        levelLabel = SKLabelNode(fontNamed: "Lemondrop")
        levelLabel.fontSize = 28
        levelLabel.fontColor = UIColor.black
        levelLabel.text = "Lv: \(offlineLev)"
        levelLabel.position = CGPoint(x:self.frame.midX+50, y:self.frame.midY-60);
        buttonLayer.addChild(levelLabel)
        
        let offLevUp = SKLabelNode(fontNamed: "Lemondrop")
        offLevUp.fontSize = 16
        offLevUp.fontColor = UIColor.black
        
        if offlineLev < 24 {
            offLevUp.text = "LevelUp Cost: 2 Diamonds"
        }
        if offlineLev >= 24 && offlineLev <= 48 {
            offLevUp.text = "LevelUp Cost: 4 Diamonds"
        }
        if offlineLev > 48 {
            offLevUp.text = "MAX LEVEL"
        }
        offLevUp.position = CGPoint(x:self.frame.midX, y:self.frame.midY-90);
        buttonLayer.addChild(offLevUp)
        
        let currentOffline = SKLabelNode(fontNamed: "Lemondrop")
        currentOffline.fontSize = 16
        currentOffline.fontColor = UIColor.black
        currentOffline.text = "Current: \(Double(offlineLev)*30.0/60.0) hours"
        currentOffline.position = CGPoint(x:self.frame.midX, y:self.frame.midY-110);
        buttonLayer.addChild(currentOffline)
        
        let nextOffline = SKLabelNode(fontNamed: "Lemondrop")
        nextOffline.fontSize = 16
        nextOffline.fontColor = UIColor.black
        if offlineLev < 48 {
            nextOffline.text = "Next: \(Double(offlineLev + 1)*30.0/60.0) hours"
        }
        else {
            nextOffline.text = "MAX LEVEL"
        }
        nextOffline.position = CGPoint(x:self.frame.midX, y:self.frame.midY-130);
        buttonLayer.addChild(nextOffline)
    }
    
    func erectScroll() {
        //var width = CGFloat((currentLevel/6) * 120)
        addChild(moveableNode)
        
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 495, width: frame.width, height: frame.height * 0.25), moveableNode: moveableNode, direction: .horizontal)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width * 3, height: scrollView!.frame.height) // * 3 makes it three times as wide
        view?.addSubview(scrollView!)
        scrollView?.setContentOffset(CGPoint(x: 0 + frame.width * 2, y: 0), animated: true)
        
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        var yPOS = frame.midY - 220
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            yPOS = frame.midY - 185
            break
        default:
            break
        }
        
        page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX - (frame.width * 2), y: yPOS)
        moveableNode.addChild(page1ScrollView)

        lastButton = CGPoint(x: -180, y: 0)
            var Texture = SKTexture(image: UIImage(named: "cave button")!)
            // slime
            caveButton = SKSpriteNode(texture:Texture)
            // Place in scene
            caveButton.position = CGPoint(x: lastButton.x+120, y: lastButton.y)
            lastButton = caveButton.position
            page1ScrollView.addChild(caveButton)
        if currentLevel >= 15 {
            Texture = SKTexture(image: UIImage(named: "forest button")!)
            // slime
            crysForestButton = SKSpriteNode(texture:Texture)
            // Place in scene
            crysForestButton.position = CGPoint(x: lastButton.x+120, y: lastButton.y)
            lastButton = crysForestButton.position
            page1ScrollView.addChild(crysForestButton)
        }
        if currentLevel >= 30 {
            Texture = SKTexture(image: UIImage(named: "yurt button")!)
            // slime
            yurtButton = SKSpriteNode(texture:Texture)
            // Place in scene
            yurtButton.position = CGPoint(x: lastButton.x+120, y: lastButton.y)
            lastButton = yurtButton.position
            page1ScrollView.addChild(yurtButton)
        }
        if currentLevel >= 45 {
            Texture = SKTexture(image: UIImage(named: "apartment button")!)
            // slime
            apartmentButton = SKSpriteNode(texture:Texture)
            // Place in scene
            apartmentButton.position = CGPoint(x: lastButton.x+120, y: lastButton.y)
            lastButton = apartmentButton.position
            page1ScrollView.addChild(apartmentButton)
        }
        if currentLevel >= 60 {
            Texture = SKTexture(image: UIImage(named: "yachtExButton")!)
            // slime
            yachtExButton = SKSpriteNode(texture:Texture)
            // Place in scene
            yachtExButton.position = CGPoint(x: lastButton.x+120, y: lastButton.y)
            lastButton = yachtExButton.position
            page1ScrollView.addChild(yachtExButton)
        }
        if currentLevel >= 75 {
            Texture = SKTexture(image: UIImage(named: "space button")!)
            // slime
            spaceButton = SKSpriteNode(texture:Texture)
            // Place in scene
            spaceButton.position = CGPoint(x: lastButton.x+120, y: lastButton.y)
            lastButton = spaceButton.position
            page1ScrollView.addChild(spaceButton)
        }
        
        if checkmark != nil {
            checkmark.removeFromParent()
        }
        Texture = SKTexture(image: UIImage(named: "checkmark")!)
        checkmark = SKSpriteNode(texture:Texture)
        switch current {
        case "cave":
            checkmark.position = caveButton.position
            page1ScrollView.addChild(checkmark)
            break
        case "crystal forest":
            checkmark.position = crysForestButton.position
            page1ScrollView.addChild(checkmark)
            break
        case "apartment":
            checkmark.position = apartmentButton.position
            page1ScrollView.addChild(checkmark)
            break
        case "yurt":
            checkmark.position = yurtButton.position
            page1ScrollView.addChild(checkmark)
            break
        case "yacht exterior":
            checkmark.position = yachtExButton.position
            page1ScrollView.addChild(checkmark)
            break
        case "space":
            checkmark.position = spaceButton.position
            page1ScrollView.addChild(checkmark)
            break
        default:
            checkmark.position = caveButton.position
            page1ScrollView.addChild(checkmark)
            break
        }
        
    }
    
    func reloadScroll() {
        
        //self.removeAllChildren()
        page1ScrollView.removeAllChildren()
        moveableNode.removeAllChildren()
        moveableNode.removeFromParent()
        nilButtons()
        scrollView?.removeFromSuperview()
        scrollView = nil
        
        erectScroll()
    }
    
    func nilButtons() {
        
        caveButton = nil
        yachtExButton = nil
        crysForestButton = nil
        apartmentButton = nil
        apartment2Button = nil
        yurtButton = nil
        sandButton = nil
        spaceButton = nil
        space2Button = nil
        
        checkmark = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            point = touch.location(in: gameLayer)
            if node == backButton {
                print("back")
                if let handler = touchHandler {
                    handler("back")
                }
            }
            
            if node == levelButton {
                print("level")
                if let handler = touchHandler {
                    handler("level")
                }
            }
            if node == offlineLevelButton {
                print("offlinelevel")
                if let handler = touchHandler {
                    handler("offlinelevel")
                }
            }
            if buyDiamondsButton != nil {
                if node == buyDiamondsButton {
                    if let handler = touchHandler {
                        handler("addDiamonds")
                    }
                }
            }
            if caveButton != nil {
                if node == caveButton {
                    print("cave")
                    checkmark.position = caveButton.position
                    if let handler = touchHandler {
                        handler("cave")
                    }
                }
            }
            if crysForestButton != nil {
                if node == crysForestButton {
                    print("crysForest")
                    
                    checkmark.position = crysForestButton.position
                    
                    if let handler = touchHandler {
                        handler("crysForest")
                    }
                }
            }
            if apartmentButton != nil {
                if node == apartmentButton {
                    print("apartment")
                    
                    checkmark.position = apartmentButton.position
                    
                    if let handler = touchHandler {
                        handler("apartment")
                    }
                }
            }
            if yachtExButton != nil {
                if node == yachtExButton {
                    print("yachtEx")
                    
                    checkmark.position = yachtExButton.position
                    
                    if let handler = touchHandler {
                        handler("yachtEx")
                    }
                }
            }
            if apartment2Button != nil {
                if node == apartment2Button {
                    print("apartment2")
                    
                    checkmark.position = apartment2Button.position
                    
                    if let handler = touchHandler {
                        handler("apartment2")
                    }
                }
            }
            if yurtButton != nil {
                if node == yurtButton {
                    print("yurt")
                    
                    checkmark.position = yurtButton.position
                    
                    if let handler = touchHandler {
                        handler("yurt")
                    }
                }
            }
            if sandButton != nil {
                if node == sandButton {
                    print("sand")
                    
                    checkmark.position = sandButton.position
                    
                    if let handler = touchHandler {
                        handler("sand")
                    }
                }
            }
            if spaceButton != nil {
                if node == spaceButton {
                    print("space")
                    
                    checkmark.position = spaceButton.position
                    
                    if let handler = touchHandler {
                        handler("space")
                    }
                }
            }
            if space2Button != nil {
                if node == space2Button {
                    print("space2")
                    
                    checkmark.position = space2Button.position
                    
                    if let handler = touchHandler {
                        handler("space2")
                    }
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
        case "diamond pop":
            run(diamondPopSound)
        case "ding":
            run(dingSound)
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
    
    func calculateScorePerTap() {
        switch(currentLevel + 1) {
        case 0:
            nextScorePerTap = BInt(10)
            levelUpCost = BInt(2500)
            break
        case 1:
            nextScorePerTap = BInt(40)
            levelUpCost = BInt(5000)
            break
        case 2:
            nextScorePerTap = BInt(60)
            levelUpCost = BInt(10000)
            break
        case 3:
            nextScorePerTap = BInt(80)
            levelUpCost = BInt(20000)
            break
        case 4:
            nextScorePerTap = BInt(250)
            levelUpCost = BInt(40000)
            break
        case 5:
            nextScorePerTap = BInt(500)
            levelUpCost = BInt(80000)
            break
        case 6:
            nextScorePerTap = BInt(800)
            levelUpCost = BInt(160000)
            break
        case 7:
            nextScorePerTap = BInt(1250)
            levelUpCost = BInt(320000)
            break
        case 8:
            nextScorePerTap = BInt("2750")!
            levelUpCost = BInt("640000")!
            break
        case 9:
            nextScorePerTap = BInt("3250")!
            levelUpCost = BInt("1200000")!
            break
        case 10:
            nextScorePerTap = BInt("5000")!
            levelUpCost = BInt("2400000")!
            break
        case 11:
            nextScorePerTap = BInt("8000")!
            levelUpCost = BInt("4800000")!
            break
        case 12:
            nextScorePerTap = BInt("12000")!
            levelUpCost = BInt("9600000")!
            break
        case 13:
            nextScorePerTap = BInt("18000")!
            levelUpCost = BInt("18000000")!
            break
        case 14:
            nextScorePerTap = BInt("32000")!
            levelUpCost = BInt("36000000")!
            break
        case 15:
            nextScorePerTap = BInt("64000")!
            levelUpCost = BInt("72000000")!
            break
        case 16:
            nextScorePerTap = BInt("80000")!
            levelUpCost = BInt("108000000")!
            break
        case 17:
            nextScorePerTap = BInt("100000")!
            levelUpCost = BInt("162000000")!
            break
        case 18:
            nextScorePerTap = BInt("125000")!
            levelUpCost = BInt("243000000")!
            break
        case 19:
            nextScorePerTap = BInt("156250")!
            levelUpCost = BInt("364500000")!
            break
        case 20:
            nextScorePerTap = BInt("195312")!
            levelUpCost = BInt("546750000")!
            break
        case 21:
            nextScorePerTap = BInt("244140")!
            levelUpCost = BInt("820125000")!
            break
        case 22:
            nextScorePerTap = BInt("305175")!
            levelUpCost = BInt("1230187500")!
            break
        case 23:
            nextScorePerTap = BInt("381468")!
            levelUpCost = BInt("1845281250")!
            break
        case 24:
            nextScorePerTap = BInt("686642")!
            levelUpCost = BInt("2767921875")!
            break
        case 25:
            nextScorePerTap = BInt("8926352")!
            levelUpCost = BInt("4151882812")!
            break
        case 26:
            nextScorePerTap = BInt("1115793")!
            levelUpCost = BInt("6300000000")!
            break
        case 27:
            nextScorePerTap = BInt("1394741")!
            levelUpCost = BInt("9450000000")!
            break
        case 28:
            nextScorePerTap = BInt("1743426")!
            levelUpCost = BInt("14175000000")!
            break
        case 29:
            nextScorePerTap = BInt("2266454")!
            levelUpCost = BInt("21262500000")!
            break
        case 30:
            nextScorePerTap = BInt("3173036")!
            levelUpCost = BInt("31893750000")!
            break
        case 31:
            nextScorePerTap = BInt("3966295")!
            levelUpCost = BInt("47840625000")!
            break
        case 32:
            nextScorePerTap = BInt("4957869")!
            levelUpCost = BInt("71760937500")!
            break
        case 33:
            nextScorePerTap = BInt("6197336")!
            levelUpCost = BInt("107641406250")!
            break
        case 34:
            nextScorePerTap = BInt("9296004")!
            levelUpCost = BInt("161462109375")!
            break
        case 35:
            nextScorePerTap = BInt("11620005")!
            levelUpCost = BInt("258339375000")!
            break
        case 36:
            nextScorePerTap = BInt("145250060")!
            levelUpCost = BInt("413343000000")!
            break
        case 37:
            nextScorePerTap = BInt("217875090")!
            levelUpCost = BInt("661348800000")!
            break
        case 38:
            nextScorePerTap = BInt("2723438060")!
            levelUpCost = BInt("1058158080000")!
            break
        case 39:
            nextScorePerTap = BInt("3404298300")!
            levelUpCost = BInt("1693052928000")!
            break
        case 40:
            nextScorePerTap = BInt("6127737000")!
            levelUpCost = BInt("2708884684800")!
            break
        case 41:
            nextScorePerTap = BInt("7659671200")!
            levelUpCost = BInt("4334215495680")!
            break
        case 42:
            nextScorePerTap = BInt("957500000")!
            levelUpCost = BInt("6934744793088")!
            break
        case 43:
            nextScorePerTap = BInt("11968750000")!
            levelUpCost = BInt("11095591668940")!
            break
        case 44:
            nextScorePerTap = BInt("21543750000")!
            levelUpCost = BInt("17600000000000")!
            break
        case 45:
            nextScorePerTap = BInt("26929687500")!
            levelUpCost = BInt("28160000000000")!
            break
        case 46:
            nextScorePerTap = BInt("33750000000")!
            levelUpCost = BInt("45056000000000")!
            break
        case 47:
            nextScorePerTap = BInt("42187500000")!
            levelUpCost = BInt("72089600000000")!
            break
        case 48:
            nextScorePerTap = BInt("105468750000")!
            levelUpCost = BInt("115343360000000")!
            break
        case 49:
            nextScorePerTap = BInt("158203125000")!
            levelUpCost = BInt("184549376000000")!
            break
        case 50:
            nextScorePerTap = BInt("237304687005")!
            levelUpCost = BInt("295279001600000")!
            break
        case 51:
            nextScorePerTap = BInt("355957031200")!
            levelUpCost = BInt("531502202880000")!
            break
        case 52:
            nextScorePerTap = BInt("533935546800")!
            levelUpCost = BInt("956703965184000")!
            break
        case 53:
            nextScorePerTap = BInt("8009033203000")!
            levelUpCost = BInt("1722067137331200")!
            break
        case 54:
            nextScorePerTap = BInt("1201354980400")!
            levelUpCost = BInt("3099720847196160")!
            break
        case 55:
            nextScorePerTap = BInt("3604064941400")!
            levelUpCost = BInt("5579497524953088")!
            break
        case 56:
            nextScorePerTap = BInt("10812194824200")!
            levelUpCost = BInt("10043095544915560")!
            break
        case 57:
            nextScorePerTap = BInt("32436584472600")!
            levelUpCost = BInt("18077571980848000")!
            break
        case 58:
            nextScorePerTap = BInt("97309753417900")!
            levelUpCost = BInt("32539629565526410")!
            break
        case 59:
            nextScorePerTap = BInt("15000000000000")!
            levelUpCost = BInt("58571333217947540")!
            break
        case 60:
            nextScorePerTap = BInt("22500000000000")!
            levelUpCost = BInt("105428399792305617")!
            break
        case 61:
            nextScorePerTap = BInt("33750000000000")!
            levelUpCost = BInt("100897711196261517")!
            break
        case 62:
            nextScorePerTap = BInt("506250000000000")!
            levelUpCost = BInt("3415880153270000717")!
            break
        case 63:
            nextScorePerTap = BInt("6328125000000000")!
            levelUpCost = BInt("61485842758872600017")!
            break
        case 64:
            nextScorePerTap = BInt("69492187500000000")!
            levelUpCost = BInt("720000000000000000000")!
            break
        case 65:
            nextScorePerTap = BInt("2135742187500000000")!
            levelUpCost = BInt("67000000000000000000000")!
            break
        case 66:
            nextScorePerTap = BInt("64072265625000000000")!
            levelUpCost = BInt("480000000000000000000000")!
            break
        case 67:
            nextScorePerTap = BInt("192216796875000000000")!
            levelUpCost = BInt("1200000000000000000000000")!
            break
        case 68:
            nextScorePerTap = BInt("961083984375000000000")!
            levelUpCost = BInt("34000000000000000000000000")!
            break
        case 69:
            nextScorePerTap = BInt("2883251953125000000000")!
            levelUpCost = BInt("560000000000000000000000000")!
            break
        case 70:
            nextScorePerTap = BInt("864975585937500000000000")!
            levelUpCost = BInt("7900000000000000000000000000")!
            break
        case 71:
            nextScorePerTap = BInt("2594926757812500000000000")!
            levelUpCost = BInt("9100000000000000000000000000")!
            break
        case 72:
            nextScorePerTap = BInt("32436584472656250000000000")!
            levelUpCost = BInt("65000000000000000000000000000")!
            break
        case 73:
            nextScorePerTap = BInt("424365844726562500000000000")!
            levelUpCost = BInt("780000000000000000000000000000")!
            break
        case 74:
            nextScorePerTap = BInt("7243658447265625000000000000")!
            levelUpCost = BInt("56000000000000000000000000000000")!
            break
        case 75:
            nextScorePerTap = BInt("112436584472656250000000000000")!
            levelUpCost = BInt("4900000000000000000000000000000000")!
            break
            
        default:
            nextScorePerTap = BInt("112436584472656250000000000000")!
            levelUpCost = BInt("4900000000000000000000000000000000")!
            break
        }
    }

}
