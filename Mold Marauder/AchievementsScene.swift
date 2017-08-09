//
//  AchievementsScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/23/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class AchievementsScene: SKScene {
    var mute = false
    
    var backButton: SKNode! = nil
    
    //achievements progress
    var wormsKilled: Int!
    var wormLabel: SKLabelNode! = nil
    var moldsOwned: Int!
    var ownedLabel: SKLabelNode! = nil
    var speciesBred: Int!
    var bredLabel: SKLabelNode! = nil
    var incLevel: Int!
    var incLabel: SKLabelNode! = nil
    var laserLevel: Int!
    var laserLabel: SKLabelNode! = nil
    var deathRay = false
    var level: Int!
    var levelLabel: SKLabelNode! = nil
    var cash: BInt!
    var cashLabel: SKLabelNode! = nil
    
    var  rewardAmount = 0
    var claimButton: SKNode! = nil
    
    let gameLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = SKNode()
    
    var animLayer = SKNode()
    var barLayer = SKNode()
    var labelLayer = SKNode()
    
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
    let achieveSound = SKAction.playSoundFileNamed("achieve.wav", waitForCompletion: false)
    let selectSound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
    
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
        //barLayer.zPosition = -200
        addChild(barLayer)
        labelLayer.zPosition = 200
        addChild(labelLayer)
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
        
        //set up progress bars
        //LEVEL
        levelLabel = SKLabelNode(fontNamed: "Lemondrop")
        levelLabel.fontSize = 18
        levelLabel.fontColor = UIColor.black
        if nextLevel() > 0 {
            levelLabel.text = "\(level!)/\(nextLevel()) levels"
        }
        else {
            levelLabel.text = "Complete!"
        }
        levelLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+143);
        labelLayer.addChild(levelLabel)
        let levelBar = ProgressBar(color: SKColor.green, size:CGSize(width:250, height:25))
        var goal = Double(level) / Double(nextLevel())
        levelBar.progress = CGFloat(goal)
        levelBar.position = CGPoint(x:self.frame.midX, y:self.frame.midY+150);
        barLayer.addChild(levelBar)
        
        //WORMS KILLED
        wormLabel = SKLabelNode(fontNamed: "Lemondrop")
        wormLabel.fontSize = 18
        wormLabel.fontColor = UIColor.black
        if nextWorm() > 0 {
            wormLabel.text = "\(wormsKilled!)/\(nextWorm()) worms killed"
        }
        else {
            wormLabel.text = "Complete!"
        }
        wormLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+103);
        labelLayer.addChild(wormLabel)

        let wormBar = ProgressBar(color: SKColor.green, size:CGSize(width:250, height:25))
        goal = Double(wormsKilled) / Double(nextWorm())
        wormBar.progress = CGFloat(goal)
        wormBar.position = CGPoint(x:self.frame.midX, y:self.frame.midY+110);
        barLayer.addChild(wormBar)
        
        //MOLDS OWNED
        ownedLabel = SKLabelNode(fontNamed: "Lemondrop")
        ownedLabel.fontSize = 18
        ownedLabel.fontColor = UIColor.black
        if nextOwned() > 0 {
            ownedLabel.text = "\(moldsOwned!)/\(nextOwned()) molds owned"
        }
        else {
            ownedLabel.text = "Complete!"
        }
        ownedLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+63);
        labelLayer.addChild(ownedLabel)
        let ownedBar = ProgressBar(color: SKColor.green, size:CGSize(width:250, height:25))
        goal = Double(moldsOwned) / Double(nextOwned())
        ownedBar.progress = CGFloat(goal)
        ownedBar.position = CGPoint(x:self.frame.midX, y:self.frame.midY+70);
        barLayer.addChild(ownedBar)
        
        
        //MOLDS BRED
        bredLabel = SKLabelNode(fontNamed: "Lemondrop")
        bredLabel.fontSize = 18
        bredLabel.fontColor = UIColor.black
        if nextBred() > 0 {
            bredLabel.text = "\(speciesBred!)/\(nextBred()) molds bred"
        }
        else {
            bredLabel.text = "Complete!"
        }
        bredLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY+23);
        labelLayer.addChild(bredLabel)
        let bredBar = ProgressBar(color: SKColor.green, size:CGSize(width:250, height:25))
        goal = Double(speciesBred) / Double(nextBred())
        bredBar.progress = CGFloat(goal)
        bredBar.position = CGPoint(x:self.frame.midX, y:self.frame.midY+30);
        barLayer.addChild(bredBar)
        
        
        //INCUBATOR LEVEL
        incLabel = SKLabelNode(fontNamed: "Lemondrop")
        incLabel.fontSize = 18
        incLabel.fontColor = UIColor.black
        if incLevel < 6 {
            incLabel.text = "\(incLevel!)/6 incubator level"
        }
        else {
            incLabel.text = "Complete!"
        }
        incLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 17);
        labelLayer.addChild(incLabel)
        let incBar = ProgressBar(color: SKColor.green, size:CGSize(width:250, height:25))
        goal = Double(Double(incLevel)/6.0)
        incBar.progress = CGFloat(goal)
        incBar.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 10);
        barLayer.addChild(incBar)
        
        
        //LASER LEVLE
        laserLabel = SKLabelNode(fontNamed: "Lemondrop")
        laserLabel.fontSize = 18
        laserLabel.fontColor = UIColor.black
        if laserLevel < 3 {
            laserLabel.text = "\(laserLevel!)/3 laser level"
        }
        else if laserLevel == 3 && deathRay == false {
            laserLabel.fontSize = 14
            laserLabel.text = "BONUS: Acquire the Death Ray"
        }
        else if laserLevel == 3 && deathRay == true {
            laserLabel.text = "Complete!"
        }
        laserLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY-57)
        labelLayer.addChild(laserLabel)

        let laserBar = ProgressBar(color: SKColor.green, size:CGSize(width:250, height:25))
        goal = 1.0
        if laserLevel < 3 {
            goal = Double(Double(laserLevel)/3.0)
        }
        else if laserLevel == 3 && deathRay == false {
            goal = 0.0
        }
        laserBar.progress = CGFloat(goal)
        laserBar.position = CGPoint(x:self.frame.midX, y:self.frame.midY-50)
        barLayer.addChild(laserBar)
        
        //CASH
        cashLabel = SKLabelNode(fontNamed: "Lemondrop")
        cashLabel.fontSize = 18
        cashLabel.fontColor = UIColor.black
        if cash < BInt("1000000000000000000000000000000000") {
            cashLabel.text = "\(formatNumber(points: cash!))/1.0 D cash"
        }
        else {
            cashLabel.text = "Complete!"
        }
        cashLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 97);
        labelLayer.addChild(cashLabel)
        
        
        //CLAIM REWARD BUTTON
        Texture = SKTexture(image: UIImage(named: "claim reward grey")!)
        if rewardAmount > 0 {
            Texture = SKTexture(image: UIImage(named: "claim reward")!)
        }
        claimButton = SKSpriteNode(texture:Texture)
        claimButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY-200)
        self.addChild(claimButton)
        
        self.addChild(animLayer)
        
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
    
    func nextWorm() -> Int {
        if wormsKilled < 20 {
            return 20
        }
        else if wormsKilled < 100 {
            return 100
        }
        else if wormsKilled < 500 {
            return 500
        }
        else if wormsKilled < 5000 {
            return 5000
        }
        else if wormsKilled < 10000 {
            return 10000
        }
        return -5
    }
    
    func nextOwned() -> Int {
        if moldsOwned < 5 {
            return 5
        }
        else if moldsOwned < 25 {
            return 25
        }
        else if moldsOwned < 100 {
            return 100
        }
        else if moldsOwned < 250 {
            return 250
        }
        else if moldsOwned < 1000 {
            return 1000
        }
        return -5
    }
    
    func nextBred() -> Int {
        if speciesBred < 5 {
            return 5
        }
        else if speciesBred < 15 {
            return 15
        }
        else if speciesBred < 25 {
            return 25
        }
        else if speciesBred < 42 {
            return 42
        }
        return -5
    }
    func nextLevel() -> Int {
        if level < 10 {
            return 10
        }
        else if level < 20 {
            return 20
        }
        else if level < 30 {
            return 30
        }
        else if level < 40 {
            return 40
        }
        else if level < 50 {
            return 50
        }
        else if level < 60 {
            return 60
        }
        else if level < 70 {
            return 70
        }
        else if level < 75 {
            return 75
        }
        return -5
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
        if claimButton != nil {
            if claimButton.contains(touchLocation) {
                print("claim")
                if rewardAmount > 0 {
                    //animate dimmond
                    let Texture = SKTexture(image: UIImage(named: "diamond_glow")!)
                    let animDiamond = SKSpriteNode(texture:Texture)
                    animDiamond.position = CGPoint(x:self.frame.midX + 18, y:self.frame.midY-100)
                    animLayer.addChild(animDiamond)
                    let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                    moveAction.timingMode = .easeOut
                    animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                    
                    //animate diamond amount
                    let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
                    scoreLabel.fontSize = 16
                    scoreLabel.text = "+" + String(rewardAmount)
                    scoreLabel.position = CGPoint(x:self.frame.midX - 18, y:self.frame.midY-108)
                    scoreLabel.fontColor = UIColor.black
                    animLayer.addChild(scoreLabel)
                    let moveAction2 = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                    moveAction2.timingMode = .easeOut
                    scoreLabel.run(SKAction.sequence([moveAction2, SKAction.removeFromParent()]))
                    
                    if let handler = touchHandler {
                        handler("claim")
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
        case "achieve":
            run(achieveSound)
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


    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
}
