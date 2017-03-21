//
//  progress_Bar.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/24/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//
// Thanks to StackOverFlow user: 0x141E
// for providing a lot of help with this class definition

import Foundation
import SpriteKit

class ProgressBar:SKNode {
    var background:SKSpriteNode?
    var bar:SKSpriteNode?
    var _progress:CGFloat = 0
    var progress:CGFloat {
        get {
            return _progress
        }
        set {
            let value = max(min(newValue,1.0),0.0)
            if let bar = bar {
                bar.xScale = value
                _progress = value
            }
        }
    }
    
    convenience init(color:SKColor, size:CGSize) {
        self.init()
        background = SKSpriteNode(color:SKColor.white,size:size)
        bar = SKSpriteNode(color:color,size:size)
        if let bar = bar, let background = background {
            bar.xScale = 0.0
            bar.zPosition = 1.0
            bar.position = CGPoint(x:-size.width/2,y:0)
            bar.anchorPoint = CGPoint(x:0.0,y:0.5)
            addChild(background)
            addChild(bar)
        }
    }
}
