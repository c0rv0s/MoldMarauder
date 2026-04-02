//
//  Background.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 3/5/20.
//  Copyright © 2020 Nathan Mueller. All rights reserved.
//

import SpriteKit

class Background: SKNode {
    
    var backframes = [SKTexture]()
    var background = SKSpriteNode(texture: SKTexture(image: UIImage(named: "cyber_menu_glow")!))
    
    func start(size: CGSize) {
        let verticalOffset: CGFloat = -20
        let overscan: CGFloat = 40
        let scale = (size.height + overscan) / size.height

        background.size = CGSize(width: size.width * scale, height: size.height * scale)
        background.position = CGPoint(x: 0, y: verticalOffset)
        backframes.removeAll(keepingCapacity: true)
        
        backframes.append(SKTexture(image: UIImage(named: "cyber_menu_glow")!))
        backframes.append(SKTexture(image: UIImage(named: "cyber_menu_glow F2")!))
        backframes.append(SKTexture(image: UIImage(named: "cyber_menu_glow F3")!))
        
        background.run(SKAction.repeatForever(
        SKAction.animate(with: backframes,
                         timePerFrame: 0.15,
                         resize: false,
                         restore: true)),
                   withKey:"background")
    }
}
