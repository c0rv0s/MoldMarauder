//
//  HelpScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 3/25/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class HelpScene: SKScene {
    var mute = false
    
    var backButton: SKNode!
    
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
        addChild(moveableNode)
        //set up the scrollView
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), moveableNode: moveableNode, direction: .vertical)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: CGFloat(2000)) // makes it 2 times the height
        view?.addSubview(scrollView!)
        
        // Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        let page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
        moveableNode.addChild(page1ScrollView)
        
        //EARN POINTS
        let label1 = SKLabelNode(fontNamed: "Lemondrop")
        label1.fontSize = 20
        label1.text = "How to Earn Points:"
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
        labelearn.text = "Tap the screen"
        labelearn.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelearn)
        labelearn.fontColor = UIColor.black
        lastButton = labelearn.position
        let labelearn2 = SKLabelNode(fontNamed: "Lemondrop")
        labelearn2.fontSize = 12
        labelearn2.text = "Your molds earn free points too."
        labelearn2.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(labelearn2)
        labelearn2.fontColor = UIColor.black
        lastButton = labelearn2.position
        
        //UNLOCK NEW SPECIES
        let label2 = SKLabelNode(fontNamed: "Lemondrop")
        label2.fontSize = 20
        label2.text = "Unlock New Species:"
        label2.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(label2)
        label2.fontColor = UIColor.black
        label2.fontColor = UIColor.black
        lastButton = label2.position
        let labelbreed = SKLabelNode(fontNamed: "Lemondrop")
        labelbreed.fontSize = 12
        labelbreed.text = "Select up to 5 molds then tap 'Breed'"
        labelbreed.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelbreed)
        labelbreed.fontColor = UIColor.black
        lastButton = labelbreed.position
        Texture = SKTexture(image: UIImage(named: "breed explain")!)
        let explain1 = SKSpriteNode(texture:Texture)
        // Place in scene
        explain1.position = CGPoint(x: lastButton.x, y: lastButton.y - 110)
        lastButton = explain1.position
        page1ScrollView.addChild(explain1)
        let labelbreed2 = SKLabelNode(fontNamed: "Lemondrop")
        labelbreed2.fontSize = 12
        labelbreed2.text = "Use diamonds to complete a match"
        labelbreed2.position = CGPoint(x: lastButton.x, y: lastButton.y - 125)
        page1ScrollView.addChild(labelbreed2)
        labelbreed2.fontColor = UIColor.black
        lastButton = labelbreed2.position
        Texture = SKTexture(image: UIImage(named: "breed explain 2")!)
        let explain2 = SKSpriteNode(texture:Texture)
        // Place in scene
        explain2.position = CGPoint(x: lastButton.x, y: lastButton.y - 50)
        lastButton = explain2.position
        page1ScrollView.addChild(explain2)
        
        //FIGHT WORMS
        let label3 = SKLabelNode(fontNamed: "Lemondrop")
        label3.fontSize = 20
        label3.text = "Fight Worms:"
        label3.position = CGPoint(x: lastButton.x, y: lastButton.y - 80)
        page1ScrollView.addChild(label3)
        label3.fontColor = UIColor.black
        label3.fontColor = UIColor.black
        lastButton = label3.position
        let labelkill = SKLabelNode(fontNamed: "Lemondrop")
        labelkill.fontSize = 12
        labelkill.text = "Tap worms to fire your laser"
        labelkill.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelkill)
        labelkill.fontColor = UIColor.black
        lastButton = labelkill.position
        
        //Fairies
        let labelf = SKLabelNode(fontNamed: "Lemondrop")
        labelf.fontSize = 20
        labelf.text = "Fairies:"
        labelf.position = CGPoint(x: lastButton.x, y: lastButton.y - 40)
        page1ScrollView.addChild(labelf)
        labelf.fontColor = UIColor.black
        labelf.fontColor = UIColor.black
        lastButton = labelf.position
        let labelf2 = SKLabelNode(fontNamed: "Lemondrop")
        labelf2.fontSize = 11
        labelf2.text = "Draw a circle around them to capture"
        labelf2.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelf2)
        labelf2.fontColor = UIColor.black
        lastButton = labelf2.position
        Texture = SKTexture(image: UIImage(named: "fairy explain")!)
        let explainf = SKSpriteNode(texture:Texture)
        // Place in scene
        explainf.position = CGPoint(x: lastButton.x, y: lastButton.y - 135)
        lastButton = explainf.position
        page1ScrollView.addChild(explainf)
        
        //MOLD SPRITZ
        let label4 = SKLabelNode(fontNamed: "Lemondrop")
        label4.fontSize = 20
        label4.text = "Mold Spritz:"
        label4.position = CGPoint(x: lastButton.x, y: lastButton.y - 155)
        page1ScrollView.addChild(label4)
        label4.fontColor = UIColor.black
        label4.fontColor = UIColor.black
        lastButton = label4.position
        let labelspritz = SKLabelNode(fontNamed: "Lemondrop")
        labelspritz.fontSize = 12
        labelspritz.text = "Spritzed molds earn at a multiplied rate"
        labelspritz.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelspritz)
        labelspritz.fontColor = UIColor.black
        lastButton = labelspritz.position
        let labelspritz2 = SKLabelNode(fontNamed: "Lemondrop")
        labelspritz2.fontSize = 12
        labelspritz2.text = "The yellow timer counts down until spritz ends"
        labelspritz2.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(labelspritz2)
        labelspritz2.fontColor = UIColor.black
        lastButton = labelspritz2.position
        Texture = SKTexture(image: UIImage(named: "spritz explain")!)
        let explain3 = SKSpriteNode(texture:Texture)
        // Place in scene
        explain3.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
        lastButton = explain3.position
        page1ScrollView.addChild(explain3)
        
        //ACHIEVMENTS
        let label5 = SKLabelNode(fontNamed: "Lemondrop")
        label5.fontSize = 20
        label5.text = "Achievements:"
        label5.position = CGPoint(x: lastButton.x, y: lastButton.y - 120)
        page1ScrollView.addChild(label5)
        label5.fontColor = UIColor.black
        label5.fontColor = UIColor.black
        lastButton = label5.position
        let labelachieve = SKLabelNode(fontNamed: "Lemondrop")
        labelachieve.fontSize = 12
        labelachieve.text = "Fulfilling ahcievements earns free diamonds"
        labelachieve.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelachieve)
        labelachieve.fontColor = UIColor.black
        lastButton = labelachieve.position
        Texture = SKTexture(image: UIImage(named: "achieve explain")!)
        let explain4 = SKSpriteNode(texture:Texture)
        // Place in scene
        explain4.position = CGPoint(x: lastButton.x, y: lastButton.y - 80)
        lastButton = explain4.position
        page1ScrollView.addChild(explain4)
        
        //QUESTS
        let label6 = SKLabelNode(fontNamed: "Lemondrop")
        label6.fontSize = 20
        label6.text = "Quests:"
        label6.position = CGPoint(x: lastButton.x, y: lastButton.y - 100)
        page1ScrollView.addChild(label6)
        label6.fontColor = UIColor.black
        label6.fontColor = UIColor.black
        lastButton = label6.position
        let labelquest = SKLabelNode(fontNamed: "Lemondrop")
        labelquest.fontSize = 12
        labelquest.text = "Completing quests earns various rewards"
        labelquest.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(labelquest)
        labelquest.fontColor = UIColor.black
        lastButton = labelquest.position
        Texture = SKTexture(image: UIImage(named: "quest explain")!)
        let explain5 = SKSpriteNode(texture:Texture)
        // Place in scene
        explain5.position = CGPoint(x: lastButton.x, y: lastButton.y - 135)
        lastButton = explain5.position
        page1ScrollView.addChild(explain5)

        

        //NUMBER SUFFIXES
        let label7 = SKLabelNode(fontNamed: "Lemondrop")
        label7.fontSize = 20
        label7.text = "Number Suffixes:"
        label7.position = CGPoint(x: lastButton.x, y: lastButton.y - 150)
        page1ScrollView.addChild(label7)
        label7.fontColor = UIColor.black
        label7.fontColor = UIColor.black
        lastButton = label7.position
        
        //Numbers
        let label8 = SKLabelNode(fontNamed: "Lemondrop")
        label8.fontSize = 12
        label8.text = "Thousand: K"
        label8.position = CGPoint(x: lastButton.x, y: lastButton.y - 30)
        page1ScrollView.addChild(label8)
        label8.fontColor = UIColor.black
        label8.fontColor = UIColor.black
        lastButton = label8.position
        let label9 = SKLabelNode(fontNamed: "Lemondrop")
        label9.fontSize = 12
        label9.text = "Million: M"
        label9.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label9)
        label9.fontColor = UIColor.black
        label9.fontColor = UIColor.black
        lastButton = label9.position
        let label10 = SKLabelNode(fontNamed: "Lemondrop")
        label10.fontSize = 12
        label10.text = "Billion: B"
        label10.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label10)
        label10.fontColor = UIColor.black
        label10.fontColor = UIColor.black
        lastButton = label10.position
        let label11 = SKLabelNode(fontNamed: "Lemondrop")
        label11.fontSize = 12
        label11.text = "Trillion: T"
        label11.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label11)
        label11.fontColor = UIColor.black
        label11.fontColor = UIColor.black
        lastButton = label11.position
        let label12 = SKLabelNode(fontNamed: "Lemondrop")
        label12.fontSize = 12
        label12.text = "Quadrillion: Q"
        label12.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label12)
        label12.fontColor = UIColor.black
        label12.fontColor = UIColor.black
        lastButton = label12.position
        let label13 = SKLabelNode(fontNamed: "Lemondrop")
        label13.fontSize = 12
        label13.text = "Quintillion: Qi"
        label13.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label13)
        label13.fontColor = UIColor.black
        label13.fontColor = UIColor.black
        lastButton = label13.position
        let label14 = SKLabelNode(fontNamed: "Lemondrop")
        label14.fontSize = 12
        label14.text = "Sextillion: Se"
        label14.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label14)
        label14.fontColor = UIColor.black
        label14.fontColor = UIColor.black
        lastButton = label14.position
        let label15 = SKLabelNode(fontNamed: "Lemondrop")
        label15.fontSize = 12
        label15.text = "Septillion: Sp"
        label15.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label15)
        label15.fontColor = UIColor.black
        label15.fontColor = UIColor.black
        lastButton = label15.position
        let label16 = SKLabelNode(fontNamed: "Lemondrop")
        label16.fontSize = 12
        label16.text = "Octillion: Oc"
        label16.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label16)
        label16.fontColor = UIColor.black
        label16.fontColor = UIColor.black
        lastButton = label16.position
        let label17 = SKLabelNode(fontNamed: "Lemondrop")
        label17.fontSize = 12
        label17.text = "Nonillion: No"
        label17.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label17)
        label17.fontColor = UIColor.black
        label17.fontColor = UIColor.black
        lastButton = label17.position
        let label18 = SKLabelNode(fontNamed: "Lemondrop")
        label18.fontSize = 12
        label18.text = "Decillion: D"
        label18.position = CGPoint(x: lastButton.x, y: lastButton.y - 14)
        page1ScrollView.addChild(label18)
        label18.fontColor = UIColor.black
        label18.fontColor = UIColor.black
        lastButton = label18.position
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            labelachieve.setScale(0.8)
            labelquest.setScale(0.8)
            labelbreed.setScale(0.8)
            labelbreed2.setScale(0.8)
            labelspritz.setScale(0.8)
            labelspritz2.setScale(0.8)
            break
        case .iPhone5:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            labelachieve.setScale(0.8)
            labelquest.setScale(0.8)
            labelbreed.setScale(0.8)
            labelbreed2.setScale(0.8)
            labelspritz.setScale(0.8)
            labelspritz2.setScale(0.8)
            break
        default:
            break
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
