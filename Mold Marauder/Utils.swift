//
//  Utils.swift
//  Mold Marauder
//
//  Created by Nathanael Mueller on 3/5/20.
//  Copyright © 2020 Nathan Mueller. All rights reserved.
//

import Foundation
import SpriteKit

//sounds
var levelUpSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
var cashRegisterSound = SKAction.playSoundFileNamed("cash register.wav", waitForCompletion: false)
var selectSound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
var exitSound = SKAction.playSoundFileNamed("exit.wav", waitForCompletion: false)
var diamondPopSound = SKAction.playSoundFileNamed("bubble pop.wav", waitForCompletion: false)
var bubbleLowSound = SKAction.playSoundFileNamed("bubble low.wav", waitForCompletion: false)
var aweSound = SKAction.playSoundFileNamed("awe.wav", waitForCompletion: false)
var buzzerSound = SKAction.playSoundFileNamed("buzzer.wav", waitForCompletion: false)
var looseSound = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
var dingSound = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
var blackHoleAppear = SKAction.playSoundFileNamed("black_hole_hi.wav", waitForCompletion: false)
var blackHoleBye = SKAction.playSoundFileNamed("black_hole_bye.wav", waitForCompletion: false)
var moldSucc = SKAction.playSoundFileNamed("mold_succ.wav", waitForCompletion: false)
var cardFlipSound = SKAction.playSoundFileNamed("card flip.wav", waitForCompletion: false)
var laserSound = SKAction.playSoundFileNamed("laser.wav", waitForCompletion: false)
var deadSound = SKAction.playSoundFileNamed("dead.wav", waitForCompletion: false)
var kissSound = SKAction.playSoundFileNamed("kiss.wav", waitForCompletion: false)
var fightSound = SKAction.playSoundFileNamed("fight sound_mixdown.wav", waitForCompletion: false)
var badCardSound = SKAction.playSoundFileNamed("bad card.wav", waitForCompletion: false)
var gemCollectSound = SKAction.playSoundFileNamed("gem collect.wav", waitForCompletion: false)
var crunchSound = SKAction.playSoundFileNamed("crunch.wav", waitForCompletion: false)
var gemCaseSound = SKAction.playSoundFileNamed("gem case.wav", waitForCompletion: false)
var chestSound = SKAction.playSoundFileNamed("chest.wav", waitForCompletion: false)
var wormAppearSound = SKAction.playSoundFileNamed("worm appear.wav", waitForCompletion: false)
var cameraSound = SKAction.playSoundFileNamed("camera.wav", waitForCompletion: false)
var fairySound = SKAction.playSoundFileNamed("sparkle.mp3", waitForCompletion: false)
var powerDownSound = SKAction.playSoundFileNamed("powerdown.wav", waitForCompletion: false)
var plinkingSound = SKAction.playSoundFileNamed("plinking.wav", waitForCompletion: false)
var reinvest = SKAction.playSoundFileNamed("quest complete.wav", waitForCompletion: false)
var achieveSound = SKAction.playSoundFileNamed("achieve.wav", waitForCompletion: false)
var addSound = SKAction.playSoundFileNamed("bubble 2.wav", waitForCompletion: false)
var snipSound = SKAction.playSoundFileNamed("snip.wav", waitForCompletion: false)
var questSound = SKAction.playSoundFileNamed("quest complete.wav", waitForCompletion: false)

//helper functions
func randomInRange(lo: Int, hi : Int) -> Int {
    return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
}

//add suffix to long numbers
func formatNumber(points: BInt) -> String {
    let cashString = String(describing: points)
    if (cashString.count < 4) {
        return String(describing: points)
    }
    else {
        let charsCount = cashString.count
        var cashDisplayString = cashString[0]
        
        var suffix = ""
        switch charsCount {
        case 4:
            suffix = "K"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 5:
            suffix = "K"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 6:
            suffix = "K"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 7:
            suffix = "M"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 8:
            suffix = "M"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 9:
            suffix = "M"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 10:
            suffix = "B"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 11:
            suffix = "B"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 12:
            suffix = "B"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 13:
            suffix = "T"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 14:
            suffix = "T"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 15:
            suffix = "T"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 16:
            suffix = "Q"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 17:
            suffix = "Q"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 18:
            suffix = "Q"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 19:
            suffix = "Qi"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 20:
            suffix = "Qi"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 21:
            suffix = "Qi"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 22:
            suffix = "Se"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 23:
            suffix = "Se"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 24:
            suffix = "Se"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 25:
            suffix = "Sp"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 26:
            suffix = "Sp"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 27:
            suffix = "Sp"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 28:
            suffix = "Oc"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 29:
            suffix = "Oc"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 30:
            suffix = "Oc"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        case 31:
            suffix = "No"
            cashDisplayString = cashDisplayString + "." + cashString[1]
            break
        case 32:
            suffix = "No"
            cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2]
            break
        case 33:
            suffix = "No"
            cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3]
            break
        default:
            suffix = "D"
            break
        }
        cashDisplayString += " "
        cashDisplayString += suffix
        
        return cashDisplayString
    }
}
