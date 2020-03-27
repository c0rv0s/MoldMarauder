//
//  BreedScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/5/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class BreedScene: SKScene {
    var mute = false
    
    //molds to combine
    var slimeButton: SKNode!
    var caveButton: SKNode!
    var sadButton: SKNode!
    var angryButton: SKNode!
    var alienButton: SKNode!
    var pimplyButton: SKNode!
    var freckledButton: SKNode!
    var hypnoButton: SKNode!
    var rainbowButton: SKNode!
    var aluminumButton: SKNode!
    var circuitButton: SKNode!
    var hologramButton: SKNode!
    var stormButton: SKNode!
    var bacteriaButton: SKNode!
    var virusButton: SKNode!
    var flowerButton: SKNode!
    var beeButton: SKNode!
    var xButton: SKNode!
    var disaffectedButton: SKNode!
    var oliveButton: SKNode!
    var coconutButton: SKNode!
    var sickButton: SKNode!
    var deadButton: SKNode!
    var zombieButton: SKNode!
    var rockButton: SKNode!
    var cloudButton: SKNode!
    var waterButton: SKNode!
    var crystalButton: SKNode!
    var nuclearButton: SKNode!
    var astronautButton: SKNode!
    var sandButton: SKNode!
    var glassButton: SKNode!
    var coffeeButton: SKNode!
    var slinkyButton: SKNode!
    var magmaButton: SKNode!
    var samuraiButton: SKNode!
    var orangeButton: SKNode!
    var strawberryButton: SKNode!
    var tshirtButton: SKNode!
    var cryptidButton: SKNode!
    var angelButton: SKNode!
    var invisibleButton: SKNode!
    
    //other things
    var backButton: SKNode!
    var useDiamondsButton: SKNode!
    var buyDiamondsButton: SKNode!
    var breedinstructions: SKNode!
    
    //diamond label
    var diamondLabel: SKLabelNode!
    
    var breedButton: SKNode!
    
    var touchHandler: ((String) -> ())?
    
    var selectedMolds: Array<Mold>! = []
    
    var unlockedMolds: Array<Mold>!
    var ownedMolds: Array<Mold> = []
    var possibleCombos: Array<Combo> = []
    var currentDiamondCombo: Combo!
    var numDiamonds = 0
    
    //to store last button postion to order buttons without blank space
    var lastButton : CGPoint!
    
    let gameLayer = SKNode()
    var cometLayer = CometLayer()
    var successLayer = SKNode()
    var tutorialLayer = SKNode()
    var bubbleLayer = SKNode()
    
    var center:  CGPoint!
    //scrollView
    var scrollView: SwiftySKScrollView?
    var page1ScrollView: SKSpriteNode!
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
    
    func reloadScroll() {
        self.removeAllChildren()
        scrollView?.removeFromSuperview()
        scrollView = nil
        
        background.start(size: size)
        addChild(background.background)
        addChild(cometLayer)
        
        moveableNode.removeAllChildren()
        createButton()
        nilButtons()
        erectScroll()
    }
    
    func erectScroll() {
        bubbleLayer.removeFromParent()
        let height = 100 + (ownedMolds.count * 95)
        //addNode
        addChild(moveableNode)
        //set up the scrollView
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), moveableNode: moveableNode, direction: .vertical)
        //scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: scrollView!.frame.height * CGFloat(pages)) // makes it 2 times the height
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: CGFloat(height))
        view?.addSubview(scrollView!)
        
        // Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
        moveableNode.addChild(page1ScrollView)
        
        //initialize these values, they get updated to be reused for each new button added
        var Texture = SKTexture(image: UIImage(named: "Slime Mold")!)
        lastButton = CGPoint(x: -75, y: 270)
        switch UIDevice().screenType {
        case .iPhone4:
            lastButton = CGPoint(x: -75, y: 240)
            break
        case .iPhone5:
            lastButton = CGPoint(x: -100, y: 250)
            break
        default:
            break
        }
        //add each mold to the scene exactly one time
        if ownedMolds.count > 0 {
            for mold in unlockedMolds {
                Texture = SKTexture(image: UIImage(named: mold.name)!)
                if mold.moldType == MoldType.slime && moldOwned(mold: MoldType.slime) {
                    slimeButton = SKSpriteNode(texture:Texture)
                    slimeButton.name = mold.name
                    slimeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = slimeButton.position
                    page1ScrollView.addChild(slimeButton)
                }
                if mold.moldType == MoldType.cave && moldOwned(mold: MoldType.cave) {
                    caveButton = SKSpriteNode(texture:Texture)
                    caveButton.name = mold.name
                    caveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = caveButton.position
                    page1ScrollView.addChild(caveButton)
                }
                if mold.moldType == MoldType.sad && moldOwned(mold: MoldType.sad) {
                    sadButton = SKSpriteNode(texture:Texture)
                    sadButton.name = mold.name
                    sadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = sadButton.position
                    page1ScrollView.addChild(sadButton)
                }
                if mold.moldType == MoldType.angry && moldOwned(mold: MoldType.angry) {
                    angryButton = SKSpriteNode(texture:Texture)
                    angryButton.name = mold.name
                    angryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = angryButton.position
                    page1ScrollView.addChild(angryButton)
                }
                if mold.moldType == MoldType.alien && moldOwned(mold: MoldType.alien) {
                    alienButton = SKSpriteNode(texture:Texture)
                    alienButton.name = mold.name
                    alienButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = alienButton.position
                    page1ScrollView.addChild(alienButton)
                }
                if mold.moldType == MoldType.freckled && moldOwned(mold: MoldType.freckled) {
                    freckledButton = SKSpriteNode(texture:Texture)
                    freckledButton.name = mold.name
                    freckledButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = freckledButton.position
                    page1ScrollView.addChild(freckledButton)
                }
                if mold.moldType == MoldType.hypno && moldOwned(mold: MoldType.hypno) {
                    hypnoButton = SKSpriteNode(texture:Texture)
                    hypnoButton.name = mold.name
                    hypnoButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = hypnoButton.position
                    page1ScrollView.addChild(hypnoButton)
                }
                if mold.moldType == MoldType.pimply && moldOwned(mold: MoldType.pimply) {
                    pimplyButton = SKSpriteNode(texture:Texture)
                    pimplyButton.name = mold.name
                    pimplyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = pimplyButton.position
                    page1ScrollView.addChild(pimplyButton)
                }
                if mold.moldType == MoldType.rainbow && moldOwned(mold: MoldType.rainbow) {
                    rainbowButton = SKSpriteNode(texture:Texture)
                    rainbowButton.name = mold.name
                    rainbowButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = rainbowButton.position
                    page1ScrollView.addChild(rainbowButton)
                }
                if mold.moldType == MoldType.aluminum && moldOwned(mold: MoldType.aluminum) {
                    aluminumButton = SKSpriteNode(texture:Texture)
                    aluminumButton.name = mold.name
                    aluminumButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = aluminumButton.position
                    page1ScrollView.addChild(aluminumButton)
                }
                if mold.moldType == MoldType.circuit && moldOwned(mold: MoldType.circuit) {
                    circuitButton = SKSpriteNode(texture:Texture)
                    circuitButton.name = mold.name
                    circuitButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = circuitButton.position
                    page1ScrollView.addChild(circuitButton)
                }
                if mold.moldType == MoldType.hologram && moldOwned(mold: MoldType.hologram) {
                    hologramButton = SKSpriteNode(texture:Texture)
                    hologramButton.name = mold.name
                    hologramButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = hologramButton.position
                    page1ScrollView.addChild(hologramButton)
                }
                if mold.moldType == MoldType.storm && moldOwned(mold: MoldType.storm) {
                    stormButton = SKSpriteNode(texture:Texture)
                    stormButton.name = mold.name
                    stormButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = stormButton.position
                    page1ScrollView.addChild(stormButton)
                }
                if mold.moldType == MoldType.bacteria && moldOwned(mold: MoldType.bacteria) {
                    bacteriaButton = SKSpriteNode(texture:Texture)
                    bacteriaButton.name = mold.name
                    bacteriaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = bacteriaButton.position
                    page1ScrollView.addChild(bacteriaButton)
                }
                if mold.moldType == MoldType.virus && moldOwned(mold: MoldType.virus) {
                    virusButton = SKSpriteNode(texture:Texture)
                    virusButton.name = mold.name
                    virusButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = virusButton.position
                    page1ScrollView.addChild(virusButton)
                }
                if mold.moldType == MoldType.flower && moldOwned(mold: MoldType.flower) {
                    flowerButton = SKSpriteNode(texture:Texture)
                    flowerButton.name = mold.name
                    flowerButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = flowerButton.position
                    page1ScrollView.addChild(flowerButton)
                }
                if mold.moldType == MoldType.bee && moldOwned(mold: MoldType.bee) {
                    beeButton = SKSpriteNode(texture:Texture)
                    beeButton.name = mold.name
                    beeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = beeButton.position
                    page1ScrollView.addChild(beeButton)
                }
                if mold.moldType == MoldType.x && moldOwned(mold: MoldType.x) {
                    xButton = SKSpriteNode(texture:Texture)
                    xButton.name = mold.name
                    xButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = xButton.position
                    page1ScrollView.addChild(xButton)
                }
                if mold.moldType == MoldType.disaffected && moldOwned(mold: MoldType.disaffected) {
                    disaffectedButton = SKSpriteNode(texture:Texture)
                    disaffectedButton.name = mold.name
                    disaffectedButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = disaffectedButton.position
                    page1ScrollView.addChild(disaffectedButton)
                }
                if mold.moldType == MoldType.olive && moldOwned(mold: MoldType.olive) {
                    oliveButton = SKSpriteNode(texture:Texture)
                    oliveButton.name = mold.name
                    oliveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = oliveButton.position
                    page1ScrollView.addChild(oliveButton)
                }
                if mold.moldType == MoldType.coconut && moldOwned(mold: MoldType.coconut) {
                    coconutButton = SKSpriteNode(texture:Texture)
                    coconutButton.name = mold.name
                    coconutButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = coconutButton.position
                    page1ScrollView.addChild(coconutButton)
                }
                if mold.moldType == MoldType.sick && moldOwned(mold: MoldType.sick) {
                    sickButton = SKSpriteNode(texture:Texture)
                    sickButton.name = mold.name
                    sickButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = sickButton.position
                    page1ScrollView.addChild(sickButton)
                }
                if mold.moldType == MoldType.dead && moldOwned(mold: MoldType.dead) {
                    deadButton = SKSpriteNode(texture:Texture)
                    deadButton.name = mold.name
                    deadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = deadButton.position
                    page1ScrollView.addChild(deadButton)
                }
                if mold.moldType == MoldType.zombie && moldOwned(mold: MoldType.zombie) {
                    zombieButton = SKSpriteNode(texture:Texture)
                    zombieButton.name = mold.name
                    zombieButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = zombieButton.position
                    page1ScrollView.addChild(zombieButton)
                }
                if mold.moldType == MoldType.rock && moldOwned(mold: MoldType.rock) {
                    rockButton = SKSpriteNode(texture:Texture)
                    rockButton.name = mold.name
                    rockButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = rockButton.position
                    page1ScrollView.addChild(rockButton)
                }
                if mold.moldType == MoldType.cloud && moldOwned(mold: MoldType.cloud) {
                    cloudButton = SKSpriteNode(texture:Texture)
                    cloudButton.name = mold.name
                    cloudButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = cloudButton.position
                    page1ScrollView.addChild(cloudButton)
                }
                if mold.moldType == MoldType.water && moldOwned(mold: MoldType.water) {
                    waterButton = SKSpriteNode(texture:Texture)
                    waterButton.name = mold.name
                    waterButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = waterButton.position
                    page1ScrollView.addChild(waterButton)
                }
                if mold.moldType == MoldType.crystal && moldOwned(mold: MoldType.crystal) {
                    crystalButton = SKSpriteNode(texture:Texture)
                    crystalButton.name = mold.name
                    crystalButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = crystalButton.position
                    page1ScrollView.addChild(crystalButton)
                }
                if mold.moldType == MoldType.nuclear && moldOwned(mold: MoldType.nuclear) {
                    nuclearButton = SKSpriteNode(texture:Texture)
                    nuclearButton.name = mold.name
                    nuclearButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = nuclearButton.position
                    page1ScrollView.addChild(nuclearButton)
                }
                if mold.moldType == MoldType.astronaut && moldOwned(mold: MoldType.astronaut) {
                    astronautButton = SKSpriteNode(texture:Texture)
                    astronautButton.name = mold.name
                    astronautButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = astronautButton.position
                    page1ScrollView.addChild(astronautButton)
                }
                if mold.moldType == MoldType.sand && moldOwned(mold: MoldType.sand) {
                    sandButton = SKSpriteNode(texture:Texture)
                    sandButton.name = mold.name
                    sandButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = sandButton.position
                    page1ScrollView.addChild(sandButton)
                }
                if mold.moldType == MoldType.glass && moldOwned(mold: MoldType.glass) {
                    glassButton = SKSpriteNode(texture:Texture)
                    glassButton.name = mold.name
                    glassButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = glassButton.position
                    page1ScrollView.addChild(glassButton)
                }
                if mold.moldType == MoldType.coffee && moldOwned(mold: MoldType.coffee) {
                    coffeeButton = SKSpriteNode(texture:Texture)
                    coffeeButton.name = mold.name
                    coffeeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = coffeeButton.position
                    page1ScrollView.addChild(coffeeButton)
                }
                if mold.moldType == MoldType.slinky && moldOwned(mold: MoldType.slinky) {
                    slinkyButton = SKSpriteNode(texture:Texture)
                    slinkyButton.name = mold.name
                    slinkyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = slinkyButton.position
                    page1ScrollView.addChild(slinkyButton)
                }
                if mold.moldType == MoldType.magma && moldOwned(mold: MoldType.magma) {
                    magmaButton = SKSpriteNode(texture:Texture)
                    magmaButton.name = mold.name
                    magmaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = magmaButton.position
                    page1ScrollView.addChild(magmaButton)
                }
                if mold.moldType == MoldType.samurai && moldOwned(mold: MoldType.samurai) {
                    samuraiButton = SKSpriteNode(texture:Texture)
                    samuraiButton.name = mold.name
                    samuraiButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = samuraiButton.position
                    page1ScrollView.addChild(samuraiButton)
                }
                if mold.moldType == MoldType.orange && moldOwned(mold: MoldType.orange) {
                    orangeButton = SKSpriteNode(texture:Texture)
                    orangeButton.name = mold.name
                    orangeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = orangeButton.position
                    page1ScrollView.addChild(orangeButton)
                }
                if mold.moldType == MoldType.strawberry && moldOwned(mold: MoldType.strawberry) {
                    strawberryButton = SKSpriteNode(texture:Texture)
                    strawberryButton.name = mold.name
                    strawberryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = strawberryButton.position
                    page1ScrollView.addChild(strawberryButton)
                }
                if mold.moldType == MoldType.tshirt && moldOwned(mold: MoldType.tshirt) {
                    tshirtButton = SKSpriteNode(texture:Texture)
                    tshirtButton.name = mold.name
                    tshirtButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = tshirtButton.position
                    page1ScrollView.addChild(tshirtButton)
                }
                if mold.moldType == MoldType.cryptid && moldOwned(mold: MoldType.cryptid) {
                    cryptidButton = SKSpriteNode(texture:Texture)
                    cryptidButton.name = mold.name
                    cryptidButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = cryptidButton.position
                    page1ScrollView.addChild(cryptidButton)
                }
                if mold.moldType == MoldType.angel && moldOwned(mold: MoldType.angel) {
                    angelButton = SKSpriteNode(texture:Texture)
                    angelButton.name = mold.name
                    angelButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = angelButton.position
                    page1ScrollView.addChild(angelButton)
                }
                if mold.moldType == MoldType.invisible && moldOwned(mold: MoldType.invisible) {
                    invisibleButton = SKSpriteNode(texture:Texture)
                    invisibleButton.name = mold.name
                    invisibleButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = invisibleButton.position
                    page1ScrollView.addChild(invisibleButton)
                }
            }
        }
        addChild(gameLayer)
        page1ScrollView.addChild(bubbleLayer)
        addChild(successLayer)
    }
    
    //quick check if the player owns the requested mold
    func moldOwned(mold: MoldType) -> Bool {
        for maybeMold in ownedMolds {
            if maybeMold.moldType == mold {
                return true
            }
        }
        return false
    }
    
    //used to reset the buttons so they can be reset after a mold dies
    func nilButtons() {
        slimeButton = nil
        caveButton = nil
        sadButton = nil
        angryButton = nil
        alienButton = nil
        pimplyButton = nil
        freckledButton = nil
        hypnoButton = nil
        rainbowButton = nil
        aluminumButton = nil
        circuitButton = nil
        hologramButton = nil
        stormButton = nil
        bacteriaButton = nil
        virusButton = nil
        flowerButton = nil
        beeButton = nil
        xButton = nil
        disaffectedButton = nil
        oliveButton = nil
        coconutButton = nil
        sickButton = nil
        deadButton = nil
        zombieButton = nil
        rockButton = nil
        cloudButton = nil
        waterButton = nil
        crystalButton = nil
        nuclearButton = nil
        astronautButton = nil
        sandButton = nil
        glassButton = nil
        coffeeButton = nil
        slinkyButton = nil
        magmaButton = nil
        samuraiButton = nil
        orangeButton = nil
        strawberryButton = nil
        tshirtButton = nil
        cryptidButton = nil
        angelButton = nil
        invisibleButton = nil
    }
    
    func createButton()
    {
        // BACK MENU
        var Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+190);
        
        self.addChild(backButton)
        
        //instruciotns
        Texture = SKTexture(image: UIImage(named: "breed instructions")!)
        breedinstructions = SKSpriteNode(texture:Texture)
        // Place in scene
        breedinstructions.position = CGPoint(x: self.frame.midX+120, y: self.frame.midY+100)
        lastButton = breedinstructions.position
        self.addChild(breedinstructions)
        
        // BREED
        Texture = SKTexture(image: UIImage(named: "breed action")!)
        breedButton = SKSpriteNode(texture:Texture)
        // Place in scene
        breedButton.position = CGPoint(x:self.frame.midX+120, y:self.frame.midY+10);
        
        self.addChild(breedButton)
        
        //USE DIAMONDS FOR UNLOCK
        Texture = SKTexture(image: UIImage(named: "diamond_breed")!)
        useDiamondsButton = SKSpriteNode(texture:Texture)
        // Place in scene
        useDiamondsButton.position = CGPoint(x:self.frame.midX+120, y:self.frame.midY-90);
        
        self.addChild(useDiamondsButton)
        
        //diamonds label
        if currentDiamondCombo != nil {
            numDiamonds = currentDiamondCombo.parents.count * 2
        }
        diamondLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel.fontSize = 24
        diamondLabel.fontColor = UIColor.black
        diamondLabel.text = String(numDiamonds)
        diamondLabel.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY-80);
        self.addChild(diamondLabel)
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            breedinstructions.setScale(0.8)
            breedButton.setScale(0.8)
            useDiamondsButton.setScale(0.8)
            diamondLabel.setScale(0.8)
            breedinstructions.position = CGPoint(x: self.frame.midX+110, y: self.frame.midY+100)
            breedButton.position = CGPoint(x:self.frame.midX+110, y:self.frame.midY+10)
            break
        case .iPhone5:
            //iPhone 5
            backButton.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+190)
            backButton.setScale(0.75)
            breedinstructions.setScale(0.8)
            breedButton.setScale(0.8)
            useDiamondsButton.setScale(0.8)
            diamondLabel.setScale(0.8)
            breedinstructions.position = CGPoint(x: self.frame.midX+110, y: self.frame.midY+100)
            breedButton.position = CGPoint(x:self.frame.midX+110, y:self.frame.midY+10)
            break
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if successLayer.children.count > 0 {
            successLayer.removeAllChildren()
            if let handler = touchHandler {
                handler("check tutorial progress")
            }
        }
        else {
            /* Called when a touch begins */
            for touch in touches {
                let location = touch.location(in: self)
                let nodeStack = nodes(at: location)
                if tutorialLayer.children.count > 0 {
                    if let handler = touchHandler {
                        handler("check tutorial progress")
                    }
                }
                
                if slimeButton != nil {
                    if nodeStack.contains(slimeButton)  {
                        if selectedMolds.contains(where: {$0.name == "Slime Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Slime Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(slimeButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.slime))
                            addBubble(point: slimeButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.slime.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if caveButton != nil {
                    if nodeStack.contains(caveButton) {
                        if selectedMolds.contains(where: {$0.name == "Cave Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Cave Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(caveButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.cave))
                            addBubble(point: caveButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.cave.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if sadButton != nil {
                    if nodeStack.contains(sadButton) {
                        if selectedMolds.contains(where: {$0.name == "Sad Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Sad Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(sadButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.sad))
                            addBubble(point: sadButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.sad.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if angryButton != nil {
                    if nodeStack.contains(angryButton) {
                        if selectedMolds.contains(where: {$0.name == "Angry Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Angry Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(angryButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.angry))
                            addBubble(point: angryButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.angry.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (alienButton) != nil {
                    if nodeStack.contains(alienButton) {
                        if selectedMolds.contains(where: {$0.name == "Alien Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Alien Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(alienButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.alien))
                            addBubble(point: alienButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.alien.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                
                if (pimplyButton) != nil {
                    if nodeStack.contains(pimplyButton) {
                        if selectedMolds.contains(where: {$0.name == "Pimply Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Pimply Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(pimplyButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.pimply))
                            addBubble(point: pimplyButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.pimply.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (freckledButton) != nil {
                    if nodeStack.contains(freckledButton) {
                        if selectedMolds.contains(where: {$0.name == "Freckled Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Freckled Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(freckledButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.freckled))
                            addBubble(point: freckledButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.freckled.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (hypnoButton) != nil {
                    if nodeStack.contains(hypnoButton) {
                        if selectedMolds.contains(where: {$0.name == "Hypno Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Hypno Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(hypnoButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.hypno))
                            addBubble(point: hypnoButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.hypno.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (rainbowButton) != nil {
                    if nodeStack.contains(rainbowButton) {
                        if selectedMolds.contains(where: {$0.name == "Rainbow Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Rainbow Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(rainbowButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.rainbow))
                            addBubble(point: rainbowButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.rainbow.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (aluminumButton) != nil {
                    if nodeStack.contains(aluminumButton) {
                        if selectedMolds.contains(where: {$0.name == "Aluminum Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Aluminum Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(aluminumButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.aluminum))
                            addBubble(point: aluminumButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.aluminum.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (circuitButton) != nil {
                    if nodeStack.contains(circuitButton) {
                        if selectedMolds.contains(where: {$0.name == "Circuit Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Circuit Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(circuitButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.circuit))
                            addBubble(point: circuitButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.circuit.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (hologramButton) != nil {
                    if nodeStack.contains(hologramButton) {
                        if selectedMolds.contains(where: {$0.name == "Hologram Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Hologram Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(hologramButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.hologram))
                            addBubble(point: hologramButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.hologram.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (stormButton) != nil {
                    if nodeStack.contains(stormButton) {
                        if selectedMolds.contains(where: {$0.name == "Storm Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Storm Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(stormButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.storm))
                            addBubble(point: stormButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.storm.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (bacteriaButton) != nil {
                    if nodeStack.contains(bacteriaButton) {
                        if selectedMolds.contains(where: {$0.name == "Bacteria Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Bacteria Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(bacteriaButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.bacteria))
                            addBubble(point: bacteriaButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.bacteria.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (virusButton) != nil {
                    if nodeStack.contains(virusButton) {
                        if selectedMolds.contains(where: {$0.name == "Virus Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Virus Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(virusButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.virus))
                            addBubble(point: virusButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.virus.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (flowerButton) != nil {
                    if nodeStack.contains(flowerButton) {
                        if selectedMolds.contains(where: {$0.name == "Flower Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Flower Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(flowerButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.flower))
                            addBubble(point: flowerButton.position, type: 1)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.flower.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (beeButton) != nil {
                    if nodeStack.contains(beeButton) {
                        if selectedMolds.contains(where: {$0.name == "Bee Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Bee Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(beeButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.bee))
                            addBubble(point: beeButton.position, type: 1)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.bee.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (xButton) != nil {
                    if nodeStack.contains(xButton) {
                        if selectedMolds.contains(where: {$0.name == "X Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "X Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(xButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.x))
                            addBubble(point: xButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.x.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (disaffectedButton) != nil {
                    if nodeStack.contains(disaffectedButton) {
                        if selectedMolds.contains(where: {$0.name == "Disaffected Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Disaffected Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(disaffectedButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.disaffected))
                            addBubble(point: disaffectedButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.disaffected.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (oliveButton) != nil {
                    if nodeStack.contains(oliveButton) {
                        if selectedMolds.contains(where: {$0.name == "Olive Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Olive Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(oliveButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.olive))
                            addBubble(point: oliveButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.olive.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (coconutButton) != nil {
                    if nodeStack.contains(coconutButton) {
                        if selectedMolds.contains(where: {$0.name == "Coconut Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Coconut Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(coconutButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.coconut))
                            addBubble(point: coconutButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.coconut.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (sickButton) != nil {
                    if nodeStack.contains(sickButton) {
                        if selectedMolds.contains(where: {$0.name == "Sick Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Sick Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(sickButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.sick))
                            addBubble(point: sickButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.sick.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (deadButton) != nil {
                    if nodeStack.contains(deadButton) {
                        if selectedMolds.contains(where: {$0.name == "Dead Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Dead Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(deadButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.dead))
                            addBubble(point: deadButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.dead.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (zombieButton) != nil {
                    if nodeStack.contains(zombieButton) {
                        if selectedMolds.contains(where: {$0.name == "Zombie Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Zombie Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(zombieButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.zombie))
                            addBubble(point: zombieButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.zombie.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (cloudButton) != nil {
                    if nodeStack.contains(cloudButton) {
                        if selectedMolds.contains(where: {$0.name == "Cloud Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Cloud Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(cloudButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.cloud))
                            addBubble(point: cloudButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.cloud.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (rockButton) != nil {
                    if nodeStack.contains(rockButton) {
                        if selectedMolds.contains(where: {$0.name == "Rock Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Rock Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(rockButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.rock))
                            addBubble(point: rockButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.rock.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (waterButton) != nil {
                    if nodeStack.contains(waterButton) {
                        if selectedMolds.contains(where: {$0.name == "Water Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Water Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(waterButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.water))
                            addBubble(point: waterButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.water.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (crystalButton) != nil {
                    if nodeStack.contains(crystalButton) {
                        if selectedMolds.contains(where: {$0.name == "Crystal Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Crystal Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(crystalButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.crystal))
                            addBubble(point: crystalButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.crystal.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (nuclearButton) != nil {
                    if nodeStack.contains(nuclearButton) {
                        if selectedMolds.contains(where: {$0.name == "Nuclear Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Nuclear Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(nuclearButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.nuclear))
                            addBubble(point: nuclearButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.nuclear.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (astronautButton) != nil {
                    if nodeStack.contains(astronautButton) {
                        if selectedMolds.contains(where: {$0.name == "Astronaut Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Astronaut Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(astronautButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.astronaut))
                            addBubble(point: astronautButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.astronaut.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (sandButton) != nil {
                    if nodeStack.contains(sandButton) {
                        if selectedMolds.contains(where: {$0.name == "Sand Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Sand Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(sandButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.sand))
                            addBubble(point: sandButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.sand.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (glassButton) != nil {
                    if nodeStack.contains(glassButton) {
                        if selectedMolds.contains(where: {$0.name == "Glass Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Glass Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(glassButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.glass))
                            addBubble(point: glassButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.glass.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (coffeeButton) != nil {
                    if nodeStack.contains(coffeeButton) {
                        if selectedMolds.contains(where: {$0.name == "Coffee Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Coffee Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(coffeeButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.coffee))
                            addBubble(point: coffeeButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.coffee.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (slinkyButton) != nil {
                    if nodeStack.contains(slinkyButton) {
                        if selectedMolds.contains(where: {$0.name == "Slinky Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Slinky Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(slinkyButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.slinky))
                            addBubble(point: slinkyButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.slinky.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (magmaButton) != nil {
                    if nodeStack.contains(magmaButton) {
                        if selectedMolds.contains(where: {$0.name == "Magma Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Magma Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(magmaButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.magma))
                            addBubble(point: magmaButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.magma.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (samuraiButton) != nil {
                    if nodeStack.contains(samuraiButton) {
                        if selectedMolds.contains(where: {$0.name == "Samurai Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Samurai Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(samuraiButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.samurai))
                            addBubble(point: samuraiButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.samurai.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (orangeButton) != nil {
                    if nodeStack.contains(orangeButton) {
                        if selectedMolds.contains(where: {$0.name == "Orange Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Orange Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(orangeButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.orange))
                            addBubble(point: orangeButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.orange.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (strawberryButton) != nil {
                    if nodeStack.contains(strawberryButton) {
                        if selectedMolds.contains(where: {$0.name == "Strawberry Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Strawberry Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(strawberryButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.strawberry))
                            addBubble(point: strawberryButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.strawberry.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (tshirtButton) != nil {
                    if nodeStack.contains(tshirtButton) {
                        if selectedMolds.contains(where: {$0.name == "TShirt Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "TShirt Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(tshirtButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.tshirt))
                            addBubble(point: tshirtButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.tshirt.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (cryptidButton) != nil {
                    if nodeStack.contains(cryptidButton) {
                        if selectedMolds.contains(where: {$0.name == "Cryptid Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Cryptid Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(cryptidButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.cryptid))
                            addBubble(point: cryptidButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.cryptid.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (angelButton) != nil {
                    if nodeStack.contains(angelButton) {
                        if selectedMolds.contains(where: {$0.name == "Angel Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Angel Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(angelButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.angel))
                            addBubble(point: angelButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.angel.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
                if (invisibleButton) != nil {
                    if nodeStack.contains(invisibleButton) {
                        if selectedMolds.contains(where: {$0.name == "Invisible Mold"}) {
                            selectedMolds = selectedMolds.filter {$0.name != "Invisible Mold"}
                            bubbleLayer.removeChildren(in: [bubbleLayer.atPoint(invisibleButton.position)])
                        }
                        else if selectedMolds.count < 5 {
                            selectedMolds.append(Mold(moldType: MoldType.invisible))
                            addBubble(point: invisibleButton.position, type: 0)
                        }
                        animateName(point: touch.location(in: gameLayer), name: MoldType.invisible.description, new: 0)
                        playSound(select: "select mold")
                    }
                }
            }
            //this is for resetting the diamond thing
            if selectedMolds.count > 0 {
                currentDiamondCombo = nil
                
                outerLoop: for combo in possibleCombos {
                    var same = 0
                    middleLoop: for parent in combo.parents {
                        innerLoop: for mold in selectedMolds {
                            if parent.moldType == mold.moldType {
                                same += 1
                            }
                            if same == selectedMolds.count {
                                currentDiamondCombo = combo
                                break innerLoop
                            }
                        }
                        if same == selectedMolds.count {
                            break middleLoop
                        }
                    }
                    if same == selectedMolds.count {
                        break outerLoop
                    }
                }
            }
            else {
                if possibleCombos.count > 0 {
                    currentDiamondCombo = possibleCombos[0]
                }
            }
            
            if currentDiamondCombo != nil {
                numDiamonds = (currentDiamondCombo.parents.count - selectedMolds.count) * 2
                diamondLabel.text = String(numDiamonds)
                if numDiamonds == 0 {
                    diamondLabel.fontColor = UIColor.green
                }
                else {
                    diamondLabel.fontColor = UIColor.black
                }
            }
            else {
                numDiamonds = 0
                diamondLabel.text = String(numDiamonds)
                diamondLabel.fontColor = UIColor.black
            }
            
            
            //for the rest of the buttons
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if backButton.contains(touchLocation) {
                print("back")
                if let handler = touchHandler {
                    scrollView?.removeFromSuperview()
                    handler("back")
                }
            }
            
            if buyDiamondsButton != nil {
                if buyDiamondsButton.contains(touchLocation) {
                    if let handler = touchHandler {
                        handler("addDiamonds")
                    }
                }
            }
            
            if useDiamondsButton.contains(touchLocation) {
                print("use le d")
                if let handler = touchHandler {
                    handler("diamonds")
                }
            }
            
            if breedButton.contains(touchLocation) {
                print("try to breed")
                if let handler = touchHandler {
                    handler("breed")
                }
            }
        }
    }
    
    func playSound(select: String) {
        if mute == false {
            switch select {
            case "levelup":
                run(levelUpSound)
            case "select mold":
                run(bubbleLowSound)
            case "awe":
                run(aweSound)
            case "buzzer":
                run(buzzerSound)
            case "loose":
                run(looseSound)
            case "select":
                run(selectSound)
            case "diamond pop":
                run(diamondPopSound)
            default:
                run(levelUpSound)
            }
        }
    }
    
    //MARK: - TUTORIAL
    func beginBreedTutorial() {
        self.addChild(tutorialLayer)
        let appear = SKAction.scale(to: 1.1, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY+75);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addTitle1()
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
    
    func addTitle1() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 12
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Welcome to the Breeding Chamber."
        welcomeTitle.position = CGPoint(x:self.frame.midX, y:self.frame.midY+90);
        tutorialLayer.addChild(welcomeTitle)
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 12
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "You'll unlock new species here"
        welcomeTitle2.position = CGPoint(x:self.frame.midX, y:self.frame.midY+60);
        tutorialLayer.addChild(welcomeTitle2)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addBox2()
        }
        
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func addBox2() {
        tutorialLayer.removeAllChildren()
        let appear = SKAction.scale(to: 1.1, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "tutorial square mid")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY-200);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addTitle2()
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
    
    func addTitle2() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 14
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Select the following molds:"
        welcomeTitle.position = CGPoint(x:self.frame.midX, y:self.frame.midY-155);
        tutorialLayer.addChild(welcomeTitle)
        
        var counter = 0
        var namePos = CGPoint(x:self.frame.midX, y:self.frame.midY-160)
        while (counter < possibleCombos[0].parents.count) {
            let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
            welcomeTitle2.fontSize = 14
            welcomeTitle2.fontColor = UIColor.black
            welcomeTitle2.text = possibleCombos[0].parents[counter].name
            welcomeTitle2.position = CGPoint(x:namePos.x, y:namePos.y-17)
            namePos = welcomeTitle2.position
            tutorialLayer.addChild(welcomeTitle2)
            counter += 1
        }
        
        
        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 14
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "Then tap \"Breed\""
        welcomeTitle3.position = CGPoint(x:self.frame.midX, y:self.frame.midY-270);
        tutorialLayer.addChild(welcomeTitle3)
        
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            break
        default:
            break
        }
    }
    
    func finalTut(){
        let appear = SKAction.scale(to: 1.1, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY+115);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addTitle3()
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
    
    func addTitle3() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 12
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Congrats, that's your first breed!"
        welcomeTitle.position = CGPoint(x:self.frame.midX, y:self.frame.midY+130);
        tutorialLayer.addChild(welcomeTitle)
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 12
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "Beware, failed breeds"
        welcomeTitle2.position = CGPoint(x:self.frame.midX, y:self.frame.midY+115);
        tutorialLayer.addChild(welcomeTitle2)
        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 12
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "will kill the molds involved"
        welcomeTitle3.position = CGPoint(x:self.frame.midX, y:self.frame.midY+100);
        tutorialLayer.addChild(welcomeTitle3)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addBox3()
        }
        
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            break
        default:
            break
        }
    }
    
    func addBox3(){
        let appear = SKAction.scale(to: 1.1, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addTitle4()
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
    
    func addTitle4() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 12
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "You can use diamonds"
        welcomeTitle.position = CGPoint(x:self.frame.midX, y:self.frame.midY+15);
        tutorialLayer.addChild(welcomeTitle)
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 12
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "to complete difficult breeds."
        welcomeTitle2.position = CGPoint(x:self.frame.midX, y:self.frame.midY-15);
        tutorialLayer.addChild(welcomeTitle2)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addBox4()
        }
        
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func addBox4(){
        let appear = SKAction.scale(to: 1.1, duration: 0.5)
        //this is the godo case
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY-115);
        introNode.setScale(0.0)
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addTitle5()
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
    
    func addTitle5() {
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 12
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "You're all set!"
        welcomeTitle.position = CGPoint(x:self.frame.midX, y:self.frame.midY-100);
        tutorialLayer.addChild(welcomeTitle)
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 12
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "Go amass your fortune!"
        welcomeTitle2.position = CGPoint(x:self.frame.midX, y:self.frame.midY-115);
        tutorialLayer.addChild(welcomeTitle2)
        
        let welcomeTitle3 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle3.fontSize = 12
        welcomeTitle3.fontColor = UIColor.black
        welcomeTitle3.text = "Tap to Continue"
        welcomeTitle3.position = CGPoint(x:self.frame.midX, y:self.frame.midY-130);
        tutorialLayer.addChild(welcomeTitle3)
        
        switch UIDevice().screenType {
        case .iPhone5:
            //iPhone 5
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle3.setScale(0.9)
            break
        default:
            break
        }
    }
    
    //MARK: - ANIMATIONS
    func addBubble(point: CGPoint, type: Int) {
        //shiny thing1
        var Texture = SKTexture(image: UIImage(named: "bubble 2")!)
        if type == 1 {
            Texture = SKTexture(image: UIImage(named: "bubble circle")!)
        }
        let bubble = SKSpriteNode(texture:Texture)
        // Place in scene
        bubble.position = point
        
        bubble.setScale(0.01)
        let appear = SKAction.scale(to: 1, duration: 0.12)
        let actionS = SKAction.sequence([appear])
        bubble.run(actionS)
        bubbleLayer.addChild(bubble)
    }
    
    func showNewBreed(breed: MoldType) {
        bubbleLayer.removeAllChildren()
        // grey
        var Texture = SKTexture(image: UIImage(named: "grey out")!)
        let greyOut = SKSpriteNode(texture:Texture)
        // Place in scene
        greyOut.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        successLayer.addChild(greyOut)
        
        //popup
        Texture = SKTexture(image: UIImage(named: "new mold popup")!)
        let popup = SKSpriteNode(texture:Texture)
        // Place in scene
        popup.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        
        let appear = SKAction.scale(to: 1, duration: 0.4)
        popup.setScale(0.01)
        //this is the godo case
        let action = SKAction.sequence([appear])
        popup.run(action)
        successLayer.addChild(popup)
        
        //shiny thing1
        Texture = SKTexture(image: UIImage(named: "shiny back thing")!)
        let shinyOne = SKSpriteNode(texture:Texture)
        // Place in scene
        shinyOne.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 40);
        
        shinyOne.setScale(0.01)
        let rotateL = SKAction.rotate(byAngle: 360, duration: 400)
        let actionS = SKAction.sequence([appear, rotateL])
        shinyOne.run(actionS)
        successLayer.addChild(shinyOne)
        
        //shiny thing2
        Texture = SKTexture(image: UIImage(named: "shiny back thing 2")!)
        let shinyTwo = SKSpriteNode(texture:Texture)
        // Place in scene
        shinyTwo.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 40);
        
        shinyTwo.setScale(0.01)
        //this is the godo case
        let rotateR = SKAction.rotate(byAngle: -360, duration: 400)
        let actionST = SKAction.sequence([appear, rotateR])
        shinyTwo.run(actionST)
        successLayer.addChild(shinyTwo)
        
        //mold pic
        Texture = SKTexture(image: UIImage(named: breed.description)!)
        let moldPic = SKSpriteNode(texture:Texture)
        // Place in scene
        moldPic.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 40);
        
        moldPic.setScale(0.01)
        let actionM = SKAction.sequence([appear])
        moldPic.run(actionM)
        successLayer.addChild(moldPic)
        
        
        
        let nameLabel = SKLabelNode(fontNamed: "Lemondrop")
        nameLabel.fontSize = 16
        nameLabel.fontColor = UIColor.black
        nameLabel.text = breed.description
        nameLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 110);
        nameLabel.setScale(0.01)
        nameLabel.run(actionM)
        successLayer.addChild(nameLabel)
        
        
    }
    
    func addBuyDiamondsButton() {
        let reappear = SKAction.scale(to: 1.3, duration: 0.2)
        let bounce1 = SKAction.scale(to: 0.8, duration: 0.1)
        let bounce2 = SKAction.scale(to: 1, duration: 0.1)
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
        
        //this signifies a new mold has been inlocked
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
