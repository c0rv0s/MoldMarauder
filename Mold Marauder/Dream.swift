//
//  Dream.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 3/28/20.
//  Copyright © 2020 Nathan Mueller. All rights reserved.
//

import SpriteKit

class Dream: SKNode {
    var starLayer: SKNode!
    var cloudLayer: SKNode!
    var cloudTimer: Timer!
    var cloud1: SKNode!
    var cloud2: SKNode!
    var midY: CGFloat!
    var maxY: CGFloat!
    var minX: CGFloat!
    var maxX:CGFloat!
    
    init(midY: CGFloat, maxY: CGFloat, minX: CGFloat, maxX: CGFloat) {
        super.init()
        self.minX = minX
        self.midY = midY
        self.maxY = maxY
        self.maxX = maxX
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(stars: Bool, clouds: Bool) {
        starLayer = SKNode()
        cloudLayer = SKNode()
        addChild(starLayer)
        addChild(cloudLayer)
        if stars {
            addStars()

        }
        if clouds {
            animateClouds()
            cloudTimer = Timer.scheduledTimer(timeInterval: 35, target: self, selector: #selector(animateClouds), userInfo: nil, repeats: true)
        }
    }
    
    func addStars() {
        for _ in 0..<15 {
            let star = SKSpriteNode(texture: SKTexture(image: UIImage(named: "star")!))
            star.setScale(CGFloat(Float.random(in: 0.3 ..< 0.8)))
            let y = randomInRange(lo: Int(midY) - 140, hi: Int(maxY) - 25)
            let x = randomInRange(lo: Int(minX) - 20, hi: Int(maxX) - 20)
            star.position = CGPoint(x: x, y: y)
            starLayer.addChild(star)
        }
    }
    
    @objc func animateClouds() {
        cloud1 = SKSpriteNode(texture: SKTexture(image: UIImage(named: "cloud1")!))
        cloud2 = SKSpriteNode(texture: SKTexture(image: UIImage(named: "cloud2")!))
        var y = randomInRange(lo: Int(midY) - 100, hi: Int(maxY) - 100)
        
        cloud1.position = CGPoint(x: -400, y: y)
        cloud1.setScale(0.4)
        cloudLayer.addChild(cloud1)
        cloud1.run(SKAction.sequence([SKAction.move(to: CGPoint(x: 400,y: y), duration:35)]))
        
        y = randomInRange(lo: Int(midY) - 100, hi: Int(maxY) - 100)
        cloud2.position = CGPoint(x: 400, y: y)
        cloud2.setScale(0.4)
        cloudLayer.addChild(cloud2)
        cloud2.run(SKAction.sequence([SKAction.move(to: CGPoint(x: -400,y: y), duration:40)]))
    }
}
