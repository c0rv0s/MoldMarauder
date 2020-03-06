//
//  CometLayer.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 3/5/20.
//  Copyright © 2020 Nathan Mueller. All rights reserved.
//
import SpriteKit

class CometLayer: SKNode {
    
    //comet sprites
    var cometSprite: SKNode! = nil
    var cometSprite1: SKNode! = nil
    var cometSprite2: SKNode! = nil
    var cometTimer: Timer!
    
    func start(menu: Bool) {
        if menu {
            cometTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(animateCometsMenu), userInfo: nil, repeats: true)
        }
        else {
            cometTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(animateComets), userInfo: nil, repeats: true)
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
            self.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: 500,y: y), duration:0.6)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:comet)
            cometSprite2.position = CGPoint(x: -500, y: y + 30)
            self.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: 500,y: y + 30), duration:0.6)
            cometSprite2.run(SKAction.sequence([moveTwo]))
            
        }
        if side == 2 {
            cometSprite = SKSpriteNode(texture:cometUp)
            cometSprite.position = CGPoint(x: x, y: -700)
            self.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: x,y: 700), duration:0.8)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:cometUp)
            cometSprite2.position = CGPoint(x: x + 30, y: -700)
            self.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: x + 30,y: 700), duration:0.8)
            cometSprite2.run(SKAction.sequence([moveTwo]))
        }
        if side == 3 {
            cometSprite = SKSpriteNode(texture:cometDown)
            cometSprite.position = CGPoint(x: x, y: 700)
            self.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: x,y: -700), duration:0.8)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:cometDown)
            cometSprite2.position = CGPoint(x: x - 30, y: 700)
            self.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: x - 30,y: -700), duration:0.8)
            cometSprite2.run(SKAction.sequence([moveTwo]))
        }
        else {
            cometSprite = SKSpriteNode(texture:comet180)
            cometSprite.position = CGPoint(x: 500, y: y)
            self.addChild(cometSprite)
            
            let moveOne = SKAction.move(to: CGPoint(x: -500,y: y), duration:0.6)
            cometSprite.run(SKAction.sequence([moveOne]))
            
            cometSprite2 = SKSpriteNode(texture:comet180)
            cometSprite2.position = CGPoint(x: 500, y: y - 30)
            self.addChild(cometSprite2)
            
            let moveTwo = SKAction.move(to: CGPoint(x: -500,y: y - 30), duration:0.6)
            cometSprite2.run(SKAction.sequence([moveTwo]))
        }
        
    }
    
    @objc func animateCometsMenu() {
        let comet = SKTexture(image: UIImage(named: "comet")!)
        let comet180 = SKTexture(image: UIImage(named: "comet180")!)
        let cometUp = SKTexture(image: UIImage(named: "cometUp")!)
        let cometDown = SKTexture(image: UIImage(named: "cometDown")!)
        
        //left or right
        let side = Int(arc4random_uniform(2))
        let y = randomInRange(lo: Int(self.frame.minY), hi: Int(self.frame.maxY))
        if side == 1{
            cometSprite1 = SKSpriteNode(texture:comet)
            cometSprite1.position = CGPoint(x: -500, y: y)
            self.addChild(cometSprite1)
            
            let moveHoriz = SKAction.move(to: CGPoint(x: 500,y: y), duration:0.7)
            cometSprite1.run(moveHoriz)
            
            let up = Int(arc4random_uniform(2))
            let x = randomInRange(lo: Int(self.frame.minX), hi: Int(self.frame.maxX))
            if up == 1 {
                cometSprite2 = SKSpriteNode(texture:cometUp)
                cometSprite2.position = CGPoint(x: x, y: -700)
                self.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: 700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
            else {
                cometSprite2 = SKSpriteNode(texture:cometDown)
                cometSprite2.position = CGPoint(x: x, y: 700)
                self.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: -700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
            
        }
        else {
            cometSprite1 = SKSpriteNode(texture:comet180)
            cometSprite1.position = CGPoint(x: 500, y: y)
            self.addChild(cometSprite1)
            
            let moveHoriz = SKAction.move(to: CGPoint(x: -500,y: y), duration:0.7)
            cometSprite1.run(moveHoriz)
            
            let up = Int(arc4random_uniform(2))
            let x = randomInRange(lo: Int(self.frame.minX), hi: Int(self.frame.maxX))
            if up == 1 {
                cometSprite2 = SKSpriteNode(texture:cometUp)
                cometSprite2.position = CGPoint(x: x, y: -700)
                self.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: 700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
            else {
                cometSprite2 = SKSpriteNode(texture:cometDown)
                cometSprite2.position = CGPoint(x: x, y: 700)
                self.addChild(cometSprite2)
                
                let moveVert = SKAction.move(to: CGPoint(x: x,y: -700), duration:0.9)
                cometSprite2.run(SKAction.sequence([moveVert, SKAction.removeFromParent()]))
            }
        }
    }
}
