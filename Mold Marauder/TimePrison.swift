//
//  TimePrison.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 3/27/20.
//  Copyright © 2020 Nathan Mueller. All rights reserved.
//

import SpriteKit
class TimePrison: SKScene {
    var mute = false
    var background: SKSpriteNode!
    var backButton: SKNode!
    
    let gameLayer = SKNode()
    let dialogueLayer = SKNode()
    let successLayer = SKNode()
    var point = CGPoint()
    
    var freedFromTimePrison: Array<Bool>!
    var phaseCrystals: BInt!
    
    var metaOne: SKNode!
    var metaTwo: SKNode!
    var metaThree: SKNode!
    var metaFour: SKNode!
    var metaFive: SKNode!
    var metaSix: SKNode!
    var metaSeven: SKNode!
    var metaEight: SKNode!
    var godButton: SKNode!
    
    var noButton: SKLabelNode!
    var yesButton: SKLabelNode!
    
    var metaNum = 0
    
    var crystalHeader: SKLabelNode!
    var crystalLabel: SKLabelNode!
    
    //touch handler
    var touchHandler: ((String) -> ())?
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background = SKSpriteNode(imageNamed: "time prison")
        if UIDevice().screenType == .iPhone8 {
            background = SKSpriteNode(imageNamed: "time prison small")
        }
        background.size = size
        addChild(background)
        addChild(gameLayer)
        addChild(dialogueLayer)
        addChild(successLayer)
        
