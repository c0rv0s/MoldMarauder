//
//  DreamScene.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 3/29/20.
//  Copyright © 2020 Nathan Mueller. All rights reserved.
//

import SpriteKit

class DreamScene: SKScene {

    var dream: Dream!
    var background: SKSpriteNode!
    var timePrisonEnabled = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background = SKSpriteNode(imageNamed: "dream")
        background.size = size
        addChild(background)
        
        dream = Dream(midY: self.frame.midY, maxY: self.frame.maxY, minX: self.frame.minX, maxX: self.frame.maxX)
        addChild(dream)
    }
    
    override func didMove(to view: SKView) {
        dream.start(stars: true, clouds: true, starsHigher: false)
        
        let moldData = Mold(moldType: MoldType.god)
        let textureOne = SKTexture(image: UIImage(named: moldData.name)!)
        let textureTwo = SKTexture(image: UIImage(named: moldData.name + " T Blink")!)
        let textureThree = SKTexture(image: UIImage(named: moldData.name + " B Blink")!)
        let textureFour = SKTexture(image: UIImage(named: moldData.name + " F Blink")!)
        var blinkFrames = [SKTexture]()
        
        var i = 0
        let numFrames = (Int(arc4random_uniform(6)) + 8)*10
        while(i<numFrames) {
            blinkFrames.append(textureOne)
            i += 1
        }
        blinkFrames.append(textureTwo)
        blinkFrames.append(textureThree)
        blinkFrames.append(textureFour)
        blinkFrames.append(textureThree)
        blinkFrames.append(textureTwo)
        
        let firstFrame = blinkFrames[0]
        let moldPic = SKSpriteNode(texture:firstFrame)
        moldPic.name = moldData.name
        moldPic.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(moldPic)
        
        moldPic.run(SKAction.repeatForever(
            SKAction.animate(with: blinkFrames,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                    withKey:"moldBlinking")
        let moveActionUp = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 6)
        moveActionUp.timingMode = .easeOut
        let moveActionDown = SKAction.move(by: CGVector(dx: 0, dy: -20), duration: 6)
        moveActionDown.timingMode = .easeOut
        moldPic.run(SKAction.repeatForever(SKAction.sequence([moveActionUp, moveActionDown])))
        
        let blackOut = SKSpriteNode(texture: SKTexture(image: UIImage(named: "black out")!))
        // Place in scene
        blackOut.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(blackOut)
        blackOut.run( SKAction.sequence([.fadeOut(withDuration: 3), .removeFromParent()]) )
    }
}
