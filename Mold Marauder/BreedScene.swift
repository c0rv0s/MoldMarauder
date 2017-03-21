//
//  BreedScene.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/5/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class BreedScene: SKScene {
    
    //molds to combine
    var slimeButton: SKNode! = nil
    var caveButton: SKNode! = nil
    var sadButton: SKNode! = nil
    var angryButton: SKNode! = nil
    var alienButton: SKNode! = nil
    var pimplyButton: SKNode! = nil
    var freckledButton: SKNode! = nil
    var hypnoButton: SKNode! = nil
    var rainbowButton: SKNode! = nil
    var aluminumButton: SKNode! = nil
    var circuitButton: SKNode! = nil
    var hologramButton: SKNode! = nil
    var stormButton: SKNode! = nil
    var bacteriaButton: SKNode! = nil
    var virusButton: SKNode! = nil
    var flowerButton: SKNode! = nil
    var beeButton: SKNode! = nil
    var xButton: SKNode! = nil
    var disaffectedButton: SKNode! = nil
    var oliveButton: SKNode! = nil
    var coconutButton: SKNode! = nil
    var sickButton: SKNode! = nil
    var deadButton: SKNode! = nil
    var zombieButton: SKNode! = nil
    var rockButton: SKNode! = nil
    var cloudButton: SKNode! = nil
    var waterButton: SKNode! = nil
    var crystalButton: SKNode! = nil
    var nuclearButton: SKNode! = nil
    var astronautButton: SKNode! = nil
    var sandButton: SKNode! = nil
    var glassButton: SKNode! = nil
    var coffeeButton: SKNode! = nil
    var slinkyButton: SKNode! = nil
    var magmaButton: SKNode! = nil
    var samuraiButton: SKNode! = nil
    var orangeButton: SKNode! = nil
    var strawberryButton: SKNode! = nil
    var tshirtButton: SKNode! = nil
    var cryptidButton: SKNode! = nil
    var angelButton: SKNode! = nil
    var invisibleButton: SKNode! = nil
    
    //other things
    var backButton: SKNode! = nil
    var clearButton: SKNode! = nil
    var useDiamondsButton: SKNode! = nil
    var breedinstructions: SKNode! = nil
    
    //diamond label
    var diamondLabel: SKLabelNode! = nil
    
    var breedButton: SKNode! = nil
    
    var touchHandler: ((String) -> ())?
    
    var selectedMolds: Array<Mold>!
    
    var unlockedMolds: Array<Mold>!
    var ownedMolds: Array<Mold>!
    var possibleCombos: Array<Combo>!
    var currentDiamondCombo: Combo! = nil
    var numDiamonds = 0
    
    //to store last button postion to order buttons without blank space
    var lastButton : CGPoint!
    
    let gameLayer = SKNode()
    var cometLayer = SKNode()
    var successLayer = SKNode()
    
    var center:  CGPoint!
    //scrollView
    weak var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    
    //for background animations
    var backframes = [SKTexture]()
    let background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "cyber_menu_glow")!))
    //comet sprites
    var cometSprite: SKNode! = nil
    var cometSprite2: SKNode! = nil
    var cometTimer: Timer!
    
    let levelUpSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let bubbleLowSound = SKAction.playSoundFileNamed("bubble low.wav", waitForCompletion: false)
    let aweSound = SKAction.playSoundFileNamed("awe.wav", waitForCompletion: false)
    let buzzerSound = SKAction.playSoundFileNamed("buzzer.wav", waitForCompletion: false)
    let looseSound = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
    let selectSound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
    
    override init(size: CGSize) {
        super.init(size: size)
        
        selectedMolds = []
        ownedMolds = []
        possibleCombos = []
        
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
        
        let _ = SKLabelNode(fontNamed: "Lemondrop")
        
        center = CGPoint(x:self.frame.midX, y:self.frame.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        animateComets()
        cometTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(animateComets), userInfo: nil, repeats: true)
        
        createButton()
        erectScroll()
    }
    
    func reloadScroll() {
        
        self.removeAllChildren()
        
        scrollView?.removeFromSuperview()
        scrollView = nil
        
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
        
        moveableNode.removeAllChildren()
        createButton()
        nilButtons()
        erectScroll()
    }
    
    func erectScroll() {
        //let pages = ceil(Double(unlockedMolds.count) / 2.0)
        var count = 0
        if ownedMolds != nil {
            for mold in unlockedMolds {
                if moldOwned(mold: mold.moldType) {
                    count += 1
                }
            }
        }
        let height = count * 110
        //addNode
        addChild(moveableNode)
        //set up the scrollView
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), moveableNode: moveableNode, direction: .vertical)
        //scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: scrollView!.frame.height * CGFloat(pages)) // makes it 2 times the height
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: CGFloat(height))
        view?.addSubview(scrollView!)
        
        // Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        let page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
        moveableNode.addChild(page1ScrollView)

        //initialize these values, they get updated to be reused for each new button added
        var Texture = SKTexture(image: UIImage(named: "Slime Mold")!)
        lastButton = CGPoint(x: -75, y: 270)
        
        //add each mold to the scene exactly one time
        if ownedMolds != nil {
            for mold in unlockedMolds {
                if mold.moldType == MoldType.slime && moldOwned(mold: MoldType.slime) {
                    Texture = SKTexture(image: UIImage(named: "Slime Mold")!)
                    // slime
                    slimeButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    slimeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = slimeButton.position
                    page1ScrollView.addChild(slimeButton)
                    
                }
                if mold.moldType == MoldType.cave && moldOwned(mold: MoldType.cave) {
                    // cave
                    Texture = SKTexture(image: UIImage(named: "Cave Mold")!)
                    caveButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    caveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = caveButton.position
                    page1ScrollView.addChild(caveButton)
                }
                
                if mold.moldType == MoldType.sad && moldOwned(mold: MoldType.sad) {
                    // sad
                    Texture = SKTexture(image: UIImage(named: "Sad Mold")!)
                    sadButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    sadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = sadButton.position
                    page1ScrollView.addChild(sadButton)
                }
                
                if mold.moldType == MoldType.angry && moldOwned(mold: MoldType.angry) {
                    //angry
                    Texture = SKTexture(image: UIImage(named: "Angry Mold")!)
                    angryButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    angryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = angryButton.position
                    page1ScrollView.addChild(angryButton)
                }
                
                if mold.moldType == MoldType.alien && moldOwned(mold: MoldType.alien) {
                    //alien
                    Texture = SKTexture(image: UIImage(named: "Alien Mold")!)
                    alienButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    alienButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = alienButton.position
                    page1ScrollView.addChild(alienButton)
                }
                if mold.moldType == MoldType.freckled && moldOwned(mold: MoldType.freckled) {
                    //freckled
                    Texture = SKTexture(image: UIImage(named: "Freckled Mold")!)
                    freckledButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    freckledButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = freckledButton.position
                    page1ScrollView.addChild(freckledButton)
                }
                if mold.moldType == MoldType.hypno && moldOwned(mold: MoldType.hypno) {
                    Texture = SKTexture(image: UIImage(named: "Hypno Mold")!)
                    hypnoButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    hypnoButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = hypnoButton.position
                    page1ScrollView.addChild(hypnoButton)
                }
                if mold.moldType == MoldType.pimply && moldOwned(mold: MoldType.pimply) {
                    Texture = SKTexture(image: UIImage(named: "Pimply Mold")!)
                    pimplyButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    pimplyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = pimplyButton.position
                    page1ScrollView.addChild(pimplyButton)
                }
                if mold.moldType == MoldType.rainbow && moldOwned(mold: MoldType.rainbow) {
                    Texture = SKTexture(image: UIImage(named: "Rainbow Mold")!)
                    rainbowButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    rainbowButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = rainbowButton.position
                    page1ScrollView.addChild(rainbowButton)
                }
                if mold.moldType == MoldType.aluminum && moldOwned(mold: MoldType.aluminum) {
                    Texture = SKTexture(image: UIImage(named: "Aluminum Mold")!)
                    aluminumButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    aluminumButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = aluminumButton.position
                    page1ScrollView.addChild(aluminumButton)
                }
                if mold.moldType == MoldType.circuit && moldOwned(mold: MoldType.circuit) {
                    Texture = SKTexture(image: UIImage(named: "Circuit Mold")!)
                    circuitButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    circuitButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = circuitButton.position
                    page1ScrollView.addChild(circuitButton)
                }
                if mold.moldType == MoldType.hologram && moldOwned(mold: MoldType.hologram) {
                    Texture = SKTexture(image: UIImage(named: "Hologram Mold")!)
                    hologramButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    hologramButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = hologramButton.position
                    page1ScrollView.addChild(hologramButton)
                }
                if mold.moldType == MoldType.storm && moldOwned(mold: MoldType.storm) {
                    Texture = SKTexture(image: UIImage(named: "Storm Mold")!)
                    stormButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    stormButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = stormButton.position
                    page1ScrollView.addChild(stormButton)
                }
                if mold.moldType == MoldType.bacteria && moldOwned(mold: MoldType.bacteria) {
                    Texture = SKTexture(image: UIImage(named: "Bacteria Mold")!)
                    bacteriaButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    bacteriaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = bacteriaButton.position
                    page1ScrollView.addChild(bacteriaButton)
                }
                if mold.moldType == MoldType.virus && moldOwned(mold: MoldType.virus) {
                    Texture = SKTexture(image: UIImage(named: "Virus Mold")!)
                    virusButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    virusButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = virusButton.position
                    page1ScrollView.addChild(virusButton)
                }
                if mold.moldType == MoldType.flower && moldOwned(mold: MoldType.flower) {
                    Texture = SKTexture(image: UIImage(named: "Flower Mold")!)
                    flowerButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    flowerButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = flowerButton.position
                    page1ScrollView.addChild(flowerButton)
                }
                if mold.moldType == MoldType.bee && moldOwned(mold: MoldType.bee) {
                    Texture = SKTexture(image: UIImage(named: "Bee Mold")!)
                    beeButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    beeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = beeButton.position
                    page1ScrollView.addChild(beeButton)
                }
                if mold.moldType == MoldType.x && moldOwned(mold: MoldType.x) {
                    Texture = SKTexture(image: UIImage(named: "X Mold")!)
                    xButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    xButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = xButton.position
                    page1ScrollView.addChild(xButton)
                }
                if mold.moldType == MoldType.disaffected && moldOwned(mold: MoldType.disaffected) {
                    Texture = SKTexture(image: UIImage(named: "Disaffected Mold")!)
                    disaffectedButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    disaffectedButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = disaffectedButton.position
                    page1ScrollView.addChild(disaffectedButton)
                }
                if mold.moldType == MoldType.olive && moldOwned(mold: MoldType.olive) {
                    Texture = SKTexture(image: UIImage(named: "Olive Mold")!)
                    oliveButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    oliveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = oliveButton.position
                    page1ScrollView.addChild(oliveButton)
                }
                if mold.moldType == MoldType.coconut && moldOwned(mold: MoldType.coconut) {
                    Texture = SKTexture(image: UIImage(named: "Coconut Mold")!)
                    coconutButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    coconutButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = coconutButton.position
                    page1ScrollView.addChild(coconutButton)
                }
                if mold.moldType == MoldType.sick && moldOwned(mold: MoldType.sick) {
                    Texture = SKTexture(image: UIImage(named: "Sick Mold")!)
                    sickButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    sickButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = sickButton.position
                    page1ScrollView.addChild(sickButton)
                }
                if mold.moldType == MoldType.dead && moldOwned(mold: MoldType.dead) {
                    Texture = SKTexture(image: UIImage(named: "Dead Mold")!)
                    deadButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    deadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = deadButton.position
                    page1ScrollView.addChild(deadButton)
                }
                if mold.moldType == MoldType.zombie && moldOwned(mold: MoldType.zombie) {
                    Texture = SKTexture(image: UIImage(named: "Zombie Mold")!)
                    zombieButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    zombieButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = zombieButton.position
                    page1ScrollView.addChild(zombieButton)
                }
                if mold.moldType == MoldType.rock && moldOwned(mold: MoldType.rock) {
                    Texture = SKTexture(image: UIImage(named: "Rock Mold")!)
                    rockButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    rockButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = rockButton.position
                    page1ScrollView.addChild(rockButton)
                }
                if mold.moldType == MoldType.cloud && moldOwned(mold: MoldType.cloud) {
                    Texture = SKTexture(image: UIImage(named: "Cloud Mold")!)
                    cloudButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    cloudButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = cloudButton.position
                    page1ScrollView.addChild(cloudButton)
                }
                if mold.moldType == MoldType.water && moldOwned(mold: MoldType.water) {
                    Texture = SKTexture(image: UIImage(named: "Water Mold")!)
                    waterButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    waterButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = waterButton.position
                    page1ScrollView.addChild(waterButton)
                }
                if mold.moldType == MoldType.crystal && moldOwned(mold: MoldType.crystal) {
                    Texture = SKTexture(image: UIImage(named: "Crystal Mold")!)
                    crystalButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    crystalButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = crystalButton.position
                    page1ScrollView.addChild(crystalButton)
                }
                if mold.moldType == MoldType.nuclear && moldOwned(mold: MoldType.nuclear) {
                    Texture = SKTexture(image: UIImage(named: "Nuclear Mold")!)
                    nuclearButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    nuclearButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = nuclearButton.position
                    page1ScrollView.addChild(nuclearButton)
                }
                if mold.moldType == MoldType.astronaut && moldOwned(mold: MoldType.astronaut) {
                    Texture = SKTexture(image: UIImage(named: "Astronaut Mold")!)
                    astronautButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    astronautButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = astronautButton.position
                    page1ScrollView.addChild(astronautButton)
                }
                if mold.moldType == MoldType.sand && moldOwned(mold: MoldType.sand) {
                    Texture = SKTexture(image: UIImage(named: "Sand Mold")!)
                    sandButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    sandButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = sandButton.position
                    page1ScrollView.addChild(sandButton)
                }
                if mold.moldType == MoldType.glass && moldOwned(mold: MoldType.glass) {
                    Texture = SKTexture(image: UIImage(named: "Glass Mold")!)
                    glassButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    glassButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = glassButton.position
                    page1ScrollView.addChild(glassButton)
                }
                if mold.moldType == MoldType.coffee && moldOwned(mold: MoldType.coffee) {
                    Texture = SKTexture(image: UIImage(named: "Coffee Mold")!)
                    coffeeButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    coffeeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = coffeeButton.position
                    page1ScrollView.addChild(coffeeButton)
                }
                if mold.moldType == MoldType.slinky && moldOwned(mold: MoldType.slinky) {
                    Texture = SKTexture(image: UIImage(named: "Slinky Mold")!)
                    slinkyButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    slinkyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = slinkyButton.position
                    page1ScrollView.addChild(slinkyButton)
                }
                if mold.moldType == MoldType.magma && moldOwned(mold: MoldType.magma) {
                    Texture = SKTexture(image: UIImage(named: "Magma Mold")!)
                    magmaButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    magmaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = magmaButton.position
                    page1ScrollView.addChild(magmaButton)
                }
                if mold.moldType == MoldType.samurai && moldOwned(mold: MoldType.samurai) {
                    Texture = SKTexture(image: UIImage(named: "Samurai Mold")!)
                    samuraiButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    samuraiButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = samuraiButton.position
                    page1ScrollView.addChild(samuraiButton)
                }
                if mold.moldType == MoldType.orange && moldOwned(mold: MoldType.orange) {
                    Texture = SKTexture(image: UIImage(named: "Orange Mold")!)
                    orangeButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    orangeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = orangeButton.position
                    page1ScrollView.addChild(orangeButton)
                }
                if mold.moldType == MoldType.strawberry && moldOwned(mold: MoldType.strawberry) {
                    Texture = SKTexture(image: UIImage(named: "Strawberry Mold")!)
                    strawberryButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    strawberryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = strawberryButton.position
                    page1ScrollView.addChild(strawberryButton)
                }
                if mold.moldType == MoldType.tshirt && moldOwned(mold: MoldType.tshirt) {
                    Texture = SKTexture(image: UIImage(named: "TShirt Mold")!)
                    tshirtButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    tshirtButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = tshirtButton.position
                    page1ScrollView.addChild(tshirtButton)
                }
                if mold.moldType == MoldType.cryptid && moldOwned(mold: MoldType.cryptid) {
                    Texture = SKTexture(image: UIImage(named: "Cryptid Mold")!)
                    cryptidButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    cryptidButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = cryptidButton.position
                    page1ScrollView.addChild(cryptidButton)
                }
                if mold.moldType == MoldType.angel && moldOwned(mold: MoldType.angel) {
                    Texture = SKTexture(image: UIImage(named: "Angel Mold")!)
                    angelButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    angelButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = angelButton.position
                    page1ScrollView.addChild(angelButton)
                }
                if mold.moldType == MoldType.invisible && moldOwned(mold: MoldType.invisible) {
                    Texture = SKTexture(image: UIImage(named: "Invisible Mold")!)
                    invisibleButton = SKSpriteNode(texture:Texture)
                    // Place in scene
                    invisibleButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                    lastButton = invisibleButton.position
                    page1ScrollView.addChild(invisibleButton)
                }
            }
        }
        addChild(gameLayer)
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
        useDiamondsButton.position = CGPoint(x:self.frame.midX+120, y:self.frame.midY-65);
        
        self.addChild(useDiamondsButton)
        
        //diamonds label
        if currentDiamondCombo != nil {
            numDiamonds = currentDiamondCombo.parents.count * 2
        }
        diamondLabel = SKLabelNode(fontNamed: "Lemondrop")
        diamondLabel.fontSize = 24
        diamondLabel.fontColor = UIColor.black
        diamondLabel.text = String(numDiamonds)
        diamondLabel.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY-75);
        self.addChild(diamondLabel)
        
        // CLEAR
        Texture = SKTexture(image: UIImage(named: "clear selection")!)
        clearButton = SKSpriteNode(texture:Texture)
        // Place in scene
        clearButton.position = CGPoint(x:self.frame.midX+120, y:self.frame.midY-130);
        
        self.addChild(clearButton)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if successLayer.children.count > 0 {
            successLayer.removeAllChildren()
        }
        else {
        /* Called when a touch begins */
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            //check if touch was one of the mold buttons
            if slimeButton != nil {
                if node == slimeButton {
                    selectedMolds.append(Mold(moldType: MoldType.slime))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.slime.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if caveButton != nil {
                if node == caveButton {
                    selectedMolds.append(Mold(moldType: MoldType.cave))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.cave.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if sadButton != nil {
                if node == sadButton {
                    selectedMolds.append(Mold(moldType: MoldType.sad))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.sad.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if angryButton != nil {
                if node == angryButton {
                    selectedMolds.append(Mold(moldType: MoldType.angry))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.angry.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (alienButton) != nil {
                if node == alienButton {
                    selectedMolds.append(Mold(moldType: MoldType.alien))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.alien.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            
            if (pimplyButton) != nil {
                if node == pimplyButton {
                    selectedMolds.append(Mold(moldType: MoldType.pimply))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.pimply.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (freckledButton) != nil {
                if node == freckledButton {
                    selectedMolds.append(Mold(moldType: MoldType.freckled))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.freckled.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (hypnoButton) != nil {
                if node == hypnoButton {
                    selectedMolds.append(Mold(moldType: MoldType.hypno))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.hypno.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (rainbowButton) != nil {
                if node == rainbowButton {
                    selectedMolds.append(Mold(moldType: MoldType.rainbow))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.rainbow.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (aluminumButton) != nil {
                if node == aluminumButton {
                    selectedMolds.append(Mold(moldType: MoldType.aluminum))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.aluminum.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (circuitButton) != nil {
                if node == circuitButton {
                    selectedMolds.append(Mold(moldType: MoldType.circuit))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.circuit.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (hologramButton) != nil {
                if node == hologramButton {
                    selectedMolds.append(Mold(moldType: MoldType.hologram))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.hologram.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (stormButton) != nil {
                if node == stormButton {
                    selectedMolds.append(Mold(moldType: MoldType.storm))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.storm.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (bacteriaButton) != nil {
                if node == bacteriaButton {
                    selectedMolds.append(Mold(moldType: MoldType.bacteria))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.bacteria.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (virusButton) != nil {
                if node == virusButton {
                    selectedMolds.append(Mold(moldType: MoldType.virus))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.virus.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (flowerButton) != nil {
                if node == flowerButton {
                    selectedMolds.append(Mold(moldType: MoldType.flower))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.flower.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (beeButton) != nil {
                if node == beeButton {
                    selectedMolds.append(Mold(moldType: MoldType.bee))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.bee.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (xButton) != nil {
                if node == xButton {
                    selectedMolds.append(Mold(moldType: MoldType.x))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.x.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (disaffectedButton) != nil {
                if node == disaffectedButton {
                    selectedMolds.append(Mold(moldType: MoldType.disaffected))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.disaffected.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (oliveButton) != nil {
                if node == oliveButton {
                    selectedMolds.append(Mold(moldType: MoldType.olive))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.olive.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (coconutButton) != nil {
                if node == coconutButton {
                    selectedMolds.append(Mold(moldType: MoldType.coconut))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.coconut.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (sickButton) != nil {
                if node == sickButton {
                    selectedMolds.append(Mold(moldType: MoldType.sick))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.sick.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (deadButton) != nil {
                if node == deadButton {
                    selectedMolds.append(Mold(moldType: MoldType.dead))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.dead.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (zombieButton) != nil {
                if node == zombieButton {
                    selectedMolds.append(Mold(moldType: MoldType.zombie))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.zombie.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (cloudButton) != nil {
                if node == cloudButton {
                    selectedMolds.append(Mold(moldType: MoldType.cloud))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.cloud.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (rockButton) != nil {
                if node == rockButton {
                    selectedMolds.append(Mold(moldType: MoldType.rock))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.rock.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (waterButton) != nil {
                if node == waterButton {
                    selectedMolds.append(Mold(moldType: MoldType.water))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.water.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (crystalButton) != nil {
                if node == crystalButton {
                    selectedMolds.append(Mold(moldType: MoldType.crystal))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.crystal.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (nuclearButton) != nil {
                if node == nuclearButton {
                    selectedMolds.append(Mold(moldType: MoldType.nuclear))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.nuclear.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (astronautButton) != nil {
                if node == astronautButton {
                    selectedMolds.append(Mold(moldType: MoldType.astronaut))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.astronaut.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (sandButton) != nil {
                if node == sandButton {
                    selectedMolds.append(Mold(moldType: MoldType.sand))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.sand.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (glassButton) != nil {
                if node == glassButton {
                    selectedMolds.append(Mold(moldType: MoldType.glass))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.glass.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (coffeeButton) != nil {
                if node == coffeeButton {
                    selectedMolds.append(Mold(moldType: MoldType.coffee))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.coffee.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (slinkyButton) != nil {
                if node == slinkyButton {
                    selectedMolds.append(Mold(moldType: MoldType.slinky))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.slinky.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (magmaButton) != nil {
                if node == magmaButton {
                    selectedMolds.append(Mold(moldType: MoldType.magma))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.magma.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (samuraiButton) != nil {
                if node == samuraiButton {
                    selectedMolds.append(Mold(moldType: MoldType.samurai))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.samurai.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (orangeButton) != nil {
                if node == orangeButton {
                    selectedMolds.append(Mold(moldType: MoldType.orange))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.orange.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (strawberryButton) != nil {
                if node == strawberryButton {
                    selectedMolds.append(Mold(moldType: MoldType.strawberry))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.strawberry.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (tshirtButton) != nil {
                if node == tshirtButton {
                    selectedMolds.append(Mold(moldType: MoldType.tshirt))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.tshirt.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (cryptidButton) != nil {
                if node == cryptidButton {
                    selectedMolds.append(Mold(moldType: MoldType.cryptid))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.cryptid.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (angelButton) != nil {
                if node == angelButton {
                    selectedMolds.append(Mold(moldType: MoldType.angel))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.angel.description, new: 0)
                    playSound(select: "select mold")
                }
            }
            if (invisibleButton) != nil {
                if node == angelButton {
                    selectedMolds.append(Mold(moldType: MoldType.invisible))
                    animateName(point: touch.location(in: gameLayer), name: MoldType.angel.description, new: 0)
                    playSound(select: "select mold")
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
                //update labels
                if currentDiamondCombo != nil {
                    numDiamonds = (currentDiamondCombo.parents.count - selectedMolds.count) * 2
                    diamondLabel.text = String(numDiamonds)
                    if numDiamonds == 0 {
                        diamondLabel.fontColor = UIColor.green
                    }
                }
                else if currentDiamondCombo == nil {
                    numDiamonds = 0
                    diamondLabel.text = String(numDiamonds)
                    diamondLabel.fontColor = UIColor.black
                    
                }
            }
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
        
        if useDiamondsButton.contains(touchLocation) {
            print("use le d")
            if let handler = touchHandler {
                handler("diamonds")
            }
        }
        
        if clearButton.contains(touchLocation) {
            print("clear")
            //selectedMolds = []
            if possibleCombos.count > 0 {
                currentDiamondCombo = possibleCombos[0]
            }
            
            numDiamonds = currentDiamondCombo.parents.count * 2
            diamondLabel.text = String(numDiamonds)
            if let handler = touchHandler {
                handler("clear")
            }
        }
        
        if breedButton.contains(touchLocation) {
            print("try to breed")
            if let orgy = selectedMolds {
                for mold in orgy {
                    print(mold.name)
                }
            }
            if let handler = touchHandler {
                handler("breed")
            }
        }
        }
    }
    
    func playSound(select: String) {
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
        default:
            run(levelUpSound)
        }
    }
    
    func showNewBreed(breed: MoldType) {
        // grey
        var Texture = SKTexture(image: UIImage(named: "grey out")!)
        var greyOut = SKSpriteNode(texture:Texture)
        // Place in scene
        greyOut.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        successLayer.addChild(greyOut)
        
        //popup
        Texture = SKTexture(image: UIImage(named: "new mold popup")!)
        var popup = SKSpriteNode(texture:Texture)
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
        var shinyOne = SKSpriteNode(texture:Texture)
        // Place in scene
        shinyOne.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 40);
        
        shinyOne.setScale(0.01)
        //this is the godo case
        let rotateL = SKAction.rotate(byAngle: 360, duration: 30)
        let actionS = SKAction.sequence([appear, rotateL])
        shinyOne.run(actionS)
        successLayer.addChild(shinyOne)
        
        //shiny thing2
        Texture = SKTexture(image: UIImage(named: "shiny back thing 2")!)
        var shinyTwo = SKSpriteNode(texture:Texture)
        // Place in scene
        shinyTwo.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 40);
        
        shinyTwo.setScale(0.01)
        //this is the godo case
        let rotateR = SKAction.rotate(byAngle: -360, duration: 30)
        let actionST = SKAction.sequence([appear, rotateR])
        shinyTwo.run(actionST)
        successLayer.addChild(shinyTwo)
        
        //mold pic
        Texture = SKTexture(image: UIImage(named: breed.description)!)
        var moldPic = SKSpriteNode(texture:Texture)
        // Place in scene
        moldPic.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 40);
        
        moldPic.setScale(0.01)
        //this is the godo case
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
    
    func animateName(point: CGPoint,name: String, new: Int) {
        // Figure out what the midpoint of the chain is.
        let centerPosition = CGPoint(
            x: (point.x),
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
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
}
