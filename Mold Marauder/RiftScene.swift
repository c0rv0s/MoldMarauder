//
//  RiftScene.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 3/29/20.
//  Copyright © 2020 Nathan Mueller. All rights reserved.
//

import SpriteKit

class RiftScene: SKScene {

    var background: SKSpriteNode!
    var dialogueLabel: SKLabelNode!
    var riftLayer = SKNode()
    var moldLayer = SKNode()
    
    var charsPerLine = 18
    var lineWidth = 400
    var yOffset = 240
    var dialogueStarted = false
    var dialogueIndex = 0
    var mute = false
    
    //touch handler
    var touchHandler: ((String) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background = SKSpriteNode(imageNamed: "rift")
        background.size = size
        addChild(background)
        addChild(riftLayer)
        addChild(moldLayer)
        
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
        var y = 180
        for _ in 0..<4 {
            let meta1 = SKSpriteNode(texture: SKTexture(image: UIImage(named: "Metaphase Mold")!))
            meta1.position = CGPoint(x:self.frame.midX-140, y:self.frame.midY+CGFloat(y))
            moldLayer.addChild(meta1)
            let meta2 = SKSpriteNode(texture: SKTexture(image: UIImage(named: "Metaphase Mold")!))
            meta2.position = CGPoint(x:self.frame.midX+140, y:self.frame.midY+CGFloat(y))
            moldLayer.addChild(meta2)
            y -= 120
        }
        let god = SKSpriteNode(texture: SKTexture(image: UIImage(named: "God Mold")!))
        god.position = CGPoint(x:self.frame.midX, y:self.frame.minY + 100)
        moldLayer.addChild(god)
        
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
        if dialogueIndex < finalDialogueArray.count {
            if dialogueLabel != nil {
                dialogueLabel.removeFromParent()
                displayDialogue(index: dialogueIndex)
            }
        }
        else {
            dialogueLabel.removeFromParent()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                if let handler = self.touchHandler {
                    handler("explosion")
                }
                self.explosion()
            }
        }
    }
    
    func displayDialogue(index: Int) {
        let textString = finalDialogueArray[index]
        dialogueLabel = SKLabelNode(fontNamed: "Lemondrop")
        dialogueLabel.text = textString
        dialogueLabel.numberOfLines = (textString.count / charsPerLine) + 1
        dialogueLabel.preferredMaxLayoutWidth = CGFloat(lineWidth)
        dialogueLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+CGFloat(yOffset))
        dialogueLabel.fontSize = 24
        dialogueLabel.fontColor = UIColor.white
        self.addChild(dialogueLabel)
        dialogueStarted = true
    }
    
    func explosion() {
        let whiteOut = SKSpriteNode(texture: SKTexture(image: UIImage(named: "white out")!))
        whiteOut.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        whiteOut.alpha = 0.0
        addChild(whiteOut)
        
        let textString = "What a curious adventure..."
        dialogueLabel = SKLabelNode(fontNamed: "Lemondrop")
        dialogueLabel.text = textString
        dialogueLabel.numberOfLines = (textString.count / self.charsPerLine) + 1
        dialogueLabel.preferredMaxLayoutWidth = CGFloat(self.lineWidth)
        dialogueLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY+CGFloat(yOffset/2))
        dialogueLabel.fontSize = 24
        dialogueLabel.fontColor = UIColor.black
        dialogueLabel.alpha = 0.0
        addChild(dialogueLabel)
        
        var backframes = [SKTexture]()
        backframes.append(SKTexture(image: UIImage(named: "rift1")!))
        backframes.append(SKTexture(image: UIImage(named: "rift2")!))
        backframes.append(SKTexture(image: UIImage(named: "rift3")!))
        backframes.append(SKTexture(image: UIImage(named: "rift1")!))
        backframes.append(SKTexture(image: UIImage(named: "rift2")!))
        backframes.append(SKTexture(image: UIImage(named: "rift3")!))
        
        background.run(SKAction.sequence([
            SKAction.animate(with: backframes,timePerFrame: 0.5,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.25,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.1,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.1,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.1,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.1,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.1,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.1,resize: false,restore: true),
            
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true),
            SKAction.animate(with: backframes,timePerFrame: 0.05,resize: false,restore: true)
        ]))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 9) {
            whiteOut.run( SKAction.sequence([.fadeIn(withDuration: 2.5)]) )
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 16) {
            self.dialogueLabel.run( SKAction.sequence([.fadeIn(withDuration: 1.5)]) )
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 22) {
            self.dialogueLabel.run( SKAction.sequence([.fadeOut(withDuration: 1.5), SKAction.removeFromParent()]) )
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 28.0) {
            if let handler = self.touchHandler {
                handler("done")
            }
        }
    }
}
