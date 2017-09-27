//
//  Mold Shop.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/5/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import SpriteKit
class MoldShop: SKScene {
    var mute = false
    
    var backButton: SKNode! = nil
    
    //molds to buy
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
    var cloudButton: SKNode! = nil
    var rockButton: SKNode! = nil
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
    
    var page1ScrollView: SKNode!
    
    var unlockedMolds: Array<Mold>!
    var blockedMolds: Array<Mold>!
    var maxTex = SKTexture(image: UIImage(named: "max label")!)
    //scrollView
    weak var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    
    //for loading buttons without blank space
    var lastButton : CGPoint!
    
    let gameLayer = SKNode()
    var point = CGPoint()
    
    var cometLayer = SKNode()
    
    var tutorialLayer = SKNode()
    
//    update current pps
    var levDicc: [String:Int]!
    //    level molds
    //    after 400 just go by every 50 after that
    let moldLevCounts = [10,20,40,65,90,125,165,210,265,320,370,425]
    
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
    let selectSound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
    let buzzerSound = SKAction.playSoundFileNamed("buzzer.wav", waitForCompletion: false)
    
    override init(size: CGSize) {
        super.init(size: size)
        blockedMolds = []
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
        
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        animateComets()
        cometTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(animateComets), userInfo: nil, repeats: true)
        erectScroll()
    }
    
    func ppsAmount(mold: MoldType) -> BInt {
        //                check level to see how much more to add
        let hearts = levDicc[mold.spriteName]!
        var levs = 0
        if hearts < 426 {
            for num in moldLevCounts {
                if hearts > num {
                    levs += 1
                }
            }
        }
        else {
            levs = moldLevCounts.count
            levs += ((hearts - 425) / 100)
        }
        
        return (levs*mold.pointsPerSecond/5) + mold.pointsPerSecond
    }
    
    func erectScroll() {
        //let height = ceil(Double(unlockedMolds.count) * 250)
        let height = 42 * 95
        createButton()
        //addNode
        addChild(moveableNode)
        //set up the scrollView
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), moveableNode: moveableNode, direction: .vertical)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: CGFloat(height)) // makes it 2 times the height
        view?.addSubview(scrollView!)
        
        // Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
        guard let scrollView = scrollView else { return } // unwrap  optional
        
        page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
        moveableNode.addChild(page1ScrollView)
        
        //add each button for the individual molds with their lables
        //holy cow there has got to be a better way to do this
        // slime
        var Texture = SKTexture(image: UIImage(named: "Slime Mold")!)
        slimeButton = SKSpriteNode(texture:Texture)
        // Place in scene
        slimeButton.position = CGPoint(x: -100, y: 180)
        switch UIDevice().screenType {
        case .iPhone4:
            slimeButton.position = CGPoint(x: -100, y: 150)
            break
        case .iPhone5:
            slimeButton.position = CGPoint(x: -100, y: 160)
            break
        default:
            break
        }
        var priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        var ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
        var pointsPrice = MoldType.slime.price
        
        
        lastButton = slimeButton.position
        page1ScrollView.addChild(slimeButton)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        for unlocked in unlockedMolds {
            if unlocked.moldType == MoldType.slime {
                pointsPrice = unlocked.price
                break
            }
        }
        priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
        priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
        priceLabel.color = UIColor.black
        page1ScrollView.addChild(priceLabel)
        ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
        ppsLabel.fontSize = 20
        ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.slime))
        ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
        page1ScrollView.addChild(ppsLabel)
        priceLabel.fontColor = UIColor.black
        ppsLabel.fontColor = UIColor.black
        if containsMold(array: blockedMolds, mold: MoldType.slime) {
            let maxLabel = SKSpriteNode(texture: maxTex)
            maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
            page1ScrollView.addChild(maxLabel)
        }
        
        // cave
        Texture = SKTexture(image: UIImage(named: "Cave Mold")!)
        caveButton = SKSpriteNode(texture:Texture)
        // Place in scene
        caveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
        lastButton = caveButton.position
        page1ScrollView.addChild(caveButton)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        for unlocked in unlockedMolds {
            if unlocked.moldType == MoldType.cave {
                pointsPrice = unlocked.price
                break
            }
        }
        priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
        priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
        page1ScrollView.addChild(priceLabel)
        ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
        ppsLabel.fontSize = 20
        ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.cave))
        ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
        page1ScrollView.addChild(ppsLabel)
        priceLabel.fontColor = UIColor.black
        ppsLabel.fontColor = UIColor.black
        if containsMold(array: blockedMolds, mold: MoldType.cave) {
            let maxLabel = SKSpriteNode(texture: maxTex)
            maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
            page1ScrollView.addChild(maxLabel)
        }
        
        // sad
        Texture = SKTexture(image: UIImage(named: "Sad Mold")!)
        sadButton = SKSpriteNode(texture:Texture)
        // Place in scene
        sadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
        lastButton = sadButton.position
        page1ScrollView.addChild(sadButton)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        for unlocked in unlockedMolds {
            if unlocked.moldType == MoldType.sad {
                pointsPrice = unlocked.price
                break
            }
        }
        priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
        priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
        page1ScrollView.addChild(priceLabel)
        ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
        ppsLabel.fontSize = 20
        ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.sad))
        ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
        page1ScrollView.addChild(ppsLabel)
        priceLabel.fontColor = UIColor.black
        ppsLabel.fontColor = UIColor.black
        if containsMold(array: blockedMolds, mold: MoldType.sad) {
            let maxLabel = SKSpriteNode(texture: maxTex)
            maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
            page1ScrollView.addChild(maxLabel)
        }
    
        
        // angry
        Texture = SKTexture(image: UIImage(named: "Angry Mold")!)
        angryButton = SKSpriteNode(texture:Texture)
        // Place in scene
        angryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
        lastButton = angryButton.position
        page1ScrollView.addChild(angryButton)
        priceLabel = SKLabelNode(fontNamed: "Lemondrop")
        priceLabel.fontSize = 20
        for unlocked in unlockedMolds {
            if unlocked.moldType == MoldType.angry {
                pointsPrice = unlocked.price
                break
            }
        }
        priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
        priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
        page1ScrollView.addChild(priceLabel)
        ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
        ppsLabel.fontSize = 20
        ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.angry))
        ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
        page1ScrollView.addChild(ppsLabel)
        priceLabel.fontColor = UIColor.black
        ppsLabel.fontColor = UIColor.black
        if containsMold(array: blockedMolds, mold: MoldType.angry) {
            let maxLabel = SKSpriteNode(texture: maxTex)
            maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
            page1ScrollView.addChild(maxLabel)
        }
        
        for mold in unlockedMolds {
            if mold.moldType == MoldType.alien {
                //alien
                Texture = SKTexture(image: UIImage(named: "Alien Mold")!)
                alienButton = SKSpriteNode(texture:Texture)
                // Place in scene
                alienButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = alienButton.position
                page1ScrollView.addChild(alienButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.alien {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.alien))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.alien) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.freckled {
                //freckled
                Texture = SKTexture(image: UIImage(named: "Freckled Mold")!)
                freckledButton = SKSpriteNode(texture:Texture)
                // Place in scene
                freckledButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = freckledButton.position
                page1ScrollView.addChild(freckledButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.freckled {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.freckled))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.freckled) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
                
            }
            if mold.moldType == MoldType.hypno {
                Texture = SKTexture(image: UIImage(named: "Hypno Mold")!)
                hypnoButton = SKSpriteNode(texture:Texture)
                // Place in scene
                hypnoButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = hypnoButton.position
                page1ScrollView.addChild(hypnoButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.hypno {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.hypno))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.hypno) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.pimply {
                Texture = SKTexture(image: UIImage(named: "Pimply Mold")!)
                pimplyButton = SKSpriteNode(texture:Texture)
                // Place in scene
                pimplyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = pimplyButton.position
                page1ScrollView.addChild(pimplyButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.pimply {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.pimply))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.pimply) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.rainbow {
                Texture = SKTexture(image: UIImage(named: "Rainbow Mold")!)
                rainbowButton = SKSpriteNode(texture:Texture)
                // Place in scene
                rainbowButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = rainbowButton.position
                page1ScrollView.addChild(rainbowButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.rainbow {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.rainbow))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.rainbow) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.aluminum {
                Texture = SKTexture(image: UIImage(named: "Aluminum Mold")!)
                aluminumButton = SKSpriteNode(texture:Texture)
                // Place in scene
                aluminumButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = aluminumButton.position
                page1ScrollView.addChild(aluminumButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.aluminum {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.aluminum))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.aluminum) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.circuit {
                Texture = SKTexture(image: UIImage(named: "Circuit Mold")!)
                circuitButton = SKSpriteNode(texture:Texture)
                // Place in scene
                circuitButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = circuitButton.position
                page1ScrollView.addChild(circuitButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.circuit {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.circuit))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.circuit) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.hologram {
                Texture = SKTexture(image: UIImage(named: "Hologram Mold")!)
                hologramButton = SKSpriteNode(texture:Texture)
                // Place in scene
                hologramButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = hologramButton.position
                page1ScrollView.addChild(hologramButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.hologram {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.hologram))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.hologram) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.storm {
                Texture = SKTexture(image: UIImage(named: "Storm Mold")!)
                stormButton = SKSpriteNode(texture:Texture)
                // Place in scene
                stormButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = stormButton.position
                page1ScrollView.addChild(stormButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.storm {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.storm))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.storm) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.bacteria {
                Texture = SKTexture(image: UIImage(named: "Bacteria Mold")!)
                bacteriaButton = SKSpriteNode(texture:Texture)
                // Place in scene
                bacteriaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = bacteriaButton.position
                page1ScrollView.addChild(bacteriaButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.bacteria {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.bacteria))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.bacteria) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.virus {
                Texture = SKTexture(image: UIImage(named: "Virus Mold")!)
                virusButton = SKSpriteNode(texture:Texture)
                // Place in scene
                virusButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = virusButton.position
                page1ScrollView.addChild(virusButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.virus {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.virus))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.virus) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.flower {
                Texture = SKTexture(image: UIImage(named: "Flower Mold")!)
                flowerButton = SKSpriteNode(texture:Texture)
                // Place in scene
                flowerButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = flowerButton.position
                page1ScrollView.addChild(flowerButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.flower {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.flower))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.flower) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.bee {
                Texture = SKTexture(image: UIImage(named: "Bee Mold")!)
                beeButton = SKSpriteNode(texture:Texture)
                // Place in scene
                beeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = beeButton.position
                page1ScrollView.addChild(beeButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.bee {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.bee))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.bee) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.x {
                Texture = SKTexture(image: UIImage(named: "X Mold")!)
                xButton = SKSpriteNode(texture:Texture)
                // Place in scene
                xButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = xButton.position
                page1ScrollView.addChild(xButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.x {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.x))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.x) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.disaffected {
                Texture = SKTexture(image: UIImage(named: "Disaffected Mold")!)
                disaffectedButton = SKSpriteNode(texture:Texture)
                // Place in scene
                disaffectedButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = disaffectedButton.position
                page1ScrollView.addChild(disaffectedButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.disaffected {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.disaffected))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.disaffected) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.olive {
                Texture = SKTexture(image: UIImage(named: "Olive Mold")!)
                oliveButton = SKSpriteNode(texture:Texture)
                // Place in scene
                oliveButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = oliveButton.position
                page1ScrollView.addChild(oliveButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.olive {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.olive))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.olive) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.coconut {
                Texture = SKTexture(image: UIImage(named: "Coconut Mold")!)
                coconutButton = SKSpriteNode(texture:Texture)
                // Place in scene
                coconutButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = coconutButton.position
                page1ScrollView.addChild(coconutButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.coconut {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.coconut))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.coconut) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.sick {
                Texture = SKTexture(image: UIImage(named: "Sick Mold")!)
                sickButton = SKSpriteNode(texture:Texture)
                // Place in scene
                sickButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = sickButton.position
                page1ScrollView.addChild(sickButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.sick {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.sick))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.sick) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.dead {
                Texture = SKTexture(image: UIImage(named: "Dead Mold")!)
                deadButton = SKSpriteNode(texture:Texture)
                // Place in scene
                deadButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = deadButton.position
                page1ScrollView.addChild(deadButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.dead {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.dead))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.dead) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.zombie {
                Texture = SKTexture(image: UIImage(named: "Zombie Mold")!)
                zombieButton = SKSpriteNode(texture:Texture)
                // Place in scene
                zombieButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = zombieButton.position
                page1ScrollView.addChild(zombieButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.zombie {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.zombie))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.zombie) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.cloud {
                Texture = SKTexture(image: UIImage(named: "Cloud Mold")!)
                cloudButton = SKSpriteNode(texture:Texture)
                // Place in scene
                cloudButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = cloudButton.position
                page1ScrollView.addChild(cloudButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.cloud {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.cloud))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.cloud) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.rock {
                Texture = SKTexture(image: UIImage(named: "Rock Mold")!)
                rockButton = SKSpriteNode(texture:Texture)
                // Place in scene
                rockButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = rockButton.position
                page1ScrollView.addChild(rockButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.rock {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.rock))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.rock) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.water {
                Texture = SKTexture(image: UIImage(named: "Water Mold")!)
                waterButton = SKSpriteNode(texture:Texture)
                // Place in scene
                waterButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = waterButton.position
                page1ScrollView.addChild(waterButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.water {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.water))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.water) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.crystal {
                Texture = SKTexture(image: UIImage(named: "Crystal Mold")!)
                crystalButton = SKSpriteNode(texture:Texture)
                // Place in scene
                crystalButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = crystalButton.position
                page1ScrollView.addChild(crystalButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.crystal {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.crystal))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.crystal) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.nuclear {
                Texture = SKTexture(image: UIImage(named: "Nuclear Mold")!)
                nuclearButton = SKSpriteNode(texture:Texture)
                // Place in scene
                nuclearButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = nuclearButton.position
                page1ScrollView.addChild(nuclearButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.nuclear {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.nuclear))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.nuclear) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.astronaut {
                Texture = SKTexture(image: UIImage(named: "Astronaut Mold")!)
                astronautButton = SKSpriteNode(texture:Texture)
                // Place in scene
                astronautButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = astronautButton.position
                page1ScrollView.addChild(astronautButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.astronaut {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.astronaut))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.astronaut) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.sand {
                Texture = SKTexture(image: UIImage(named: "Sand Mold")!)
                sandButton = SKSpriteNode(texture:Texture)
                // Place in scene
                sandButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = sandButton.position
                page1ScrollView.addChild(sandButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.sand{
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.sand))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.sand) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.glass {
                Texture = SKTexture(image: UIImage(named: "Glass Mold")!)
                glassButton = SKSpriteNode(texture:Texture)
                // Place in scene
                glassButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = glassButton.position
                page1ScrollView.addChild(glassButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.glass {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.glass))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.glass) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.coffee {
                Texture = SKTexture(image: UIImage(named: "Coffee Mold")!)
                coffeeButton = SKSpriteNode(texture:Texture)
                // Place in scene
                coffeeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = coffeeButton.position
                page1ScrollView.addChild(coffeeButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.coffee {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.coffee))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.coffee) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.slinky {
                Texture = SKTexture(image: UIImage(named: "Slinky Mold")!)
                slinkyButton = SKSpriteNode(texture:Texture)
                // Place in scene
                slinkyButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = slinkyButton.position
                page1ScrollView.addChild(slinkyButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.slinky {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.slinky))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.slinky) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.magma {
                Texture = SKTexture(image: UIImage(named: "Magma Mold")!)
                magmaButton = SKSpriteNode(texture:Texture)
                // Place in scene
                magmaButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = magmaButton.position
                page1ScrollView.addChild(magmaButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.magma {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.magma))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.magma) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.samurai {
                Texture = SKTexture(image: UIImage(named: "Samurai Mold")!)
                samuraiButton = SKSpriteNode(texture:Texture)
                // Place in scene
                samuraiButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = samuraiButton.position
                page1ScrollView.addChild(samuraiButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.samurai {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.samurai))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.samurai) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.orange {
                Texture = SKTexture(image: UIImage(named: "Orange Mold")!)
                orangeButton = SKSpriteNode(texture:Texture)
                // Place in scene
                orangeButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = orangeButton.position
                page1ScrollView.addChild(orangeButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.orange {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.orange))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.orange) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.strawberry {
                Texture = SKTexture(image: UIImage(named: "Strawberry Mold")!)
                strawberryButton = SKSpriteNode(texture:Texture)
                // Place in scene
                strawberryButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = strawberryButton.position
                page1ScrollView.addChild(strawberryButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.strawberry {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.strawberry))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.strawberry) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.tshirt {
                Texture = SKTexture(image: UIImage(named: "TShirt Mold")!)
                tshirtButton = SKSpriteNode(texture:Texture)
                // Place in scene
                tshirtButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = tshirtButton.position
                page1ScrollView.addChild(tshirtButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.tshirt {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.tshirt))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.tshirt) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.cryptid {
                Texture = SKTexture(image: UIImage(named: "Cryptid Mold")!)
                cryptidButton = SKSpriteNode(texture:Texture)
                // Place in scene
                cryptidButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = cryptidButton.position
                page1ScrollView.addChild(cryptidButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.cryptid {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.cryptid))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.cryptid) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.angel {
                Texture = SKTexture(image: UIImage(named: "Angel Mold")!)
                angelButton = SKSpriteNode(texture:Texture)
                // Place in scene
                angelButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = angelButton.position
                page1ScrollView.addChild(angelButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.angel {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.angel))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.angel) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
            if mold.moldType == MoldType.invisible {
                Texture = SKTexture(image: UIImage(named: "Invisible Mold")!)
                invisibleButton = SKSpriteNode(texture:Texture)
                // Place in scene
                invisibleButton.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = invisibleButton.position
                page1ScrollView.addChild(invisibleButton)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                for unlocked in unlockedMolds {
                    if unlocked.moldType == MoldType.invisible {
                        pointsPrice = unlocked.price
                    }
                }
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: " + formatNumber(points: ppsAmount(mold: MoldType.invisible))
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                if containsMold(array: blockedMolds, mold: MoldType.invisible) {
                    let maxLabel = SKSpriteNode(texture: maxTex)
                    maxLabel.position = CGPoint(x: lastButton.x, y: lastButton.y)
                    page1ScrollView.addChild(maxLabel)
                }
            }
        }
        //            fill in black silhouettes for locked species
        if unlockedMolds.count < 42 {
            var remainder = 42 - unlockedMolds.count
            
            while(remainder > 0) {
                Texture = SKTexture(image: UIImage(named: "dna")!)
                let locked = SKSpriteNode(texture:Texture)
                // Place in scene
                locked.position = CGPoint(x: lastButton.x, y: lastButton.y - 90)
                lastButton = locked.position
                page1ScrollView.addChild(locked)
                priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.fontSize = 20
                priceLabel.text = "Cost: ????"
                priceLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y )
                page1ScrollView.addChild(priceLabel)
                ppsLabel = SKLabelNode(fontNamed: "Lemondrop")
                ppsLabel.fontSize = 20
                ppsLabel.text = "PPS: ????"
                ppsLabel.position = CGPoint(x: lastButton.x + 130, y: lastButton.y - 20)
                page1ScrollView.addChild(ppsLabel)
                priceLabel.fontColor = UIColor.black
                ppsLabel.fontColor = UIColor.black
                remainder -= 1
                print(remainder)
            }
            
        }
    }
    
    func updatePrice(mold: Mold) {
        //get index of mold in unlockedMolds
        var index = 0
        var pointsPrice: BInt = 0
        price: for check in unlockedMolds {
            if check.moldType == mold.moldType {
                pointsPrice = check.price
                break price
            }
            index += 1
        }
        let point = CGPoint(x: 30, y: (180 + (index * -90)) )
        graphics: for child in page1ScrollView.children {
            if child.position == point {
                child.removeFromParent()
                let priceLabel = SKLabelNode(fontNamed: "Lemondrop")
                priceLabel.text = "Cost: " + formatNumber(points: pointsPrice)
                priceLabel.position = point
                priceLabel.fontSize = 20
                priceLabel.fontColor = UIColor.black
                page1ScrollView.addChild(priceLabel)
                break graphics
            }
        }
    }
    
    func createButton() {
        // BACK MENU
        let Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+190);
        
        self.addChild(backButton)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            point = touch.location(in: gameLayer)
            
            if let node = node as? SKSpriteNode {
                if node.texture == maxTex {
                    playSound(select: "buzzer")
                }
            }
            
            
            //check if user purchased a mold
            if (slimeButton) != nil {
            if node == slimeButton {
                print("slime")
                if let handler = touchHandler {
                    handler("slime")
                }
            }
            }
            if (caveButton) != nil {
            if node == caveButton {
                print("cave")
                
                if let handler = touchHandler {
                    handler("cave")
                }
            }
            }
            if (sadButton) != nil {
            if node == sadButton {
                print("sad")
                if let handler = touchHandler {
                    handler("sad")
                }
            }
            }
            if (angryButton) != nil {
            if node == angryButton {
                print("angry")
                if let handler = touchHandler {
                    handler("angry")
                }
            }
            }
            if (alienButton) != nil {
                if node == alienButton {
                    print("alien")
                    if let handler = touchHandler {
                        handler("alien")
                    }
                }
            }
            if (freckledButton) != nil {
                if node == freckledButton {
                    print("freckled")
                    if let handler = touchHandler {
                        handler("freckled")
                    }
                }
            }
            if (hypnoButton) != nil {
                if node == hypnoButton {
                    print("hypno")
                    if let handler = touchHandler {
                        handler("hypno")
                    }
                }
            }
            if (pimplyButton) != nil {
                if node == pimplyButton {
                    print("pimply")
                    if let handler = touchHandler {
                        handler("pimply")
                    }
                }
            }
            if (rainbowButton) != nil {
                if node == rainbowButton {
                    print("rainbow")
                    if let handler = touchHandler {
                        handler("rainbow")
                    }
                }
            }
            if (aluminumButton) != nil {
                if node == aluminumButton {
                    print("aluminum")
                    if let handler = touchHandler {
                        handler("aluminum")
                    }
                }
            }
            if (circuitButton) != nil {
                if node == circuitButton {
                    print("circuit")
                    if let handler = touchHandler {
                        handler("circuit")
                    }
                }
            }
            if (hologramButton) != nil {
                if node == hologramButton {
                    print("hologram")
                    if let handler = touchHandler {
                        handler("hologram")
                    }
                }
            }
            if (stormButton) != nil {
                if node == stormButton {
                    print("storm")
                    if let handler = touchHandler {
                        handler("storm")
                    }
                }
            }
            if (bacteriaButton) != nil {
                if node == bacteriaButton {
                    print("bacteria")
                    if let handler = touchHandler {
                        handler("bacteria")
                    }
                }
            }
            if (virusButton) != nil {
                if node == virusButton {
                    print("virus")
                    if let handler = touchHandler {
                        handler("virus")
                    }
                }
            }
            if (flowerButton) != nil {
                if node == flowerButton {
                    print("floewr")
                    if let handler = touchHandler {
                        handler("flower")
                    }
                }
            }
            if (beeButton) != nil {
                if node == beeButton {
                    print("bee")
                    if let handler = touchHandler {
                        handler("bee")
                    }
                }
            }
            if (xButton) != nil {
                if node == xButton {
                    print("x")
                    if let handler = touchHandler {
                        handler("x")
                    }
                }
            }
            if (disaffectedButton) != nil {
                if node == disaffectedButton {
                    print("disaffected")
                    if let handler = touchHandler {
                        handler("disaffected")
                    }
                }
            }
            if (oliveButton) != nil {
                if node == oliveButton {
                    print("olive")
                    if let handler = touchHandler {
                        handler("olive")
                    }
                }
            }
            if (coconutButton) != nil {
                if node == coconutButton {
                    print("coconut")
                    if let handler = touchHandler {
                        handler("coconut")
                    }
                }
            }
            if (sickButton) != nil {
                if node == sickButton {
                    print("sick")
                    if let handler = touchHandler {
                        handler("sick")
                    }
                }
            }
            if (deadButton) != nil {
                if node == deadButton {
                    print("dead")
                    if let handler = touchHandler {
                        handler("dead")
                    }
                }
            }
            if (zombieButton) != nil {
                if node == zombieButton {
                    print("zombie")
                    if let handler = touchHandler {
                        handler("zombie")
                    }
                }
            }
            if (rockButton) != nil {
                if node == rockButton {
                    print("rock")
                    if let handler = touchHandler {
                        handler("rock")
                    }
                }
            }
            if (cloudButton) != nil {
                if node == cloudButton {
                    print("cloud")
                    if let handler = touchHandler {
                        handler("cloud")
                    }
                }
            }
            if (waterButton) != nil {
                if node == waterButton {
                    print("water")
                    if let handler = touchHandler {
                        handler("water")
                    }
                }
            }
            if (crystalButton) != nil {
                if node == crystalButton {
                    print("crystal")
                    if let handler = touchHandler {
                        handler("crystal")
                    }
                }
            }
            if (nuclearButton) != nil {
                if node == nuclearButton {
                    print("nuclear")
                    if let handler = touchHandler {
                        handler("nuclear")
                    }
                }
            }
            if (astronautButton) != nil {
                if node == astronautButton {
                    print("astronaut")
                    if let handler = touchHandler {
                        handler("astronaut")
                    }
                }
            }
            if (sandButton) != nil {
                if node == sandButton {
                    print("sand")
                    if let handler = touchHandler {
                        handler("sand")
                    }
                }
            }
            if (glassButton) != nil {
                if node == glassButton {
                    print("glass")
                    if let handler = touchHandler {
                        handler("glass")
                    }
                }
            }
            if (coffeeButton) != nil {
                if node == coffeeButton {
                    print("coffee")
                    if let handler = touchHandler {
                        handler("coffee")
                    }
                }
            }
            if (slinkyButton) != nil {
                if node == slinkyButton {
                    print("slinky")
                    if let handler = touchHandler {
                        handler("slinky")
                    }
                }
            }
            if (magmaButton) != nil {
                if node == magmaButton {
                    print("magma")
                    if let handler = touchHandler {
                        handler("magma")
                    }
                }
            }
            if (samuraiButton) != nil {
                if node == samuraiButton {
                    print("samurai")
                    if let handler = touchHandler {
                        handler("samurai")
                    }
                }
            }
            if (orangeButton) != nil {
                if node == orangeButton {
                    print("orange")
                    if let handler = touchHandler {
                        handler("orange")
                    }
                }
            }
            if (strawberryButton) != nil {
                if node == strawberryButton {
                    print("strawberry")
                    if let handler = touchHandler {
                        handler("strawberry")
                    }
                }
            }
            if (tshirtButton) != nil {
                if node == tshirtButton {
                    print("tshirt")
                    if let handler = touchHandler {
                        handler("tshirt")
                    }
                }
            }
            if (cryptidButton) != nil {
                if node == cryptidButton {
                    print("cryptid")
                    if let handler = touchHandler {
                        handler("cryptid")
                    }
                }
            }
            if (angelButton) != nil {
                if node == angelButton {
                    print("angel")
                    if let handler = touchHandler {
                        handler("angel")
                    }
                }
            }
            if (invisibleButton) != nil {
                if node == invisibleButton {
                    print("invisible")
                    if let handler = touchHandler {
                        handler("invisible")
                    }
                }
            }
            
        }
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        // Check if the location of the touch is within the back button's bounds
        if backButton.contains(touchLocation) {
            print("back")
            if let handler = touchHandler {
                scrollView?.removeFromSuperview()
                handler("back")
            }
        }
        
    }
    
    func playSound(select: String) {
        if mute == false {
        switch select {
        case "levelup":
            run(levelUpSound)
        case "select":
            run(selectSound)
        case "buzzer":
            run(buzzerSound)
        default:
            run(levelUpSound)
        }
        }
    }
    
    func animateName(name: String) {
        // Figure out what the midpoint of the chain is.
        let centerPosition = CGPoint(
            x: (point.x + 25),
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
    
    //MARK: - TUTORIAL
    func buyMoldTutorial() {
        self.addChild(tutorialLayer)
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        switch UIDevice().screenType {
        case .iPhone6:
            //iPhone 5
            introNode.setScale(1.15)
            break
        case .iPhone6Plus:
            introNode.setScale(1.15)
            break
        default:
            break
        }
        introNode.position = CGPoint(x:frame.midX, y:frame.midY);
        tutorialLayer.addChild(introNode)
        
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 13
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Every Mold has a price and"
        welcomeTitle.position = CGPoint(x:introNode.position.x, y:introNode.position.y+20);
        tutorialLayer.addChild(welcomeTitle)
        
        let welcomeTitle25 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle25.fontSize = 13
        welcomeTitle25.fontColor = UIColor.black
        welcomeTitle25.text = "a \"PPS\" - Points Per Second"
        welcomeTitle25.position = CGPoint(x:introNode.position.x, y:introNode.position.y);
        tutorialLayer.addChild(welcomeTitle25)
        
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 13
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "Yep! Molds earn you free money!"
        welcomeTitle2.position = CGPoint(x:introNode.position.x, y:introNode.position.y-24);
        tutorialLayer.addChild(welcomeTitle2)
        
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.buyInstructions()
        }
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            
            welcomeTitle.setScale(0.8)
            welcomeTitle2.setScale(0.8)
            welcomeTitle25.setScale(0.8)
            introNode.setScale(1.0)
            
            break
        case .iPhone5:
            //iPhone 5
            
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle25.setScale(0.9)
            introNode.setScale(1.05)
            
            break
        default:
            break
        }
    }
    
    func buyInstructions() {
        let appear = SKAction.scale(to: 1.15, duration: 0.35)
        let Texture = SKTexture(image: UIImage(named: "tutorial square small")!)
        let introNode = SKSpriteNode(texture:Texture)
        // Place in scene
        introNode.setScale(0.0)
        introNode.position = CGPoint(x:frame.midX, y:frame.midY-125);
        tutorialLayer.addChild(introNode)
        introNode.run(appear)
        
        let when = DispatchTime.now() + 0.35
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.addLabels()
        }
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            
            introNode.setScale(0.9)
            
            break
        case .iPhone5:
            //iPhone 5
            
            introNode.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func addLabels() {
    
        let welcomeTitle = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle.fontSize = 13
        welcomeTitle.fontColor = UIColor.black
        welcomeTitle.text = "Now buy a Slime Mold"
        welcomeTitle.position = CGPoint(x:frame.midX, y:frame.midY-105);
        tutorialLayer.addChild(welcomeTitle)
        
        let welcomeTitle25 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle25.fontSize = 13
        welcomeTitle25.fontColor = UIColor.black
        welcomeTitle25.text = "(the top one)"
        welcomeTitle25.position = CGPoint(x:frame.midX, y:frame.midY-125);
        tutorialLayer.addChild(welcomeTitle25)
        
        let welcomeTitle2 = SKLabelNode(fontNamed: "Lemondrop")
        welcomeTitle2.fontSize = 13
        welcomeTitle2.fontColor = UIColor.black
        welcomeTitle2.text = "and then return to the home screen"
        welcomeTitle2.position = CGPoint(x:frame.midX, y:frame.midY-150);
        tutorialLayer.addChild(welcomeTitle2)
        let when = DispatchTime.now() + 9
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.removeInstructions()
        }
        
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 5
            
            welcomeTitle.setScale(0.8)
            welcomeTitle2.setScale(0.8)
            welcomeTitle25.setScale(0.8)
            
            break
        case .iPhone5:
            //iPhone 5
            
            welcomeTitle.setScale(0.9)
            welcomeTitle2.setScale(0.9)
            welcomeTitle25.setScale(0.9)
            
            break
        default:
            break
        }
    }
    
    func removeInstructions() {
        let disappear = SKAction.scale(to: 0.0, duration: 0.5)
        let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
        for node in tutorialLayer.children {
            node.run(action)
        }
    }
    
    //MARK: - UTILITIES
    
    func containsMold(array: Array<Mold>, mold: MoldType) -> Bool {
        if array.count != 0 {
            for element in array {
                if element.moldType == mold {
                    return true
                }
            }
            return false
        }
        else {
            return false
        }
        
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
}
