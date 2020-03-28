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
        var Texture = SKTexture(image: UIImage(named: "exit")!)
        backButton = SKSpriteNode(texture:Texture)
        // Place in scene
        backButton.position = CGPoint(x:self.frame.midX+160, y:self.frame.midY+320);
        
        self.addChild(backButton)
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
