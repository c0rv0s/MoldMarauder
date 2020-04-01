//
//  Mold Inventory.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 3/1/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class MoldInventory: SKScene {
    var mute = false
    
    //molds to combine
    var slimeButton: SKNode!
    var slimePlus: SKNode!
    var slimeMinus: SKNode!
    var slimeLabel: SKLabelNode!
    var caveButton: SKNode!
    var cavePlus: SKNode!
    var caveMinus: SKNode!
    var caveLabel: SKLabelNode!
    var sadButton: SKNode!
    var sadPlus: SKNode!
    var sadMinus: SKNode!
    var sadLabel: SKLabelNode!
    var angryButton: SKNode!
    var angryPlus: SKNode!
    var angryMinus: SKNode!
    var angryLabel: SKLabelNode!
    var alienButton: SKNode!
    var alienPlus: SKNode!
    var alienMinus: SKNode!
    var alienLabel: SKLabelNode!
    var pimplyButton: SKNode!
    var pimplyPlus: SKNode!
    var pimplyMinus: SKNode!
    var pimplyLabel: SKLabelNode!
    var freckledButton: SKNode!
    var freckledPlus: SKNode!
    var freckledMinus: SKNode!
    var freckledLabel: SKLabelNode!
    var hypnoButton: SKNode!
    var hypnoPlus: SKNode!
    var hypnoMinus: SKNode!
    var hypnoLabel: SKLabelNode!
    var rainbowButton: SKNode!
    var rainbowPlus: SKNode!
    var rainbowMinus: SKNode!
    var rainbowLabel: SKLabelNode!
    var aluminumButton: SKNode!
    var aluminumPlus: SKNode!
    var aluminumMinus: SKNode!
    var aluminumLabel: SKLabelNode!
    var circuitButton: SKNode!
    var circuitPlus: SKNode!
    var circuitMinus: SKNode!
    var circuitLabel: SKLabelNode!
    var hologramButton: SKNode!
    var hologramPlus: SKNode!
    var hologramMinus: SKNode!
    var hologramLabel: SKLabelNode!
    var stormButton: SKNode!
    var stormPlus: SKNode!
    var stormMinus: SKNode!
    var stormLabel: SKLabelNode!
    var bacteriaButton: SKNode!
    var bacteriaPlus: SKNode!
    var bacteriaMinus: SKNode!
    var bacteriaLabel: SKLabelNode!
    var virusButton: SKNode!
    var virusPlus: SKNode!
    var virusMinus: SKNode!
    var virusLabel: SKLabelNode!
    var flowerButton: SKNode!
    var flowerPlus: SKNode!
    var flowerMinus: SKNode!
    var flowerLabel: SKLabelNode!
    var beeButton: SKNode!
    var beePlus: SKNode!
    var beeMinus: SKNode!
    var beeLabel: SKLabelNode!
    var xButton: SKNode!
    var xPlus: SKNode!
    var xMinus: SKNode!
    var xLabel: SKLabelNode!
    var disaffectedButton: SKNode!
    var disaffectedPlus: SKNode!
    var disaffectedMinus: SKNode!
    var disaffectedLabel: SKLabelNode!
    var oliveButton: SKNode!
    var olivePlus: SKNode!
    var oliveMinus: SKNode!
    var oliveLabel: SKLabelNode!
    var coconutButton: SKNode!
    var coconutPlus: SKNode!
    var coconutMinus: SKNode!
    var coconutLabel: SKLabelNode!
    var sickButton: SKNode!
    var sickPlus: SKNode!
    var sickMinus: SKNode!
    var sickLabel: SKLabelNode!
    var deadButton: SKNode!
    var deadPlus: SKNode!
    var deadMinus: SKNode!
    var deadLabel: SKLabelNode!
    var zombieButton: SKNode!
    var zombiePlus: SKNode!
    var zombieMinus: SKNode!
    var zombieLabel: SKLabelNode!
    var rockButton: SKNode!
    var rockPlus: SKNode!
    var rockMinus: SKNode!
    var rockLabel: SKLabelNode!
    var cloudButton: SKNode!
    var cloudPlus: SKNode!
    var cloudMinus: SKNode!
    var cloudLabel: SKLabelNode!
    var waterButton: SKNode!
    var waterPlus: SKNode!
    var waterMinus: SKNode!
    var waterLabel: SKLabelNode!
    var crystalButton: SKNode!
    var crystalPlus: SKNode!
    var crystalMinus: SKNode!
    var crystalLabel: SKLabelNode!
    var nuclearButton: SKNode!
    var nuclearPlus: SKNode!
    var nuclearMinus: SKNode!
    var nuclearLabel: SKLabelNode!
    var astronautButton: SKNode!
    var astronautPlus: SKNode!
    var astronautMinus: SKNode!
    var astronautLabel: SKLabelNode!
    var sandButton: SKNode!
    var sandPlus: SKNode!
    var sandMinus: SKNode!
    var sandLabel: SKLabelNode!
    var glassButton: SKNode!
    var glassPlus: SKNode!
    var glassMinus: SKNode!
    var glassLabel: SKLabelNode!
    var coffeeButton: SKNode!
    var coffeePlus: SKNode!
    var coffeeMinus: SKNode!
    var coffeeLabel: SKLabelNode!
    var slinkyButton: SKNode!
    var slinkyPlus: SKNode!
    var slinkyMinus: SKNode!
    var slinkyLabel: SKLabelNode!
    var magmaButton: SKNode!
    var magmaPlus: SKNode!
    var magmaMinus: SKNode!
    var magmaLabel: SKLabelNode!
    var samuraiButton: SKNode!
    var samuraiPlus: SKNode!
    var samuraiMinus: SKNode!
    var samuraiLabel: SKLabelNode!
    var orangeButton: SKNode!
    var orangePlus: SKNode!
    var orangeMinus: SKNode!
    var orangeLabel: SKLabelNode!
    var strawberryButton: SKNode!
    var strawberryPlus: SKNode!
    var strawberryMinus: SKNode!
    var strawberryLabel: SKLabelNode!
    var tshirtButton: SKNode!
    var tshirtPlus: SKNode!
    var tshirtMinus: SKNode!
    var tshirtLabel: SKLabelNode!
    var cryptidButton: SKNode!
    var cryptidPlus: SKNode!
    var cryptidMinus: SKNode!
    var cryptidLabel: SKLabelNode!
    var angelButton: SKNode!
    var angelPlus: SKNode!
    var angelMinus: SKNode!
    var angelLabel: SKLabelNode!
    var invisibleButton: SKNode!
    var invisiblePlus: SKNode!
    var invisibleMinus: SKNode!
    var invisibleLabel: SKLabelNode!
    var starButton: SKNode!
    var starPlus: SKNode!
    var starMinus: SKNode!
    var starLabel: SKLabelNode!
    var metaButton: SKNode!
    var metaPlus: SKNode!
    var metaMinus: SKNode!
    var metaLabel: SKLabelNode!
    var godButton: SKNode!
    var godPlus: SKNode!
    var godMinus: SKNode!
    var godLabel: SKLabelNode!
    
    var totalLabel: SKLabelNode!
    var totalNum = 0
    
    var moldCountDicc: [String:Int]!
    var displayCountDicc: [String:Int]!
    
    //other things
    var backButton: SKNode!
    var clearButton: SKNode!
    
    var touchHandler: ((String) -> ())?
    
    var unlockedMolds: Array<Mold> = []
    var ownedMolds: Array<Mold> = []
    var display: Array<Mold>!
    
    //to store last button postion to order buttons without blank space
    var lastButton : CGPoint!
    
    let gameLayer = SKNode()
    var cometLayer = CometLayer()
    
    var center:  CGPoint!
    //scrollView
    var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    
    //for background animations
    var background = Background()
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.start(size: size)
        addChild(background.background)
        addChild(cometLayer)
        let _ = SKLabelNode(fontNamed: "Lemondrop")
        center = CGPoint(x:self.frame.midX, y:self.frame.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        cometLayer.start(menu: false)
        
        createButton()
        erectScroll()
    }
    
    func erectScroll() {
        var height = 150 + (ownedMolds.count * 100)
        if ownedMolds.contains(where: {$0.name == MoldType.god.spriteName}) {
            height += 125
        }
        if ownedMolds.contains(where: {$0.name == MoldType.flower.spriteName}) {
            height += 75
        }
        if ownedMolds.contains(where: {$0.name == MoldType.star.spriteName}) {
            height += 110
        }
        //addNode
        addChild(moveableNode)
        //set up the scrollView
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), moveableNode: moveableNode, direction: .vertical)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: CGFloat(height))
        view?.addSubview(scrollView!)
        
        // Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        let page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
        moveableNode.addChild(page1ScrollView)
        
        //initialize these values, they get updated to be reused for each new button added
        var Texture = SKTexture(image: UIImage(named: "Slime Mold")!)
        lastButton = CGPoint(x: -75, y: 260)
        switch UIDevice().screenType {
        case .iPhone4:
            lastButton = CGPoint(x: -75, y: 210)
            break
        case .iPhone5:
            lastButton = CGPoint(x: -100, y: 240)
            break
        default:
            break
        }
        
        let inLabel = SKLabelNode(fontNamed: "Lemondrop")
        inLabel.fontSize = 15
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            inLabel.fontSize = 11
            break
        case .iPhone5:
            //iPhone 5
            inLabel.fontSize = 12
            break
        default:
            break
        }
        inLabel.fontColor = UIColor.black
        inLabel.text = "Select up to 25 molds for display"
        inLabel.position = CGPoint(x: lastButton.x + 75, y: lastButton.y - 50)
        page1ScrollView.addChild(inLabel)
        
        //add each mold to the scene exactly one time
        for mold in ownedMolds {
            if mold.moldType == MoldType.slime {
                Texture = SKTexture(image: UIImage(named: "Slime Mold")!)
                // slime
                slimeButton = SKSpriteNode(texture:Texture)
                // Place in scene
                slimeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = slimeButton.position
                page1ScrollView.addChild(slimeButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                slimePlus = SKSpriteNode(texture:Texture)
                slimePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(slimePlus)
                
                slimeLabel = SKLabelNode(fontNamed: "Lemondrop")
                slimeLabel.fontSize = 20
                slimeLabel.fontColor = UIColor.black
                slimeLabel.text = String(numOfMold(mold: MoldType.slime))
                slimeLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(slimeLabel)

                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                slimeMinus = SKSpriteNode(texture:Texture)
                slimeMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(slimeMinus)
            }
            if mold.moldType == MoldType.cave {
                // cave
                Texture = SKTexture(image: UIImage(named: "Cave Mold")!)
                caveButton = SKSpriteNode(texture:Texture)
                // Place in scene
                caveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = caveButton.position
                page1ScrollView.addChild(caveButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                cavePlus = SKSpriteNode(texture:Texture)
                cavePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(cavePlus)
                
                caveLabel = SKLabelNode(fontNamed: "Lemondrop")
                caveLabel.fontSize = 20
                caveLabel.fontColor = UIColor.black
                caveLabel.text = String(numOfMold(mold: MoldType.cave))
                caveLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(caveLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                caveMinus = SKSpriteNode(texture:Texture)
                caveMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(caveMinus)
            }
            
            if mold.moldType == MoldType.sad {
                // sad
                Texture = SKTexture(image: UIImage(named: "Sad Mold")!)
                sadButton = SKSpriteNode(texture:Texture)
                // Place in scene
                sadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = sadButton.position
                page1ScrollView.addChild(sadButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                sadPlus = SKSpriteNode(texture:Texture)
                sadPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(sadPlus)
                
                sadLabel = SKLabelNode(fontNamed: "Lemondrop")
                sadLabel.fontSize = 20
                sadLabel.fontColor = UIColor.black
                sadLabel.text = String(numOfMold(mold: MoldType.sad))
                sadLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(sadLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                sadMinus = SKSpriteNode(texture:Texture)
                sadMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(sadMinus)
            }
            
            if mold.moldType == MoldType.angry {
                //angry
                Texture = SKTexture(image: UIImage(named: "Angry Mold")!)
                angryButton = SKSpriteNode(texture:Texture)
                // Place in scene
                angryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = angryButton.position
                page1ScrollView.addChild(angryButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                angryPlus = SKSpriteNode(texture:Texture)
                angryPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(angryPlus)
                
                angryLabel = SKLabelNode(fontNamed: "Lemondrop")
                angryLabel.fontSize = 20
                angryLabel.fontColor = UIColor.black
                angryLabel.text = String(numOfMold(mold: MoldType.angry))
                angryLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(angryLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                angryMinus = SKSpriteNode(texture:Texture)
                angryMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(angryMinus)
            }
            
            if mold.moldType == MoldType.alien {
                //alien
                Texture = SKTexture(image: UIImage(named: "Alien Mold")!)
                alienButton = SKSpriteNode(texture:Texture)
                // Place in scene
                alienButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = alienButton.position
                page1ScrollView.addChild(alienButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                alienPlus = SKSpriteNode(texture:Texture)
                alienPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(alienPlus)
                
                alienLabel = SKLabelNode(fontNamed: "Lemondrop")
                alienLabel.fontSize = 20
                alienLabel.fontColor = UIColor.black
                alienLabel.text = String(numOfMold(mold: MoldType.alien))
                alienLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(alienLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                alienMinus = SKSpriteNode(texture:Texture)
                alienMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(alienMinus)
            }
            if mold.moldType == MoldType.freckled {
                //freckled
                Texture = SKTexture(image: UIImage(named: "Freckled Mold")!)
                freckledButton = SKSpriteNode(texture:Texture)
                // Place in scene
                freckledButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = freckledButton.position
                page1ScrollView.addChild(freckledButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                freckledPlus = SKSpriteNode(texture:Texture)
                freckledPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(freckledPlus)
                
                freckledLabel = SKLabelNode(fontNamed: "Lemondrop")
                freckledLabel.fontSize = 20
                freckledLabel.fontColor = UIColor.black
                freckledLabel.text = String(numOfMold(mold: MoldType.freckled))
                freckledLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(freckledLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                freckledMinus = SKSpriteNode(texture:Texture)
                freckledMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(freckledMinus)
            }
            if mold.moldType == MoldType.hypno {
                Texture = SKTexture(image: UIImage(named: "Hypno Mold")!)
                hypnoButton = SKSpriteNode(texture:Texture)
                // Place in scene
                hypnoButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = hypnoButton.position
                page1ScrollView.addChild(hypnoButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                hypnoPlus = SKSpriteNode(texture:Texture)
                hypnoPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(hypnoPlus)
                
                hypnoLabel = SKLabelNode(fontNamed: "Lemondrop")
                hypnoLabel.fontSize = 20
                hypnoLabel.fontColor = UIColor.black
                hypnoLabel.text = String(numOfMold(mold: MoldType.hypno))
                hypnoLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(hypnoLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                hypnoMinus = SKSpriteNode(texture:Texture)
                hypnoMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(hypnoMinus)
            }
            if mold.moldType == MoldType.pimply {
                Texture = SKTexture(image: UIImage(named: "Pimply Mold")!)
                pimplyButton = SKSpriteNode(texture:Texture)
                // Place in scene
                pimplyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = pimplyButton.position
                page1ScrollView.addChild(pimplyButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                pimplyPlus = SKSpriteNode(texture:Texture)
                pimplyPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(pimplyPlus)
                
                pimplyLabel = SKLabelNode(fontNamed: "Lemondrop")
                pimplyLabel.fontSize = 20
                pimplyLabel.fontColor = UIColor.black
                pimplyLabel.text = String(numOfMold(mold: MoldType.pimply))
                pimplyLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(pimplyLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                pimplyMinus = SKSpriteNode(texture:Texture)
                pimplyMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(pimplyMinus)
            }
            if mold.moldType == MoldType.rainbow {
                Texture = SKTexture(image: UIImage(named: "Rainbow Mold")!)
                rainbowButton = SKSpriteNode(texture:Texture)
                // Place in scene
                rainbowButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = rainbowButton.position
                page1ScrollView.addChild(rainbowButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                rainbowPlus = SKSpriteNode(texture:Texture)
                rainbowPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(rainbowPlus)
                
                rainbowLabel = SKLabelNode(fontNamed: "Lemondrop")
                rainbowLabel.fontSize = 20
                rainbowLabel.fontColor = UIColor.black
                rainbowLabel.text = String(numOfMold(mold: MoldType.rainbow))
                rainbowLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(rainbowLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                rainbowMinus = SKSpriteNode(texture:Texture)
                rainbowMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(rainbowMinus)
            }
            if mold.moldType == MoldType.aluminum {
                Texture = SKTexture(image: UIImage(named: "Aluminum Mold")!)
                aluminumButton = SKSpriteNode(texture:Texture)
                // Place in scene
                aluminumButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = aluminumButton.position
                page1ScrollView.addChild(aluminumButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                aluminumPlus = SKSpriteNode(texture:Texture)
                aluminumPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(aluminumPlus)
                
                aluminumLabel = SKLabelNode(fontNamed: "Lemondrop")
                aluminumLabel.fontSize = 20
                aluminumLabel.fontColor = UIColor.black
                aluminumLabel.text = String(numOfMold(mold: MoldType.aluminum))
                aluminumLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(aluminumLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                aluminumMinus = SKSpriteNode(texture:Texture)
                aluminumMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(aluminumMinus)
            }
            if mold.moldType == MoldType.circuit {
                Texture = SKTexture(image: UIImage(named: "Circuit Mold")!)
                circuitButton = SKSpriteNode(texture:Texture)
                // Place in scene
                circuitButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = circuitButton.position
                page1ScrollView.addChild(circuitButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                circuitPlus = SKSpriteNode(texture:Texture)
                circuitPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(circuitPlus)
                
                circuitLabel = SKLabelNode(fontNamed: "Lemondrop")
                circuitLabel.fontSize = 20
                circuitLabel.fontColor = UIColor.black
                circuitLabel.text = String(numOfMold(mold: MoldType.circuit))
                circuitLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(circuitLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                circuitMinus = SKSpriteNode(texture:Texture)
                circuitMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(circuitMinus)
            }
            if mold.moldType == MoldType.hologram {
                Texture = SKTexture(image: UIImage(named: "Hologram Mold")!)
                hologramButton = SKSpriteNode(texture:Texture)
                // Place in scene
                hologramButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = hologramButton.position
                page1ScrollView.addChild(hologramButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                hologramPlus = SKSpriteNode(texture:Texture)
                hologramPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(hologramPlus)
                
                hologramLabel = SKLabelNode(fontNamed: "Lemondrop")
                hologramLabel.fontSize = 20
                hologramLabel.fontColor = UIColor.black
                hologramLabel.text = String(numOfMold(mold: MoldType.hologram))
                hologramLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(hologramLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                hologramMinus = SKSpriteNode(texture:Texture)
                hologramMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(hologramMinus)
            }
            if mold.moldType == MoldType.storm {
                Texture = SKTexture(image: UIImage(named: "Storm Mold")!)
                stormButton = SKSpriteNode(texture:Texture)
                // Place in scene
                stormButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = stormButton.position
                page1ScrollView.addChild(stormButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                stormPlus = SKSpriteNode(texture:Texture)
                stormPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(stormPlus)
                
                stormLabel = SKLabelNode(fontNamed: "Lemondrop")
                stormLabel.fontSize = 20
                stormLabel.fontColor = UIColor.black
                stormLabel.text = String(numOfMold(mold: MoldType.storm))
                stormLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(stormLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                stormMinus = SKSpriteNode(texture:Texture)
                stormMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(stormMinus)
            }
            if mold.moldType == MoldType.bacteria {
                Texture = SKTexture(image: UIImage(named: "Bacteria Mold")!)
                bacteriaButton = SKSpriteNode(texture:Texture)
                // Place in scene
                bacteriaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = bacteriaButton.position
                page1ScrollView.addChild(bacteriaButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                bacteriaPlus = SKSpriteNode(texture:Texture)
                bacteriaPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(bacteriaPlus)
                
                bacteriaLabel = SKLabelNode(fontNamed: "Lemondrop")
                bacteriaLabel.fontSize = 20
                bacteriaLabel.fontColor = UIColor.black
                bacteriaLabel.text = String(numOfMold(mold: MoldType.bacteria))
                bacteriaLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(bacteriaLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                bacteriaMinus = SKSpriteNode(texture:Texture)
                bacteriaMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(bacteriaMinus)
            }
            if mold.moldType == MoldType.virus {
                Texture = SKTexture(image: UIImage(named: "Virus Mold")!)
                virusButton = SKSpriteNode(texture:Texture)
                // Place in scene
                virusButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = virusButton.position
                page1ScrollView.addChild(virusButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                virusPlus = SKSpriteNode(texture:Texture)
                virusPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(virusPlus)
                
                virusLabel = SKLabelNode(fontNamed: "Lemondrop")
                virusLabel.fontSize = 20
                virusLabel.fontColor = UIColor.black
                virusLabel.text = String(numOfMold(mold: MoldType.virus))
                virusLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(virusLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                virusMinus = SKSpriteNode(texture:Texture)
                virusMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(virusMinus)
            }
            if mold.moldType == MoldType.flower {
                Texture = SKTexture(image: UIImage(named: "Flower Mold")!)
                flowerButton = SKSpriteNode(texture:Texture)
                // Place in scene
                flowerButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 120)
                lastButton = flowerButton.position
                page1ScrollView.addChild(flowerButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                flowerPlus = SKSpriteNode(texture:Texture)
                flowerPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(flowerPlus)
                
                flowerLabel = SKLabelNode(fontNamed: "Lemondrop")
                flowerLabel.fontSize = 20
                flowerLabel.fontColor = UIColor.black
                flowerLabel.text = String(numOfMold(mold: MoldType.flower))
                flowerLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(flowerLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                flowerMinus = SKSpriteNode(texture:Texture)
                flowerMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(flowerMinus)
                lastButton = CGPoint(x: lastButton.x, y: lastButton.y - 60)
            }
            if mold.moldType == MoldType.bee {
                Texture = SKTexture(image: UIImage(named: "Bee Mold")!)
                beeButton = SKSpriteNode(texture:Texture)
                // Place in scene
                beeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = beeButton.position
                page1ScrollView.addChild(beeButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                beePlus = SKSpriteNode(texture:Texture)
                beePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(beePlus)
                
                beeLabel = SKLabelNode(fontNamed: "Lemondrop")
                beeLabel.fontSize = 20
                beeLabel.fontColor = UIColor.black
                beeLabel.text = String(numOfMold(mold: MoldType.bee))
                beeLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(beeLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                beeMinus = SKSpriteNode(texture:Texture)
                beeMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(beeMinus)
            }
            if mold.moldType == MoldType.x {
                Texture = SKTexture(image: UIImage(named: "X Mold")!)
                xButton = SKSpriteNode(texture:Texture)
                // Place in scene
                xButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = xButton.position
                page1ScrollView.addChild(xButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                xPlus = SKSpriteNode(texture:Texture)
                xPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(xPlus)
                
                xLabel = SKLabelNode(fontNamed: "Lemondrop")
                xLabel.fontSize = 20
                xLabel.fontColor = UIColor.black
                xLabel.text = String(numOfMold(mold: MoldType.x))
                xLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(xLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                xMinus = SKSpriteNode(texture:Texture)
                xMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(xMinus)
            }
            if mold.moldType == MoldType.disaffected {
                Texture = SKTexture(image: UIImage(named: "Disaffected Mold")!)
                disaffectedButton = SKSpriteNode(texture:Texture)
                // Place in scene
                disaffectedButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = disaffectedButton.position
                page1ScrollView.addChild(disaffectedButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                disaffectedPlus = SKSpriteNode(texture:Texture)
                disaffectedPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(disaffectedPlus)
                
                disaffectedLabel = SKLabelNode(fontNamed: "Lemondrop")
                disaffectedLabel.fontSize = 20
                disaffectedLabel.fontColor = UIColor.black
                disaffectedLabel.text = String(numOfMold(mold: MoldType.disaffected))
                disaffectedLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(disaffectedLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                disaffectedMinus = SKSpriteNode(texture:Texture)
                disaffectedMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(disaffectedMinus)
            }
            if mold.moldType == MoldType.olive {
                Texture = SKTexture(image: UIImage(named: "Olive Mold")!)
                oliveButton = SKSpriteNode(texture:Texture)
                // Place in scene
                oliveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = oliveButton.position
                page1ScrollView.addChild(oliveButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                olivePlus = SKSpriteNode(texture:Texture)
                olivePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(olivePlus)
                
                oliveLabel = SKLabelNode(fontNamed: "Lemondrop")
                oliveLabel.fontSize = 20
                oliveLabel.fontColor = UIColor.black
                oliveLabel.text = String(numOfMold(mold: MoldType.olive))
                oliveLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(oliveLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                oliveMinus = SKSpriteNode(texture:Texture)
                oliveMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(oliveMinus)
            }
            if mold.moldType == MoldType.coconut {
                Texture = SKTexture(image: UIImage(named: "Coconut Mold")!)
                coconutButton = SKSpriteNode(texture:Texture)
                // Place in scene
                coconutButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = coconutButton.position
                page1ScrollView.addChild(coconutButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                coconutPlus = SKSpriteNode(texture:Texture)
                coconutPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(coconutPlus)
                
                coconutLabel = SKLabelNode(fontNamed: "Lemondrop")
                coconutLabel.fontSize = 20
                coconutLabel.fontColor = UIColor.black
                coconutLabel.text = String(numOfMold(mold: MoldType.coconut))
                coconutLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(coconutLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                coconutMinus = SKSpriteNode(texture:Texture)
                coconutMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(coconutMinus)
            }
            if mold.moldType == MoldType.sick {
                Texture = SKTexture(image: UIImage(named: "Sick Mold")!)
                sickButton = SKSpriteNode(texture:Texture)
                // Place in scene
                sickButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = sickButton.position
                page1ScrollView.addChild(sickButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                sickPlus = SKSpriteNode(texture:Texture)
                sickPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(sickPlus)
                
                sickLabel = SKLabelNode(fontNamed: "Lemondrop")
                sickLabel.fontSize = 20
                sickLabel.fontColor = UIColor.black
                sickLabel.text = String(numOfMold(mold: MoldType.sick))
                sickLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(sickLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                sickMinus = SKSpriteNode(texture:Texture)
                sickMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(sickMinus)
            }
            if mold.moldType == MoldType.dead {
                Texture = SKTexture(image: UIImage(named: "Dead Mold")!)
                deadButton = SKSpriteNode(texture:Texture)
                // Place in scene
                deadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = deadButton.position
                page1ScrollView.addChild(deadButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                deadPlus = SKSpriteNode(texture:Texture)
                deadPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(deadPlus)
                
                deadLabel = SKLabelNode(fontNamed: "Lemondrop")
                deadLabel.fontSize = 20
                deadLabel.fontColor = UIColor.black
                deadLabel.text = String(numOfMold(mold: MoldType.dead))
                deadLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(deadLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                deadMinus = SKSpriteNode(texture:Texture)
                deadMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(deadMinus)
            }
            if mold.moldType == MoldType.zombie {
                Texture = SKTexture(image: UIImage(named: "Zombie Mold")!)
                zombieButton = SKSpriteNode(texture:Texture)
                // Place in scene
                zombieButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = zombieButton.position
                page1ScrollView.addChild(zombieButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                zombiePlus = SKSpriteNode(texture:Texture)
                zombiePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(zombiePlus)
                
                zombieLabel = SKLabelNode(fontNamed: "Lemondrop")
                zombieLabel.fontSize = 20
                zombieLabel.fontColor = UIColor.black
                zombieLabel.text = String(numOfMold(mold: MoldType.zombie))
                zombieLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(zombieLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                zombieMinus = SKSpriteNode(texture:Texture)
                zombieMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(zombieMinus)
            }
            if mold.moldType == MoldType.rock {
                Texture = SKTexture(image: UIImage(named: "Rock Mold")!)
                rockButton = SKSpriteNode(texture:Texture)
                // Place in scene
                rockButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = rockButton.position
                page1ScrollView.addChild(rockButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                rockPlus = SKSpriteNode(texture:Texture)
                rockPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(rockPlus)
                
                rockLabel = SKLabelNode(fontNamed: "Lemondrop")
                rockLabel.fontSize = 20
                rockLabel.fontColor = UIColor.black
                rockLabel.text = String(numOfMold(mold: MoldType.rock))
                rockLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(rockLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                rockMinus = SKSpriteNode(texture:Texture)
                rockMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(rockMinus)
            }
            if mold.moldType == MoldType.cloud {
                Texture = SKTexture(image: UIImage(named: "Cloud Mold")!)
                cloudButton = SKSpriteNode(texture:Texture)
                // Place in scene
                cloudButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = cloudButton.position
                page1ScrollView.addChild(cloudButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                cloudPlus = SKSpriteNode(texture:Texture)
                cloudPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(cloudPlus)
                
                cloudLabel = SKLabelNode(fontNamed: "Lemondrop")
                cloudLabel.fontSize = 20
                cloudLabel.fontColor = UIColor.black
                cloudLabel.text = String(numOfMold(mold: MoldType.cloud))
                cloudLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(cloudLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                cloudMinus = SKSpriteNode(texture:Texture)
                cloudMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(cloudMinus)
            }
            if mold.moldType == MoldType.water {
                Texture = SKTexture(image: UIImage(named: "Water Mold")!)
                waterButton = SKSpriteNode(texture:Texture)
                // Place in scene
                waterButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = waterButton.position
                page1ScrollView.addChild(waterButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                waterPlus = SKSpriteNode(texture:Texture)
                waterPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(waterPlus)
                
                waterLabel = SKLabelNode(fontNamed: "Lemondrop")
                waterLabel.fontSize = 20
                waterLabel.fontColor = UIColor.black
                waterLabel.text = String(numOfMold(mold: MoldType.water))
                waterLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(waterLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                waterMinus = SKSpriteNode(texture:Texture)
                waterMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(waterMinus)
            }
            if mold.moldType == MoldType.crystal {
                Texture = SKTexture(image: UIImage(named: "Crystal Mold")!)
                crystalButton = SKSpriteNode(texture:Texture)
                // Place in scene
                crystalButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = crystalButton.position
                page1ScrollView.addChild(crystalButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                crystalPlus = SKSpriteNode(texture:Texture)
                crystalPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(crystalPlus)
                
                crystalLabel = SKLabelNode(fontNamed: "Lemondrop")
                crystalLabel.fontSize = 20
                crystalLabel.fontColor = UIColor.black
                crystalLabel.text = String(numOfMold(mold: MoldType.crystal))
                crystalLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(crystalLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                crystalMinus = SKSpriteNode(texture:Texture)
                crystalMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(crystalMinus)
            }
            if mold.moldType == MoldType.nuclear {
                Texture = SKTexture(image: UIImage(named: "Nuclear Mold")!)
                nuclearButton = SKSpriteNode(texture:Texture)
                // Place in scene
                nuclearButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = nuclearButton.position
                page1ScrollView.addChild(nuclearButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                nuclearPlus = SKSpriteNode(texture:Texture)
                nuclearPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(nuclearPlus)
                
                nuclearLabel = SKLabelNode(fontNamed: "Lemondrop")
                nuclearLabel.fontSize = 20
                nuclearLabel.fontColor = UIColor.black
                nuclearLabel.text = String(numOfMold(mold: MoldType.nuclear))
                nuclearLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(nuclearLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                nuclearMinus = SKSpriteNode(texture:Texture)
                nuclearMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(nuclearMinus)
            }
            if mold.moldType == MoldType.astronaut {
                Texture = SKTexture(image: UIImage(named: "Astronaut Mold")!)
                astronautButton = SKSpriteNode(texture:Texture)
                // Place in scene
                astronautButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = astronautButton.position
                page1ScrollView.addChild(astronautButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                astronautPlus = SKSpriteNode(texture:Texture)
                astronautPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(astronautPlus)
                
                astronautLabel = SKLabelNode(fontNamed: "Lemondrop")
                astronautLabel.fontSize = 20
                astronautLabel.fontColor = UIColor.black
                astronautLabel.text = String(numOfMold(mold: MoldType.astronaut))
                astronautLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(astronautLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                astronautMinus = SKSpriteNode(texture:Texture)
                astronautMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(astronautMinus)
            }
            if mold.moldType == MoldType.sand {
                Texture = SKTexture(image: UIImage(named: "Sand Mold")!)
                sandButton = SKSpriteNode(texture:Texture)
                // Place in scene
                sandButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = sandButton.position
                page1ScrollView.addChild(sandButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                sandPlus = SKSpriteNode(texture:Texture)
                sandPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(sandPlus)
                
                sandLabel = SKLabelNode(fontNamed: "Lemondrop")
                sandLabel.fontSize = 20
                sandLabel.fontColor = UIColor.black
                sandLabel.text = String(numOfMold(mold: MoldType.sand))
                sandLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(sandLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                sandMinus = SKSpriteNode(texture:Texture)
                sandMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(sandMinus)
            }
            if mold.moldType == MoldType.glass {
                Texture = SKTexture(image: UIImage(named: "Glass Mold")!)
                glassButton = SKSpriteNode(texture:Texture)
                // Place in scene
                glassButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = glassButton.position
                page1ScrollView.addChild(glassButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                glassPlus = SKSpriteNode(texture:Texture)
                glassPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(glassPlus)
                
                glassLabel = SKLabelNode(fontNamed: "Lemondrop")
                glassLabel.fontSize = 20
                glassLabel.fontColor = UIColor.black
                glassLabel.text = String(numOfMold(mold: MoldType.glass))
                glassLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(glassLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                glassMinus = SKSpriteNode(texture:Texture)
                glassMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(glassMinus)
            }
            if mold.moldType == MoldType.coffee {
                Texture = SKTexture(image: UIImage(named: "Coffee Mold")!)
                coffeeButton = SKSpriteNode(texture:Texture)
                // Place in scene
                coffeeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = coffeeButton.position
                page1ScrollView.addChild(coffeeButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                coffeePlus = SKSpriteNode(texture:Texture)
                coffeePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(coffeePlus)
                
                coffeeLabel = SKLabelNode(fontNamed: "Lemondrop")
                coffeeLabel.fontSize = 20
                coffeeLabel.fontColor = UIColor.black
                coffeeLabel.text = String(numOfMold(mold: MoldType.coffee))
                coffeeLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(coffeeLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                coffeeMinus = SKSpriteNode(texture:Texture)
                coffeeMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(coffeeMinus)
            }
            if mold.moldType == MoldType.slinky {
                Texture = SKTexture(image: UIImage(named: "Slinky Mold")!)
                slinkyButton = SKSpriteNode(texture:Texture)
                // Place in scene
                slinkyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = slinkyButton.position
                page1ScrollView.addChild(slinkyButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                slinkyPlus = SKSpriteNode(texture:Texture)
                slinkyPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(slinkyPlus)
                
                slinkyLabel = SKLabelNode(fontNamed: "Lemondrop")
                slinkyLabel.fontSize = 20
                slinkyLabel.fontColor = UIColor.black
                slinkyLabel.text = String(numOfMold(mold: MoldType.slinky))
                slinkyLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(slinkyLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                slinkyMinus = SKSpriteNode(texture:Texture)
                slinkyMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(slinkyMinus)
            }
            if mold.moldType == MoldType.magma {
                Texture = SKTexture(image: UIImage(named: "Magma Mold")!)
                magmaButton = SKSpriteNode(texture:Texture)
                // Place in scene
                magmaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = magmaButton.position
                page1ScrollView.addChild(magmaButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                magmaPlus = SKSpriteNode(texture:Texture)
                magmaPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(magmaPlus)
                
                magmaLabel = SKLabelNode(fontNamed: "Lemondrop")
                magmaLabel.fontSize = 20
                magmaLabel.fontColor = UIColor.black
                magmaLabel.text = String(numOfMold(mold: MoldType.magma))
                magmaLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(magmaLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                magmaMinus = SKSpriteNode(texture:Texture)
                magmaMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(magmaMinus)
            }
            if mold.moldType == MoldType.samurai {
                Texture = SKTexture(image: UIImage(named: "Samurai Mold")!)
                samuraiButton = SKSpriteNode(texture:Texture)
                // Place in scene
                samuraiButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = samuraiButton.position
                page1ScrollView.addChild(samuraiButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                samuraiPlus = SKSpriteNode(texture:Texture)
                samuraiPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(samuraiPlus)
                
                samuraiLabel = SKLabelNode(fontNamed: "Lemondrop")
                samuraiLabel.fontSize = 20
                samuraiLabel.fontColor = UIColor.black
                samuraiLabel.text = String(numOfMold(mold: MoldType.samurai))
                samuraiLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(samuraiLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                samuraiMinus = SKSpriteNode(texture:Texture)
                samuraiMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(samuraiMinus)
            }
            if mold.moldType == MoldType.orange {
                Texture = SKTexture(image: UIImage(named: "Orange Mold")!)
                orangeButton = SKSpriteNode(texture:Texture)
                // Place in scene
                orangeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = orangeButton.position
                page1ScrollView.addChild(orangeButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                orangePlus = SKSpriteNode(texture:Texture)
                orangePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(orangePlus)
                
                orangeLabel = SKLabelNode(fontNamed: "Lemondrop")
                orangeLabel.fontSize = 20
                orangeLabel.fontColor = UIColor.black
                orangeLabel.text = String(numOfMold(mold: MoldType.orange))
                orangeLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(orangeLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                orangeMinus = SKSpriteNode(texture:Texture)
                orangeMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(orangeMinus)
            }
            if mold.moldType == MoldType.strawberry {
                Texture = SKTexture(image: UIImage(named: "Strawberry Mold")!)
                strawberryButton = SKSpriteNode(texture:Texture)
                // Place in scene
                strawberryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = strawberryButton.position
                page1ScrollView.addChild(strawberryButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                strawberryPlus = SKSpriteNode(texture:Texture)
                strawberryPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(strawberryPlus)
                
                strawberryLabel = SKLabelNode(fontNamed: "Lemondrop")
                strawberryLabel.fontSize = 20
                strawberryLabel.fontColor = UIColor.black
                strawberryLabel.text = String(numOfMold(mold: MoldType.strawberry))
                strawberryLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(strawberryLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                strawberryMinus = SKSpriteNode(texture:Texture)
                strawberryMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(strawberryMinus)
            }
            if mold.moldType == MoldType.tshirt {
                Texture = SKTexture(image: UIImage(named: "TShirt Mold")!)
                tshirtButton = SKSpriteNode(texture:Texture)
                // Place in scene
                tshirtButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = tshirtButton.position
                page1ScrollView.addChild(tshirtButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                tshirtPlus = SKSpriteNode(texture:Texture)
                tshirtPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(tshirtPlus)
                
                tshirtLabel = SKLabelNode(fontNamed: "Lemondrop")
                tshirtLabel.fontSize = 20
                tshirtLabel.fontColor = UIColor.black
                tshirtLabel.text = String(numOfMold(mold: MoldType.tshirt))
                tshirtLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(tshirtLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                tshirtMinus = SKSpriteNode(texture:Texture)
                tshirtMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(tshirtMinus)
            }
            if mold.moldType == MoldType.cryptid {
                Texture = SKTexture(image: UIImage(named: "Cryptid Mold")!)
                cryptidButton = SKSpriteNode(texture:Texture)
                // Place in scene
                cryptidButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = cryptidButton.position
                page1ScrollView.addChild(cryptidButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                cryptidPlus = SKSpriteNode(texture:Texture)
                cryptidPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(cryptidPlus)
                
                cryptidLabel = SKLabelNode(fontNamed: "Lemondrop")
                cryptidLabel.fontSize = 20
                cryptidLabel.fontColor = UIColor.black
                cryptidLabel.text = String(numOfMold(mold: MoldType.cryptid))
                cryptidLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(cryptidLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                cryptidMinus = SKSpriteNode(texture:Texture)
                cryptidMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(cryptidMinus)
            }
            if mold.moldType == MoldType.angel {
                Texture = SKTexture(image: UIImage(named: "Angel Mold")!)
                angelButton = SKSpriteNode(texture:Texture)
                // Place in scene
                angelButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = angelButton.position
                page1ScrollView.addChild(angelButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                angelPlus = SKSpriteNode(texture:Texture)
                angelPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(angelPlus)
                
                angelLabel = SKLabelNode(fontNamed: "Lemondrop")
                angelLabel.fontSize = 20
                angelLabel.fontColor = UIColor.black
                angelLabel.text = String(numOfMold(mold: MoldType.angel))
                angelLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(angelLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                angelMinus = SKSpriteNode(texture:Texture)
                angelMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(angelMinus)
            }
            if mold.moldType == MoldType.invisible {
                Texture = SKTexture(image: UIImage(named: "Invisible Mold")!)
                invisibleButton = SKSpriteNode(texture:Texture)
                // Place in scene
                invisibleButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = invisibleButton.position
                page1ScrollView.addChild(invisibleButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                invisiblePlus = SKSpriteNode(texture:Texture)
                invisiblePlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(invisiblePlus)
                
                invisibleLabel = SKLabelNode(fontNamed: "Lemondrop")
                invisibleLabel.fontSize = 20
                invisibleLabel.fontColor = UIColor.black
                invisibleLabel.text = String(numOfMold(mold: MoldType.invisible))
                invisibleLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(invisibleLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                invisibleMinus = SKSpriteNode(texture:Texture)
                invisibleMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(invisibleMinus)
            }
            if mold.moldType == MoldType.star {
                Texture = SKTexture(image: UIImage(named: "Star Mold small")!)
                starButton = SKSpriteNode(texture:Texture)
                // Place in scene
                starButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 120)
                lastButton = starButton.position
                page1ScrollView.addChild(starButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                starPlus = SKSpriteNode(texture:Texture)
                starPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(starPlus)
                
                starLabel = SKLabelNode(fontNamed: "Lemondrop")
                starLabel.fontSize = 20
                starLabel.fontColor = UIColor.black
                starLabel.text = String(numOfMold(mold: MoldType.star))
                starLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(starLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                starMinus = SKSpriteNode(texture:Texture)
                starMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(starMinus)
            }
            if mold.moldType == MoldType.metaphase {
                Texture = SKTexture(image: UIImage(named: "Metaphase Mold")!)
                metaButton = SKSpriteNode(texture:Texture)
                // Place in scene
                metaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = metaButton.position
                page1ScrollView.addChild(metaButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                metaPlus = SKSpriteNode(texture:Texture)
                metaPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(metaPlus)
                
                metaLabel = SKLabelNode(fontNamed: "Lemondrop")
                metaLabel.fontSize = 20
                metaLabel.fontColor = UIColor.black
                metaLabel.text = String(numOfMold(mold: MoldType.metaphase))
                metaLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(metaLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                metaMinus = SKSpriteNode(texture:Texture)
                metaMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(metaMinus)
            }
            if mold.moldType == MoldType.god {
                Texture = SKTexture(image: UIImage(named: "God Mold")!)
                godButton = SKSpriteNode(texture:Texture)
                // Place in scene
                godButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 150)
                lastButton = godButton.position
                page1ScrollView.addChild(godButton)
                
                Texture = SKTexture(image: UIImage(named: "clear_plus")!)
                godPlus = SKSpriteNode(texture:Texture)
                godPlus.position = CGPoint(x: lastButton.x + 100, y: lastButton.y)
                page1ScrollView.addChild(godPlus)
                
                godLabel = SKLabelNode(fontNamed: "Lemondrop")
                godLabel.fontSize = 20
                godLabel.fontColor = UIColor.black
                godLabel.text = String(numOfMold(mold: MoldType.god))
                godLabel.position = CGPoint(x: lastButton.x + 140, y: lastButton.y - 10)
                page1ScrollView.addChild(godLabel)
                
                Texture = SKTexture(image: UIImage(named: "clear_minus")!)
                godMinus = SKSpriteNode(texture:Texture)
                godMinus.position = CGPoint(x: lastButton.x + 180, y: lastButton.y)
                page1ScrollView.addChild(godMinus)
                lastButton = CGPoint(x: lastButton.x, y: lastButton.y - 80)
            }
        }
        addChild(gameLayer)
    }
    
    //quick check if the player owns the requested mold
    func moldOwned(mold: MoldType) -> Bool {
        return ownedMolds.contains(where: {$0.moldType == mold})
    }
    
    //get number of specific mold
    func numOfMold(mold: MoldType) -> Int {
        return displayCountDicc[mold.spriteName] ?? 0
    }

    func createButton()
    {
        // BACK MENU
        let Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+190);
        
        self.addChild(backButton)

        totalLabel = SKLabelNode(fontNamed: "Lemondrop")
        totalLabel.fontSize = 20
        totalLabel.fontColor = UIColor.black
        totalLabel.text = String(totalNum)
        totalLabel.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+130);
        self.addChild(totalLabel)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            totalLabel.setScale(0.75)
            totalLabel.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+130);
            break
        case .iPhone5:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            totalLabel.setScale(0.75)
            totalLabel.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+130);
            break
        default:
            break
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            //check if touch was one of the mold buttons
            if slimeButton != nil {
                if node == slimeButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.slime.description, new: 0)
                }
                if node == slimePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("slimePlus")
                    }
                }
                if node == slimeMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("slimeMinus")
                    }
                }
            }
            if caveButton != nil {
                if node == caveButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.cave.description, new: 0)
                }
                if node == cavePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("cavePlus")
                    }
                }
                if node == caveMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("caveMinus")
                    }
                }
            }
            if sadButton != nil {
                if node == sadButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.sad.description, new: 0)
                }
                if node == sadPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("sadPlus")
                    }
                }
                if node == sadMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("sadMinus")
                    }
                }
            }
            if angryButton != nil {
                if node == angryButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.angry.description, new: 0)
                }
                if node == angryPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("angryPlus")
                    }
                }
                if node == angryMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("angryMinus")
                    }
                }
            }
            if (alienButton) != nil {
                if node == alienButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.alien.description, new: 0)
                }
                if node == alienPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("alienPlus")
                    }
                }
                if node == alienMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("alienMinus")
                    }
                }
            }
            
            if (pimplyButton) != nil {
                if node == pimplyButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.pimply.description, new: 0)
                }
                if node == pimplyPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("pimplyPlus")
                    }
                }
                if node == pimplyMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("pimplyMinus")
                    }
                }
            }
            if (freckledButton) != nil {
                if node == freckledButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.freckled.description, new: 0)
                }
                if node == freckledPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("freckledPlus")
                    }
                }
                if node == freckledMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("freckledMinus")
                    }
                }
            }
            if (hypnoButton) != nil {
                if node == hypnoButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.hypno.description, new: 0)
                }
                if node == hypnoPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("hypnoPlus")
                    }
                }
                if node == hypnoMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("hypnoMinus")
                    }
                }
            }
            if (rainbowButton) != nil {
                if node == rainbowButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.rainbow.description, new: 0)
                }
                if node == rainbowPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("rainbowPlus")
                    }
                }
                if node == rainbowMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("rainbowMinus")
                    }
                }
            }
            if (aluminumButton) != nil {
                if node == aluminumButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.aluminum.description, new: 0)
                }
                if node == aluminumPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("aluminumPlus")
                    }
                }
                if node == aluminumMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("aluminumMinus")
                    }
                }
            }
            if (circuitButton) != nil {
                if node == circuitButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.circuit.description, new: 0)
                }
                if node == circuitPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("circuitPlus")
                    }
                }
                if node == circuitMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("circuitMinus")
                    }
                }
            }
            if (hologramButton) != nil {
                if node == hologramButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.hologram.description, new: 0)
                }
                if node == hologramPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("hologramPlus")
                    }
                }
                if node == hologramMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("hologramMinus")
                    }
                }
            }
            if (stormButton) != nil {
                if node == stormButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.storm.description, new: 0)
                }
                if node == stormPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("stormPlus")
                    }
                }
                if node == stormMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("stormMinus")
                    }
                }
            }
            if (bacteriaButton) != nil {
                if node == bacteriaButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.bacteria.description, new: 0)
                }
                if node == bacteriaPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("bacteriaPlus")
                    }
                }
                if node == bacteriaMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("bacteriaMinus")
                    }
                }
            }
            if (virusButton) != nil {
                if node == virusButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.virus.description, new: 0)
                }
                if node == virusPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("virusPlus")
                    }
                }
                if node == virusMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("virusMinus")
                    }
                }
            }
            if (flowerButton) != nil {
                if node == flowerButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.flower.description, new: 0)
                }
                if node == flowerPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("flowerPlus")
                    }
                }
                if node == flowerMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("flowerMinus")
                    }
                }
            }
            if (beeButton) != nil {
                if node == beeButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.bee.description, new: 0)
                }
                if node == beePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("beePlus")
                    }
                }
                if node == beeMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("beeMinus")
                    }
                }
            }
            if (xButton) != nil {
                if node == xButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.x.description, new: 0)
                }
                if node == xPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("xPlus")
                    }
                }
                if node == xMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("xMinus")
                    }
                }
            }
            if (disaffectedButton) != nil {
                if node == disaffectedButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.disaffected.description, new: 0)
                }
                if node == disaffectedPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("disaffectedPlus")
                    }
                }
                if node == disaffectedMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("disaffectedMinus")
                    }
                }
            }
            if (oliveButton) != nil {
                if node == oliveButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.olive.description, new: 0)
                }
                if node == olivePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("olivePlus")
                    }
                }
                if node == oliveMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("oliveMinus")
                    }
                }
            }
            if (coconutButton) != nil {
                if node == coconutButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.coconut.description, new: 0)
                }
                if node == coconutPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("coconutPlus")
                    }
                }
                if node == coconutMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("coconutMinus")
                    }
                }
            }
            if (sickButton) != nil {
                if node == sickButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.sick.description, new: 0)
                }
                if node == sickPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("sickPlus")
                    }
                }
                if node == sickMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("sickMinus")
                    }
                }
            }
            if (deadButton) != nil {
                if node == deadButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.dead.description, new: 0)
                }
                if node == deadPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("deadPlus")
                    }
                }
                if node == deadMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("deadMinus")
                    }
                }
            }
            if (zombieButton) != nil {
                if node == zombieButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.zombie.description, new: 0)
                }
                if node == zombiePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("zombiePlus")
                    }
                }
                if node == zombieMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("zombieMinus")
                    }
                }
            }
            if (cloudButton) != nil {
                if node == cloudButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.cloud.description, new: 0)
                }
                if node == cloudPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("cloudPlus")
                    }
                }
                if node == cloudMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("cloudMinus")
                    }
                }
            }
            if (rockButton) != nil {
                if node == rockButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.rock.description, new: 0)
                }
                if node == rockPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("rockPlus")
                    }
                }
                if node == rockMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("rockMinus")
                    }
                }
            }
            if (waterButton) != nil {
                if node == waterButton {
                  
                    animateName(point: touch.location(in: gameLayer), name: MoldType.water.description, new: 0)
                }
                if node == waterPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("waterPlus")
                    }
                }
                if node == waterMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("waterMinus")
                    }
                }
            }
            if (crystalButton) != nil {
                if node == crystalButton {
                  
                    animateName(point: touch.location(in: gameLayer), name: MoldType.crystal.description, new: 0)
                }
                if node == crystalPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("crystalPlus")
                    }
                }
                if node == crystalMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("crystalMinus")
                    }
                }
            }
            if (nuclearButton) != nil {
                if node == nuclearButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.nuclear.description, new: 0)
                }
                if node == nuclearPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("nuclearPlus")
                    }
                }
                if node == nuclearMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("nuclearMinus")
                    }
                }
            }
            if (astronautButton) != nil {
                if node == astronautButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.astronaut.description, new: 0)
                }
                if node == astronautPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("astronautPlus")
                    }
                }
                if node == astronautMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("astronautMinus")
                    }
                }
            }
            if (sandButton) != nil {
                if node == sandButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.sand.description, new: 0)
                }
                if node == sandPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("sandPlus")
                    }
                }
                if node == sandMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("sandMinus")
                    }
                }
            }
            if (glassButton) != nil {
                if node == glassButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.glass.description, new: 0)
                }
                if node == glassPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("glassPlus")
                    }
                }
                if node == glassMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("glassMinus")
                    }
                }
            }
            if (coffeeButton) != nil {
                if node == coffeeButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.coffee.description, new: 0)
                }
                if node == coffeePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("coffeePlus")
                    }
                }
                if node == coffeeMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("coffeeMinus")
                    }
                }
            }
            if (slinkyButton) != nil {
                if node == slinkyButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.slinky.description, new: 0)
                }
                if node == slinkyPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("slinkyPlus")
                    }
                }
                if node == slinkyMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("slinkyMinus")
                    }
                }
            }
            if (magmaButton) != nil {
                if node == magmaButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.magma.description, new: 0)
                }
                if node == magmaPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("magmaPlus")
                    }
                }
                if node == magmaMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("magmaMinus")
                    }
                }
            }
            if (samuraiButton) != nil {
                if node == samuraiButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.samurai.description, new: 0)
                }
                if node == samuraiPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("samuraiPlus")
                    }
                }
                if node == samuraiMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("samuraiMinus")
                    }
                }
            }
            if (orangeButton) != nil {
                if node == orangeButton {
                  
                    animateName(point: touch.location(in: gameLayer), name: MoldType.orange.description, new: 0)
                }
                if node == orangePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("orangePlus")
                    }
                }
                if node == orangeMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("orangeMinus")
                    }
                }
            }
            if (strawberryButton) != nil {
                if node == strawberryButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.strawberry.description, new: 0)
                }
                if node == strawberryPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("strawberryPlus")
                    }
                }
                if node == strawberryMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("strawberryMinus")
                    }
                }
            }
            if (tshirtButton) != nil {
                if node == tshirtButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.tshirt.description, new: 0)
                }
                if node == tshirtPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("tshirtPlus")
                    }
                }
                if node == tshirtMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("tshirtMinus")
                    }
                }
            }
            if (cryptidButton) != nil {
                if node == cryptidButton {
                   
                    animateName(point: touch.location(in: gameLayer), name: MoldType.cryptid.description, new: 0)
                }
                if node == cryptidPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("cryptidPlus")
                    }
                }
                if node == cryptidMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("cryptidMinus")
                    }
                }
            }
            if (angelButton) != nil {
                if node == angelButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.angel.description, new: 0)
                }
                if node == angelPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("angelPlus")
                    }
                }
                if node == angelMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("angelMinus")
                    }
                }
            }
            if (invisibleButton) != nil {
                if node == invisibleButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.invisible.description, new: 0)
                }
                if node == invisiblePlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("invisiblePlus")
                    }
                }
                if node == invisibleMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("invisibleMinus")
                    }
                }
            }
            if (starButton) != nil {
                if node == starButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.star.description, new: 0)
                }
                if node == starPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("starPlus")
                    }
                }
                if node == starMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("starMinus")
                    }
                }
            }
            if (metaButton) != nil {
                if node == metaButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.metaphase.description, new: 0)
                }
                if node == metaPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("metaPlus")
                    }
                }
                if node == metaMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("metaMinus")
                    }
                }
            }
            if (godButton) != nil {
                if node == godButton {
                    
                    animateName(point: touch.location(in: gameLayer), name: MoldType.god.description, new: 0)
                }
                if node == godPlus {
                    if let handler = touchHandler {
                        playSound(select: "add")
                        handler("godPlus")
                    }
                }
                if node == godMinus {
                    if let handler = touchHandler {
                        playSound(select: "remove")
                        handler("godMinus")
                    }
                }
            }
            
        }
        
        //for the rest of the buttons
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if backButton.contains(touchLocation) {
            print("exit")
            if let handler = touchHandler {
                scrollView?.removeFromSuperview()
                handler("exit")
            }
        }
    }
    
    func playSound(select: String) {
        if mute == false {
        switch select {
        case "levelup":
            run(levelUpSound)
        case "add":
            run(addSound)
        case "remove":
            run(snipSound)
        case "select":
            run(selectSound)
        default:
            run(levelUpSound)
        }
        }
    }
    
    func animateName(point: CGPoint,name: String, new: Int) {
        // Figure out what the midpoint of the chain is.
        let centerPosition = CGPoint(
            x: (point.x + 25),
            y: (point.y + 10))
        
        // Add a label for the score that slowly floats up.
        let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
        scoreLabel.fontSize = 28
        
        //this is for selecting molds
        if new == 0 {
            scoreLabel.fontColor = UIColor.white
        }
        
        //this signifies a new mold has been unlocked
        if new == 1 {
            scoreLabel.fontSize = 36
            scoreLabel.fontColor = UIColor(red: 195/255, green: 0, blue: 1, alpha: 1)
        }
        
        //this signifies a failed breed
        if new == 2 {
            scoreLabel.fontSize = 36
            scoreLabel.fontColor = UIColor.red
        }
        
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
