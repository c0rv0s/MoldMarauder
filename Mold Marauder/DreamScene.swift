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
    var dialogueLabel: SKLabelNode!
    var timePrisonEnabled = false
    
    var charsPerLine = 18
    var lineWidth = 400
    var dialogueStarted = false
    var dialogueIndex = 0
    var yOffset = 240
    var mute = false
    
    //touch handler
    var touchHandler: ((String) -> ())?
    
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
        
        switch UIDevice().screenType {
        case .iPhone8:
            lineWidth = 300
            charsPerLine = 14
            yOffset = 180
            break
        case .iPhone8Plus:
            break
        case .iPhoneX:
            lineWidth = 300
            charsPerLine = 14
            yOffset = 180
            break
        default:
            break
        }
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
            self.displayDialogue(index: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dialogueLabel != nil {
            dialogueIndex += 1
        }
        if timePrisonEnabled {
            if dialogueIndex < subsequentDialogueArray.count {
                if dialogueLabel != nil {
                    dialogueLabel.removeFromParent()
                    displayDialogue(index: dialogueIndex)
                }
            }
            else {
                if let handler = touchHandler {
                    handler("subsequent dialogue")
                }
            }
        }
        else {
            if dialogueIndex < firstDialogueArray.count {
                if dialogueLabel != nil {
                    dialogueLabel.removeFromParent()
                    displayDialogue(index: dialogueIndex)
                }
            }
            else {
                if let handler = touchHandler {
                    handler("first dialogue")
                }
            }
        }
    }
    
    func displayDialogue(index: Int) {
        var textString = firstDialogueArray[index]
        if timePrisonEnabled {
            textString = subsequentDialogueArray[index]
        }
        dialogueLabel = SKLabelNode(fontNamed: "Lemondrop")
        dialogueLabel.text = textString
        dialogueLabel.numberOfLines = (textString.count / charsPerLine) + 1
        dialogueLabel.preferredMaxLayoutWidth = CGFloat(lineWidth)
        dialogueLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+CGFloat(yOffset))
        dialogueLabel.fontSize = 18
        dialogueLabel.fontColor = UIColor.black
        self.addChild(dialogueLabel)
        dialogueStarted = true
    }
    
    func playSound(select: String) {
        if mute == false {
            switch select {
            case "ding":
                run(dingSound)
            default:
                run(dingSound)
            }
        }
    }
}
