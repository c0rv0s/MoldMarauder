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
    var point = CGPoint()
    
    var freedFromTimePrison: Array<Bool>!
    
    var metaOne: SKNode!
    var metaTwo: SKNode!
    var metaThree: SKNode!
    var metaFour: SKNode!
    var metaFive: SKNode!
    var metaSix: SKNode!
    var metaSeven: SKNode!
    var metaEight: SKNode!
    var godButton: SKNode!
    
    //touch handler
    var touchHandler: ((String) -> ())?
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background = SKSpriteNode(imageNamed: "time prison")
        background.size = size
        addChild(background)

        addChild(gameLayer)
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
        
        self.addChild(backButton)

        //add the 8 meta phases and the god mold
        let metaphaseTex = SKTexture(image: UIImage(named: "Metaphase Mold")!)
        let godTex = SKTexture(image: UIImage(named: "God Mold")!)
        if !freedFromTimePrison[0] {
            metaOne = SKSpriteNode(texture: metaphaseTex)
            metaOne.position = CGPoint(x:self.frame.midX-135, y:self.frame.midY+210);
            metaOne.setScale(0.3)
            self.addChild(metaOne)
        }
        if !freedFromTimePrison[1] {
            metaTwo = SKSpriteNode(texture: metaphaseTex)
            metaTwo.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY+237);
            metaTwo.setScale(0.3)
            self.addChild(metaTwo)
        }
        if !freedFromTimePrison[2] {
            metaThree = SKSpriteNode(texture: metaphaseTex)
            metaThree.position = CGPoint(x:self.frame.midX+68, y:self.frame.midY+238);
            metaThree.setScale(0.3)
            self.addChild(metaThree)
        }
        if !freedFromTimePrison[3] {
            metaFour = SKSpriteNode(texture: metaphaseTex)
            metaFour.position = CGPoint(x:self.frame.midX+142, y:self.frame.midY+215);
            metaFour.setScale(0.3)
            self.addChild(metaFour)
        }
        if !freedFromTimePrison[4] {
            metaFive = SKSpriteNode(texture: metaphaseTex)
            metaFive.position = CGPoint(x:self.frame.midX-135, y:self.frame.midY-190);
            metaFive.setScale(0.3)
            self.addChild(metaFive)
        }
        if !freedFromTimePrison[5] {
            metaSix = SKSpriteNode(texture: metaphaseTex)
            metaSix.position = CGPoint(x:self.frame.midX-60, y:self.frame.midY-215);
            metaSix.setScale(0.3)
            self.addChild(metaSix)
        }
        if !freedFromTimePrison[6] {
            metaSeven = SKSpriteNode(texture: metaphaseTex)
            metaSeven.position = CGPoint(x:self.frame.midX+67, y:self.frame.midY-217);
            metaSeven.setScale(0.3)
            self.addChild(metaSeven)
        }
        if !freedFromTimePrison[7] {
            metaEight = SKSpriteNode(texture: metaphaseTex)
            metaEight.position = CGPoint(x:self.frame.midX+142, y:self.frame.midY-190);
            metaEight.setScale(0.3)
            self.addChild(metaEight)
        }
        if !freedFromTimePrison[8] {
            godButton = SKSpriteNode(texture: godTex)
            godButton.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
            godButton.setScale(0.4)
            self.addChild(godButton)
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
            case "select":
                run(selectSound)
            default:
                run(levelUpSound)
            }
        }
    }

}