        let _ = SKLabelNode(fontNamed: "Lemondrop")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        createButton()
    }
    
    func createButton()
    {
        // BACK MENU
        let Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+320);
        
        gameLayer.addChild(backButton)
        
        crystalHeader = SKLabelNode(fontNamed: "Lemondrop")
        crystalHeader.text = "Metaphase Crystals:"
        crystalHeader.position = CGPoint(x: self.frame.midX, y: self.frame.midY+320)
        crystalHeader.fontSize = 15
        crystalHeader.fontColor = UIColor.black
        gameLayer.addChild(crystalHeader)
        
        crystalLabel = SKLabelNode(fontNamed: "Lemondrop")
        crystalLabel.text = formatNumber(points: phaseCrystals!)
        crystalLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+295)
        crystalLabel.fontSize = 15
        crystalLabel.fontColor = UIColor.black
        
        gameLayer.addChild(crystalLabel)

        //add the 8 meta phases and the god mold
        let metaphaseTex = SKTexture(image: UIImage(named: "Metaphase Mold")!)
        let godTex = SKTexture(image: UIImage(named: "God Mold")!)
        if !freedFromTimePrison[0] {
            metaOne = SKSpriteNode(texture: metaphaseTex)
            metaOne.position = CGPoint(x:self.frame.midX-135, y:self.frame.midY+210);
            metaOne.setScale(0.3)
            gameLayer.addChild(metaOne)
        }
        if !freedFromTimePrison[1] {
            metaTwo = SKSpriteNode(texture: metaphaseTex)
            metaTwo.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY+237);
            metaTwo.setScale(0.3)
            gameLayer.addChild(metaTwo)
        }
        if !freedFromTimePrison[2] {
            metaThree = SKSpriteNode(texture: metaphaseTex)
            metaThree.position = CGPoint(x:self.frame.midX+68, y:self.frame.midY+238);
            metaThree.setScale(0.3)
            gameLayer.addChild(metaThree)
        }
        if !freedFromTimePrison[3] {
            metaFour = SKSpriteNode(texture: metaphaseTex)
            metaFour.position = CGPoint(x:self.frame.midX+142, y:self.frame.midY+210);
            metaFour.setScale(0.3)
            gameLayer.addChild(metaFour)
        }
        if !freedFromTimePrison[4] {
            metaFive = SKSpriteNode(texture: metaphaseTex)
            metaFive.position = CGPoint(x:self.frame.midX-135, y:self.frame.midY-190);
            metaFive.setScale(0.3)
            gameLayer.addChild(metaFive)
        }
        if !freedFromTimePrison[5] {
            metaSix = SKSpriteNode(texture: metaphaseTex)
            metaSix.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY-215);
            metaSix.setScale(0.3)
            gameLayer.addChild(metaSix)
        }
        if !freedFromTimePrison[6] {
            metaSeven = SKSpriteNode(texture: metaphaseTex)
            metaSeven.position = CGPoint(x:self.frame.midX+67, y:self.frame.midY-217);
            metaSeven.setScale(0.3)
            gameLayer.addChild(metaSeven)
        }
        if !freedFromTimePrison[7] {
            metaEight = SKSpriteNode(texture: metaphaseTex)
            metaEight.position = CGPoint(x:self.frame.midX+142, y:self.frame.midY-190);
            metaEight.setScale(0.3)
            gameLayer.addChild(metaEight)
        }
        if !freedFromTimePrison[8] {
            godButton = SKSpriteNode(texture: godTex)
            godButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY+10);
            godButton.setScale(0.5)
            gameLayer.addChild(godButton)
        }
        
        switch UIDevice().screenType {
        case .iPhone8:
            metaOne.position = CGPoint(x:metaOne.position.x+13, y:metaOne.position.y-12);
            metaTwo.position = CGPoint(x:metaTwo.position.x+6, y:metaTwo.position.y-12);
            metaThree.position = CGPoint(x:metaThree.position.x-6, y:metaThree.position.y-12);
            metaFour.position = CGPoint(x:metaFour.position.x-13, y:metaFour.position.y-12);
            metaFive.position = CGPoint(x:metaFive.position.x+13, y:metaFive.position.y+12);
            metaSix.position = CGPoint(x:metaSix.position.x+6, y:metaSix.position.y+12);
            metaSeven.position = CGPoint(x:metaSeven.position.x-6, y:metaSeven.position.y+12);
            metaEight.position = CGPoint(x:metaEight.position.x-13, y:metaEight.position.y+12);
            backButton.position.y -= 30
            crystalLabel.position.y -= 30
            crystalHeader.position.y -= 30
            break
        case .iPhone8Plus:
            metaOne.position = CGPoint(x:metaOne.position.x, y:metaOne.position.y-30);
            metaTwo.position = CGPoint(x:metaTwo.position.x, y:metaTwo.position.y-32);
            metaThree.position = CGPoint(x:metaThree.position.x, y:metaThree.position.y-32);
            metaFour.position = CGPoint(x:metaFour.position.x, y:metaFour.position.y-30);
            metaFive.position = CGPoint(x:metaFive.position.x, y:metaFive.position.y+30);
            metaSix.position = CGPoint(x:metaSix.position.x, y:metaSix.position.y+32);
            metaSeven.position = CGPoint(x:metaSeven.position.x, y:metaSeven.position.y+32);
            metaEight.position = CGPoint(x:metaEight.position.x, y:metaEight.position.y+30);
            break
        case .iPhoneX:
            metaOne.position = CGPoint(x:metaOne.position.x+12, y:metaOne.position.y-20);
            metaTwo.position = CGPoint(x:metaTwo.position.x+7, y:metaTwo.position.y-20);
            metaThree.position = CGPoint(x:metaThree.position.x-7, y:metaThree.position.y-20);
            metaFour.position = CGPoint(x:metaFour.position.x-12, y:metaFour.position.y-20);
            metaFive.position = CGPoint(x:metaFive.position.x+12, y:metaFive.position.y+20);
            metaSix.position = CGPoint(x:metaSix.position.x+7, y:metaSix.position.y+20);
            metaSeven.position = CGPoint(x:metaSeven.position.x-7, y:metaSeven.position.y+20);
            metaEight.position = CGPoint(x:metaEight.position.x-12, y:metaEight.position.y+20);
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
        if successLayer.children.count > 0 {
            successLayer.removeAllChildren()
        }
        else {
            if backButton.contains(touchLocation) {
                print("back")
                if let handler = touchHandler {
                    handler("back")
                }
            }
            else if metaOne != nil && metaOne.contains(touchLocation) && !freedFromTimePrison[0] {
                metaNum = 0
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if metaTwo != nil && metaTwo.contains(touchLocation) && !freedFromTimePrison[1] {
                metaNum = 1
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if metaThree != nil && metaThree.contains(touchLocation) && !freedFromTimePrison[2] {
                metaNum = 2
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if metaFour != nil && metaFour.contains(touchLocation) && !freedFromTimePrison[3] {
                metaNum = 3
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if metaFive != nil && metaFive.contains(touchLocation) && !freedFromTimePrison[4] {
                metaNum = 4
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if metaSix != nil && metaSix.contains(touchLocation) && !freedFromTimePrison[5] {
                metaNum = 5
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if metaSeven != nil && metaSeven.contains(touchLocation) && !freedFromTimePrison[6] {
                metaNum = 6
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if metaEight != nil && metaEight.contains(touchLocation) && !freedFromTimePrison[7] {
                metaNum = 7
                if let handler = touchHandler {
                    handler("meta")
                }
            }
            else if godButton != nil && godButton.contains(touchLocation) && !freedFromTimePrison[8] {
                metaNum = 8
                if let handler = touchHandler {
                    handler("god")
                }
            }
            else if yesButton != nil && yesButton.contains(touchLocation) {
                if let handler = touchHandler {
                    handler("yes")
                }
            }
            else if noButton != nil && noButton.contains(touchLocation) {
                if let handler = touchHandler {
                    handler("no")
                }
            }
        }
    }
    
    func showNewBreed(breed: MoldType) {
        // grey
        var Texture = SKTexture(image: UIImage(named: "grey out")!)
        let greyOut = SKSpriteNode(texture:Texture)
        // Place in scene
        greyOut.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        successLayer.addChild(greyOut)
        
        //popup
        Texture = SKTexture(image: UIImage(named: "freed mold popup")!)
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
        if breed == MoldType.god {
            nameLabel.position.y -= 60
        }
        nameLabel.setScale(0.01)
        nameLabel.run(actionM)
        successLayer.addChild(nameLabel)
    }
    
    func playSound(select: String) {
        if mute == false {
            switch select {
            case "select":
                run(selectSound)
            case "awe":
                run(aweSound)
            default:
                run(levelUpSound)
            }
        }
    }

}
