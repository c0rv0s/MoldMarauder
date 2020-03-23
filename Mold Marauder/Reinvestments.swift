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
    var backButton: SKNode!
    var reinvestButton: SKNode!
    var confirmReinvestButton: SKNode!
    
    
    let gameLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = CometLayer()
    
    //for loading buttons without blank space
    var lastButton : CGPoint!
    
    //scrollView
    var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    
    
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
        gameLayer.zPosition = 20
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
        
        if reinvestList > 0 {
            let reinvestLab0 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab0.fontSize = 20
            reinvestLab0.text = "Active Challenges:"
            reinvestLab0.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
            page1ScrollView.addChild(reinvestLab0)
            reinvestLab0.fontColor = UIColor.black
            lastButton = reinvestLab0.position
            
            let reinvestLab1 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab1.fontSize = 16
            reinvestLab1.text = "Double worms"
            reinvestLab1.position = CGPoint(x: lastButton.x, y: lastButton.y - 40)
            page1ScrollView.addChild(reinvestLab1)
            reinvestLab1.fontColor = UIColor.black
            lastButton = reinvestLab1.position
        }
        if reinvestList > 1 {
            let reinvestLab2 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab2.fontSize = 16
            reinvestLab2.text = "-50% Points/Second"
            reinvestLab2.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
            page1ScrollView.addChild(reinvestLab2)
            reinvestLab2.fontColor = UIColor.black
            lastButton = reinvestLab2.position
        }
        if reinvestList > 2 {
            let reinvestLab3 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab3.fontSize = 16
            reinvestLab3.text = "-50% Tap Value"
            reinvestLab3.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
            page1ScrollView.addChild(reinvestLab3)
            reinvestLab3.fontColor = UIColor.black
            lastButton = reinvestLab3.position
        }
        if reinvestList > 3 {
            let reinvestLab4 = SKLabelNode(fontNamed: "Lemondrop")
            reinvestLab4.fontSize = 16
            reinvestLab4.text = "Molds more vicious"
            reinvestLab4.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
            page1ScrollView.addChild(reinvestLab4)
            reinvestLab4.fontColor = UIColor.black
            lastButton = reinvestLab4.position
        }
        
//      "A tickle in the back of your mind tells you there could be something waiting for you after a few successful reinvestments..."
        let hintLabel1 = SKLabelNode(fontNamed: "Lemondrop")
        hintLabel1.fontSize = 12
        hintLabel1.text = "A tickle in the back of your"
        hintLabel1.position = CGPoint(x: lastButton.x, y: lastButton.y - 60)
        page1ScrollView.addChild(hintLabel1)
        hintLabel1.fontColor = UIColor.black
        lastButton = hintLabel1.position
        let hintLabel2 = SKLabelNode(fontNamed: "Lemondrop")
        hintLabel2.fontSize = 12
        hintLabel2.text = "mind tells you there could"
        hintLabel2.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(hintLabel2)
        hintLabel2.fontColor = UIColor.black
        lastButton = hintLabel2.position
        let hintLabel3 = SKLabelNode(fontNamed: "Lemondrop")
        hintLabel3.fontSize = 12
        hintLabel3.text = "be something waiting for you"
        hintLabel3.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(hintLabel3)
        hintLabel3.fontColor = UIColor.black
        lastButton = hintLabel3.position
        let hintLabel4 = SKLabelNode(fontNamed: "Lemondrop")
        hintLabel4.fontSize = 12
        hintLabel4.text = "after a few successful"
        hintLabel4.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(hintLabel4)
        hintLabel4.fontColor = UIColor.black
        lastButton = hintLabel4.position
        let hintLabel5 = SKLabelNode(fontNamed: "Lemondrop")
        hintLabel5.fontSize = 12
        hintLabel5.text = "reinvestments..."
        hintLabel5.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(hintLabel5)
        hintLabel5.fontColor = UIColor.black
        lastButton = hintLabel5.position
        
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
        else if confirmReinvestButton != nil {
            if confirmReinvestButton.contains(touchLocation) {
                print("confirm reinvest")
                if canReinvest {
                    if let handler = touchHandler {
                        handler("confirm reinvest")
                    }
                }
            }
            else {
                gameLayer.removeAllChildren()
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
        
//    button
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
}
