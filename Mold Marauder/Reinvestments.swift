//
//  Reinvestments.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 7/8/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class Reinvestments: SKScene {
    var mute = false
    var canReinvest = false
    var reinvestList = 0
    var backButton: SKNode! = nil
    var reinvestButton: SKNode! = nil
    var confirmReinvestButton: SKNode! = nil
    
    
    let gameLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = SKNode()
    var cometTimer: Timer!
    
    //for loading buttons without blank space
    var lastButton : CGPoint!
    
    //scrollView
    weak var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    
    
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
    let exitSound = SKAction.playSoundFileNamed("exit.wav", waitForCompletion: false)
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
        gameLayer.zPosition = 20
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
        
        //addNode
        moveableNode.zPosition = 10
        addChild(moveableNode)
        //set up the scrollView
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), moveableNode: moveableNode, direction: .vertical)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: scrollView!.frame.height) // makes it 2 times the height
        view?.addSubview(scrollView!)
        
        // Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        let page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
        moveableNode.addChild(page1ScrollView)
        
        //EARN POINTS
        let label1 = SKLabelNode(fontNamed: "Lemondrop")
        label1.fontSize = 20
        label1.text = "Reinvest"
        label1.position = CGPoint(x: frame.midX, y: 180)
        
        switch UIDevice().screenType {
        case .iPhone4:
            label1.position = CGPoint(x: frame.midX, y: 140)
            break
        case .iPhone5:
            label1.position = CGPoint(x: frame.midX, y: 150)
            break
        default:
            break
        }
        page1ScrollView.addChild(label1)
        label1.fontColor = UIColor.black
        label1.fontColor = UIColor.black
        lastButton = label1.position
        let labelearn = SKLabelNode(fontNamed: "Lemondrop")
        labelearn.fontSize = 12
        labelearn.text = "Reset the game with"
        labelearn.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelearn)
        labelearn.fontColor = UIColor.black
        lastButton = labelearn.position
        let labelearn2 = SKLabelNode(fontNamed: "Lemondrop")
        labelearn2.fontSize = 12
        labelearn2.text = "extra challenges."
        labelearn2.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(labelearn2)
        labelearn2.fontColor = UIColor.black
        lastButton = labelearn2.position
        
        if canReinvest {
            Texture = SKTexture(image: UIImage(named: "reinvest button 2")!)
        }
        else {
            Texture = SKTexture(image: UIImage(named: "reinvest button 2 grey")!)
            let labelearn3 = SKLabelNode(fontNamed: "Lemondrop")
            labelearn3.fontSize = 12
            labelearn3.text = "(Unlock all molds first)"
            labelearn3.position = CGPoint(x: lastButton.x, y: lastButton.y - 100)
            page1ScrollView.addChild(labelearn3)
            labelearn3.fontColor = UIColor.black
        }
        
        reinvestButton = SKSpriteNode(texture:Texture)
        // Place in scene
        reinvestButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 50)
        page1ScrollView.addChild(reinvestButton)
        lastButton = reinvestButton.position

        print("checkin the count")
        print(reinvestList)
        if reinvestList > 0 {
            let reinvestLab1 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab1.fontSize = 20
            reinvestLab1.text = "Double worms"
            reinvestLab1.position = CGPoint(x: lastButton.x, y: lastButton.y - 80)
            page1ScrollView.addChild(reinvestLab1)
            reinvestLab1.fontColor = UIColor.black
            lastButton = reinvestLab1.position
        }
        if reinvestList > 1 {
            let reinvestLab2 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab2.fontSize = 20
            reinvestLab2.text = "-50% PPS"
            reinvestLab2.position = CGPoint(x: lastButton.x, y: lastButton.y - 50)
            page1ScrollView.addChild(reinvestLab2)
            reinvestLab2.fontColor = UIColor.black
            lastButton = reinvestLab2.position
        }
        if reinvestList > 2 {
            let reinvestLab3 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab3.fontSize = 20
            reinvestLab3.text = "-50% Tap Value"
            reinvestLab3.position = CGPoint(x: lastButton.x, y: lastButton.y - 50)
            page1ScrollView.addChild(reinvestLab3)
            reinvestLab3.fontColor = UIColor.black
            lastButton = reinvestLab3.position
        }
        if reinvestList > 3 {
            let reinvestLab4 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab4.fontSize = 20
            reinvestLab4.text = "Molds more vicious"
            reinvestLab4.position = CGPoint(x: lastButton.x, y: lastButton.y - 50)
            page1ScrollView.addChild(reinvestLab4)
            reinvestLab4.fontColor = UIColor.black
            lastButton = reinvestLab4.position
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
        if reinvestButton.contains(touchLocation) {
            print("reinvest")
            if canReinvest {
                if let handler = touchHandler {
                    handler("reinvest")
                }
            }
        }
        if confirmReinvestButton != nil {
            if confirmReinvestButton.contains(touchLocation) {
                print("confirm reinvest")
                if canReinvest {
                    if let handler = touchHandler {
                        handler("confirm reinvest")
                    }
                }
            }
        }
    }
    
    //MARK: - ANIMATIONS
    func confirmReinvest() {
        // grey
        var Texture = SKTexture(image: UIImage(named: "grey out")!)
        let greyOut = SKSpriteNode(texture:Texture)
        // Place in scene
        greyOut.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        gameLayer.addChild(greyOut)
        
        //popup
        Texture = SKTexture(image: UIImage(named: "reinvest message")!)
        let popup = SKSpriteNode(texture:Texture)
        // Place in scene
        popup.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        gameLayer.addChild(popup)
        
//        button
        Texture = SKTexture(image: UIImage(named: "reinvest button 2")!)
        confirmReinvestButton = SKSpriteNode(texture:Texture)
        confirmReinvestButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        gameLayer.addChild(confirmReinvestButton)
        
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
