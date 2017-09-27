//
//  blackhole.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 9/16/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import Foundation
import SpriteKit

class BlackHole: SKNode {
    private var center: SKSpriteNode?
    private var outer: SKSpriteNode?
    
    var gone = false
    
    convenience init(size:CGSize) {
        self.init()
        let pick = randomInRange(lo: 1, hi: 13)
        let centTexture = SKTexture(image: UIImage(named: "center \(pick)")!)
        let spiralTexture = SKTexture(image: UIImage(named: "spiral")!)
        self.center = SKSpriteNode(texture: centTexture)
        self.center?.name = "hole"
        self.outer = SKSpriteNode(texture: spiralTexture)
        self.outer?.name = "hole"
        addChild(outer!)
        addChild(center!)
    }
//    intro and remove animations
    func place() {
        center?.setScale(0.0001)
        outer?.setScale(0.0001)
        let appear = SKAction.scale(to: 1.2, duration: 0.4)
        let bounce1 = SKAction.scale(to: 0.85, duration: 0.1)
        let bounce2 = SKAction.scale(to: 1.0, duration: 0.1)
        let rotateL = SKAction.rotate(byAngle: 360, duration: 400)
        center?.run(SKAction.sequence([appear, bounce1, bounce2, rotateL]))
        
        let rotateR = SKAction.rotate(byAngle: -1800, duration: 100)
        outer?.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), appear, bounce1, bounce2, rotateR]))
    }
    
    func disappear() {
        let bounce1 = SKAction.scale(to: 1.15, duration: 0.1)
        let bounce2 = SKAction.scale(to: 0.0, duration: 0.25)
        center?.run(SKAction.sequence([bounce1, bounce2]))
        outer?.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), bounce1, bounce2]))
        gone = true
    }
    
    private func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
}
