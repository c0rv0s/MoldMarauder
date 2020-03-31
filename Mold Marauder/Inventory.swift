//
//  Inventory.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 2/2/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import UIKit

class Inventory: NSObject, NSCoding {
    
    var level: Int
    var scorePerTap: BInt
    var levelUpCost: BInt
    var scorePerSecond: BInt
    var cash: BInt
    var diamonds: Int
    
    var molds: Array<Mold>
    var unlockedMolds: Array<Mold>
    var displayMolds: Array<Mold>
    
    var displayAmount: Int
    
    var deathRay: Bool
    var incubator: Int
    var laser: Int
    var autoTap: Bool
    var autoTapLevel: Int
    
    var wormsKilled: Int
    var achieveDiamonds: Int
    var achievementsDicc: [String:Bool]
    
    var levDicc: [String:Int]
    
    var moldCountDicc: [String:Int]
    
    var repelTimer: Int
    var xTapAmount: Int
    var xTapCount: Int
    var spritzAmount: Int
    var spritzCount: Int
    
    var currentQuest: String
    var questGoal: Int
    var questAmount: Int
    var questReward: Int
    
    var background = "cave"
    
    var tutorialProgress: Int
    
    var likedFB: Bool
    
    var muteMusic: Bool
    var muteSound: Bool
    
    var quitTime: Int
    var offlineLevel: Int
    
    var reinvestmentCount: Int
    var timePrisonEnabled: Bool
    var riftUnlocked: Bool
    var freedFromTimePrison: Array<Bool>
    var phaseCrystals: BInt
    var newPhaseCrystals: BInt
    
    override init() {
        level = 0
        scorePerTap = 10
        levelUpCost = 2500
        scorePerSecond = 0
        cash = BInt("250")!
        diamonds = 10
        molds = []
        unlockedMolds = [Mold(moldType: MoldType.slime), Mold(moldType: MoldType.cave), Mold(moldType: MoldType.sad), Mold(moldType: MoldType.angry)]
        displayMolds = []
        displayAmount = 25
        deathRay = false
        incubator = 0
        laser = 0
        wormsKilled = 0
        achieveDiamonds = 0
        
        autoTap = false
        autoTapLevel = 0
        
        repelTimer = 0
        xTapAmount = 0
        xTapCount = 0
        spritzAmount = 0
        spritzCount = 0
        
        tutorialProgress = 0
        
        currentQuest = ""
        questGoal = 0
        questAmount = 0
        questReward = 0
        
        likedFB = false
        
        muteMusic = false
        muteSound = false
        
        quitTime = 0
        offlineLevel = 0
        
        reinvestmentCount = 0
        timePrisonEnabled = false
        phaseCrystals = BInt("0")!
        newPhaseCrystals = BInt("0")!
        freedFromTimePrison = [false, false, false, false, false, false, false, false, false]
        
        riftUnlocked = false
        
        achievementsDicc = [
            "own 5" : false,
            "own 25" : false,
            "own 100" : false,
            "own 250" : false,
            "own 1000" : false,
            "kill 20" : false,
            "kill 100" : false,
            "kill 500" : false,
            "kill 5000" : false,
            "kill 10000" : false,
            "breed 5" : false,
            "breed 25" : false,
            "breed 42" : false,
            "lev 6 inc" : false,
            "lev 3 laser" : false,
            "death ray" : false,
            "level 10" : false,
            "level 20" : false,
            "level 30" : false,
            "level 40" : false,
            "level 50" : false,
            "level 60" : false,
            "level 70" : false,
            "level 75" : false,
            "max cash" : false
        ]

        levDicc = [
            "Slime Mold":0,
            "Cave Mold":0,
            "Sad Mold":0,
            "Angry Mold":0,
            "Alien Mold":0,
            "Pimply Mold":0,
            "Freckled Mold":0,
            "Hypno Mold":0,
            "Rainbow Mold":0,
            "Aluminum Mold":0,
            "Circuit Mold":0,
            "Hologram Mold":0,
            "Storm Mold":0,
            "Bacteria Mold":0,
            "Virus Mold":0,
            "X Mold":0,
            "Flower Mold":0,
            "Bee Mold":0,
            "Disaffected Mold":0,
            "Olive Mold":0,
            "Coconut Mold":0,
            "Sick Mold":0,
            "Dead Mold":0,
            "Zombie Mold":0,
            "Cloud Mold":0,
            "Rock Mold":0,
            "Water Mold":0,
            "Crystal Mold":0,
            "Nuclear Mold":0,
            "Astronaut Mold":0,
            "Sand Mold":0,
            "Glass Mold":0,
            "Coffee Mold":0,
            "Slinky Mold":0,
            "Magma Mold":0,
            "Samurai Mold":0,
            "Orange Mold":0,
            "Strawberry Mold":0,
            "TShirt Mold":0,
            "Cryptid Mold":0,
            "Angel Mold":0,
            "Invisible Mold":0,
            "Star Mold":0,
            "Metaphase Mold":0,
            "God Mold": 0
        ]
        
        moldCountDicc = [
            "Slime Mold":0,
            "Cave Mold":0,
            "Sad Mold":0,
            "Angry Mold":0,
            "Alien Mold":0,
            "Pimply Mold":0,
            "Freckled Mold":0,
            "Hypno Mold":0,
            "Rainbow Mold":0,
            "Aluminum Mold":0,
            "Circuit Mold":0,
            "Hologram Mold":0,
            "Storm Mold":0,
            "Bacteria Mold":0,
            "Virus Mold":0,
            "X Mold":0,
            "Flower Mold":0,
            "Bee Mold":0,
            "Disaffected Mold":0,
            "Olive Mold":0,
            "Coconut Mold":0,
            "Sick Mold":0,
            "Dead Mold":0,
            "Zombie Mold":0,
            "Cloud Mold":0,
            "Rock Mold":0,
            "Water Mold":0,
            "Crystal Mold":0,
            "Nuclear Mold":0,
            "Astronaut Mold":0,
            "Sand Mold":0,
            "Glass Mold":0,
            "Coffee Mold":0,
            "Slinky Mold":0,
            "Magma Mold":0,
            "Samurai Mold":0,
            "Orange Mold":0,
            "Strawberry Mold":0,
            "TShirt Mold":0,
            "Cryptid Mold":0,
            "Angel Mold":0,
            "Invisible Mold":0,
            "Star Mold":0,
            "Metaphase Mold":0,
            "God Mold": 0
        ]
    }
    
    //for loading a saved game
    required init(coder aDecoder: NSCoder) {
        level = aDecoder.decodeInteger(forKey: "level")
        scorePerTap = BInt(aDecoder.decodeObject(forKey: "scorePerTap") as! String)!
        levelUpCost = BInt(aDecoder.decodeObject(forKey: "levelUpCost") as! String)!
        scorePerSecond = BInt(aDecoder.decodeObject(forKey: "scorePerSecond") as! String)!
        cash = BInt(aDecoder.decodeObject(forKey: "cash") as! String)!
        diamonds = aDecoder.decodeInteger(forKey: "diamonds")
        displayAmount = aDecoder.decodeInteger(forKey: "displayAmount")
        deathRay = aDecoder.decodeBool(forKey: "deathRay")
        incubator = aDecoder.decodeInteger(forKey: "incubator")
        laser = aDecoder.decodeInteger(forKey: "laser")
        wormsKilled = aDecoder.decodeInteger(forKey: "wormsKilled")
        achieveDiamonds = aDecoder.decodeInteger(forKey: "achieveDiamonds")
        autoTap = aDecoder.decodeBool(forKey: "autoTap")
        autoTapLevel = aDecoder.decodeInteger(forKey: "autoTapLevel")
        repelTimer = aDecoder.decodeInteger(forKey: "repelTimer")
        xTapAmount = aDecoder.decodeInteger(forKey: "xTapAmount")
        xTapCount = aDecoder.decodeInteger(forKey: "xTapCount")
        spritzAmount = aDecoder.decodeInteger(forKey: "spritzAmount")
        spritzCount = aDecoder.decodeInteger(forKey: "spritzCount")
        background = aDecoder.decodeObject(forKey: "background") as! String
        currentQuest = aDecoder.decodeObject(forKey: "currentQuest") as! String
        questAmount = aDecoder.decodeInteger(forKey: "questAmount")
        questGoal = aDecoder.decodeInteger(forKey: "questGoal")
        questReward = aDecoder.decodeInteger(forKey: "questReward")
        likedFB = aDecoder.decodeBool(forKey: "likedFB")
        muteSound = aDecoder.decodeBool(forKey: "muteSound")
        muteMusic = aDecoder.decodeBool(forKey: "muteMusic")
        
        tutorialProgress = aDecoder.decodeInteger(forKey: "tutorialProgress")
        
        reinvestmentCount = aDecoder.decodeInteger(forKey: "reinvestmentCount")
        timePrisonEnabled = aDecoder.decodeBool(forKey: "timePrisonEnabled")
        phaseCrystals = BInt(aDecoder.decodeObject(forKey: "phaseCrystals") as! String)!
        newPhaseCrystals = BInt(aDecoder.decodeObject(forKey: "newPhaseCrystals") as! String)!
        freedFromTimePrison = aDecoder.decodeObject(forKey: "freedFromTimePrison") as! Array<Bool>
        
        riftUnlocked = aDecoder.decodeBool(forKey: "riftUnlocked")
        
        let saveMolds = aDecoder.decodeObject(forKey: "molds") as! Array<Int>
        let saveDisplayMolds = aDecoder.decodeObject(forKey: "displayMolds") as! Array<Int>
        let saveUnlockedMolds = aDecoder.decodeObject(forKey: "unlockedMolds") as! Array<Int>
        
        self.molds = [Mold]()
        for mold in saveMolds {
            self.molds.append(Mold(moldType: MoldType(rawValue: mold)!))
        }
        self.displayMolds = [Mold]()
        for mold in saveDisplayMolds {
            self.displayMolds.append(Mold(moldType: MoldType(rawValue: mold)!))
        }
        self.unlockedMolds = [Mold]()
        for mold in saveUnlockedMolds {
            self.unlockedMolds.append(Mold(moldType: MoldType(rawValue: mold)!))
        }
        
        achievementsDicc = aDecoder.decodeObject(forKey: "achievementsDicc") as! [String : Bool]
        if aDecoder.decodeObject(forKey: "levDicc") != nil {
            levDicc = aDecoder.decodeObject(forKey: "levDicc") as! [String : Int]
        }
        else {
            levDicc = [
                "Slime Mold":0,
                "Cave Mold":0,
                "Sad Mold":0,
                "Angry Mold":0,
                "Alien Mold":0,
                "Pimply Mold":0,
                "Freckled Mold":0,
                "Hypno Mold":0,
                "Rainbow Mold":0,
                "Aluminum Mold":0,
                "Circuit Mold":0,
                "Hologram Mold":0,
                "Storm Mold":0,
                "Bacteria Mold":0,
                "Virus Mold":0,
                "X Mold":0,
                "Flower Mold":0,
                "Bee Mold":0,
                "Disaffected Mold":0,
                "Olive Mold":0,
                "Coconut Mold":0,
                "Sick Mold":0,
                "Dead Mold":0,
                "Zombie Mold":0,
                "Cloud Mold":0,
                "Rock Mold":0,
                "Water Mold":0,
                "Crystal Mold":0,
                "Nuclear Mold":0,
                "Astronaut Mold":0,
                "Sand Mold":0,
                "Glass Mold":0,
                "Coffee Mold":0,
                "Slinky Mold":0,
                "Magma Mold":0,
                "Samurai Mold":0,
                "Orange Mold":0,
                "Strawberry Mold":0,
                "TShirt Mold":0,
                "Cryptid Mold":0,
                "Angel Mold":0,
                "Invisible Mold":0,
                "Star Mold":0,
                "Metaphase Mold":0,
                "God Mold": 0
            ]
        }
        
        if aDecoder.decodeObject(forKey: "moldCountDicc") != nil {
            moldCountDicc = aDecoder.decodeObject(forKey: "moldCountDicc") as! [String : Int]
        }
        else {
            moldCountDicc = [
                "Slime Mold":0,
                "Cave Mold":0,
                "Sad Mold":0,
                "Angry Mold":0,
                "Alien Mold":0,
                "Pimply Mold":0,
                "Freckled Mold":0,
                "Hypno Mold":0,
                "Rainbow Mold":0,
                "Aluminum Mold":0,
                "Circuit Mold":0,
                "Hologram Mold":0,
                "Storm Mold":0,
                "Bacteria Mold":0,
                "Virus Mold":0,
                "X Mold":0,
                "Flower Mold":0,
                "Bee Mold":0,
                "Disaffected Mold":0,
                "Olive Mold":0,
                "Coconut Mold":0,
                "Sick Mold":0,
                "Dead Mold":0,
                "Zombie Mold":0,
                "Cloud Mold":0,
                "Rock Mold":0,
                "Water Mold":0,
                "Crystal Mold":0,
                "Nuclear Mold":0,
                "Astronaut Mold":0,
                "Sand Mold":0,
                "Glass Mold":0,
                "Coffee Mold":0,
                "Slinky Mold":0,
                "Magma Mold":0,
                "Samurai Mold":0,
                "Orange Mold":0,
                "Strawberry Mold":0,
                "TShirt Mold":0,
                "Cryptid Mold":0,
                "Angel Mold":0,
                "Invisible Mold":0,
                "Star Mold":0,
                "Metaphase Mold":0,
                "God Mold": 0
            ]
            
            for m in self.molds {
                moldCountDicc[m.name]! += 1
            }
        }
        quitTime = aDecoder.decodeInteger(forKey: "quitTime")
        offlineLevel = aDecoder.decodeInteger(forKey: "offlineLevel")
        
    }
    
    //for saving the game
    func encode(with aCoder: NSCoder) {
        //non array or dictionary stuff
        //like ints and booleans
        
        aCoder.encode(level, forKey: "level")
        let sScorePerTap = String(describing: scorePerTap)
        let sLevelUpCost = String(describing: levelUpCost)
        let sScorePerSecond = String(describing: scorePerSecond)
        let sCash = String(describing: cash)
        aCoder.encode(sScorePerTap, forKey: "scorePerTap")
        aCoder.encode(sLevelUpCost, forKey: "levelUpCost")
        aCoder.encode(sScorePerSecond, forKey: "scorePerSecond")
        aCoder.encode(sCash, forKey: "cash")
        aCoder.encode(diamonds, forKey: "diamonds")
        aCoder.encode(displayAmount, forKey: "displayAmount")
        aCoder.encode(deathRay, forKey: "deathRay")
        aCoder.encode(incubator, forKey: "incubator")
        aCoder.encode(laser, forKey: "laser")
        aCoder.encode(wormsKilled, forKey: "wormsKilled")
        aCoder.encode(achieveDiamonds, forKey: "achieveDiamonds")
        
        aCoder.encode(autoTap, forKey: "autoTap")
        aCoder.encode(autoTapLevel, forKey: "autoTapLevel")
        
        aCoder.encode(repelTimer, forKey: "repelTimer")
        aCoder.encode(xTapAmount, forKey: "xTapAmount")
        aCoder.encode(xTapCount, forKey: "xTapCount")
        aCoder.encode(spritzAmount, forKey: "spritzAmount")
        aCoder.encode(spritzCount, forKey: "spritzCount")
        aCoder.encode(background, forKey: "background")
        aCoder.encode(currentQuest, forKey: "currentQuest")
        aCoder.encode(questGoal, forKey: "questGoal")
        aCoder.encode(questAmount, forKey: "questAmount")
        aCoder.encode(questReward, forKey: "questReward")
        aCoder.encode(likedFB, forKey: "likedFB")
        aCoder.encode(muteMusic, forKey: "muteMusic")
        aCoder.encode(muteSound, forKey: "muteSound")
        
        aCoder.encode(tutorialProgress, forKey: "tutorialProgress")
        
        aCoder.encode(reinvestmentCount, forKey: "reinvestmentCount")
        aCoder.encode(timePrisonEnabled, forKey: "timePrisonEnabled")
        aCoder.encode(String(describing: phaseCrystals), forKey: "phaseCrystals")
        aCoder.encode(String(describing: newPhaseCrystals), forKey: "newPhaseCrystals")
        aCoder.encode(freedFromTimePrison, forKey: "freedFromTimePrison")
        aCoder.encode(riftUnlocked, forKey: "riftUnlocked")
        
        //now for achievmeents and molds
        var saveMolds = [Int]()
        for mold in molds {
            saveMolds.append(mold.moldType.rawValue)
        }
        var saveDisplayMolds = [Int]()
        for mold in displayMolds {
            saveDisplayMolds.append(mold.moldType.rawValue)
        }
        var saveUnlockedMolds = [Int]()
        for mold in unlockedMolds {
            saveUnlockedMolds.append(mold.moldType.rawValue)
        }
        
        aCoder.encode(saveMolds, forKey: "molds")
        aCoder.encode(saveDisplayMolds, forKey: "displayMolds")
        aCoder.encode(saveUnlockedMolds, forKey: "unlockedMolds")
        aCoder.encode(achievementsDicc, forKey: "achievementsDicc")
        
        aCoder.encode(levDicc, forKey: "levDicc")
        aCoder.encode(moldCountDicc, forKey: "moldCountDicc")
        
        // using current date and time as an example
        let someDate = Date()
        
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970
        
        // convert to Integer
        let myInt = Int(timeInterval)
        
        aCoder.encode(myInt, forKey: "quitTime")
        aCoder.encode(offlineLevel, forKey: "offlineLevel")
    }
    
    //various internal calculations
    func incrementLevel() {
        level += 1
        cash -= levelUpCost
        calculateScorePerTap()
    }
    
    func calculateScorePerTap() {
        switch(level) {
        case 0:
            scorePerTap = BInt(10)
            levelUpCost = BInt(2500)
            break
        case 1:
            scorePerTap = BInt(40)
            levelUpCost = BInt(5000)
            break
        case 2:
            scorePerTap = BInt(60)
            levelUpCost = BInt(10000)
            break
        case 3:
            scorePerTap = BInt(80)
            levelUpCost = BInt(20000)
            break
        case 4:
            scorePerTap = BInt(250)
            levelUpCost = BInt(40000)
            break
        case 5:
            scorePerTap = BInt(500)
            levelUpCost = BInt(80000)
            break
        case 6:
            scorePerTap = BInt(800)
            levelUpCost = BInt(160000)
            break
        case 7:
            scorePerTap = BInt(1250)
            levelUpCost = BInt(320000)
            break
        case 8:
            scorePerTap = BInt("2750")!
            levelUpCost = BInt("640000")!
            break
        case 9:
            scorePerTap = BInt("3250")!
            levelUpCost = BInt("1200000")!
            break
        case 10:
            scorePerTap = BInt("5000")!
            levelUpCost = BInt("2400000")!
            break
        case 11:
            scorePerTap = BInt("8000")!
            levelUpCost = BInt("4800000")!
            break
        case 12:
            scorePerTap = BInt("12000")!
            levelUpCost = BInt("9600000")!
            break
        case 13:
            scorePerTap = BInt("18000")!
            levelUpCost = BInt("18000000")!
            break
        case 14:
            scorePerTap = BInt("32000")!
            levelUpCost = BInt("36000000")!
            break
        case 15:
            scorePerTap = BInt("64000")!
            levelUpCost = BInt("72000000")!
            break
        case 16:
            scorePerTap = BInt("80000")!
            levelUpCost = BInt("108000000")!
            break
        case 17:
            scorePerTap = BInt("100000")!
            levelUpCost = BInt("162000000")!
            break
        case 18:
            scorePerTap = BInt("125000")!
            levelUpCost = BInt("243000000")!
            break
        case 19:
            scorePerTap = BInt("156250")!
            levelUpCost = BInt("364500000")!
            break
        case 20:
            scorePerTap = BInt("195312")!
            levelUpCost = BInt("546750000")!
            break
        case 21:
            scorePerTap = BInt("244140")!
            levelUpCost = BInt("820125000")!
            break
        case 22:
            scorePerTap = BInt("305175")!
            levelUpCost = BInt("1230187500")!
            break
        case 23:
            scorePerTap = BInt("381468")!
            levelUpCost = BInt("1845281250")!
            break
        case 24:
            scorePerTap = BInt("686642")!
            levelUpCost = BInt("2767921875")!
            break
        case 25:
            scorePerTap = BInt("8926352")!
            levelUpCost = BInt("4151882812")!
            break
        case 26:
            scorePerTap = BInt("1115793")!
            levelUpCost = BInt("6300000000")!
            break
        case 27:
            scorePerTap = BInt("1394741")!
            levelUpCost = BInt("9450000000")!
            break
        case 28:
            scorePerTap = BInt("1743426")!
            levelUpCost = BInt("14175000000")!
            break
        case 29:
            scorePerTap = BInt("2266454")!
            levelUpCost = BInt("21262500000")!
            break
        case 30:
            scorePerTap = BInt("3173036")!
            levelUpCost = BInt("31893750000")!
            break
        case 31:
            scorePerTap = BInt("3966295")!
            levelUpCost = BInt("47840625000")!
            break
        case 32:
            scorePerTap = BInt("4957869")!
            levelUpCost = BInt("71760937500")!
            break
        case 33:
            scorePerTap = BInt("6197336")!
            levelUpCost = BInt("107641406250")!
            break
        case 34:
            scorePerTap = BInt("9296004")!
            levelUpCost = BInt("161462109375")!
            break
        case 35:
            scorePerTap = BInt("11620005")!
            levelUpCost = BInt("258339375000")!
            break
        case 36:
            scorePerTap = BInt("145250060")!
            levelUpCost = BInt("413343000000")!
            break
        case 37:
            scorePerTap = BInt("217875090")!
            levelUpCost = BInt("661348800000")!
            break
        case 38:
            scorePerTap = BInt("2723438060")!
            levelUpCost = BInt("1058158080000")!
            break
        case 39:
            scorePerTap = BInt("3404298300")!
            levelUpCost = BInt("1693052928000")!
            break
        case 40:
            scorePerTap = BInt("6127737000")!
            levelUpCost = BInt("2708884684800")!
            break
        case 41:
            scorePerTap = BInt("7659671200")!
            levelUpCost = BInt("4334215495680")!
            break
        case 42:
            scorePerTap = BInt("957500000")!
            levelUpCost = BInt("6934744793088")!
            break
        case 43:
            scorePerTap = BInt("11968750000")!
            levelUpCost = BInt("11095591668940")!
            break
        case 44:
            scorePerTap = BInt("21543750000")!
            levelUpCost = BInt("17600000000000")!
            break
        case 45:
            scorePerTap = BInt("26929687500")!
            levelUpCost = BInt("28160000000000")!
            break
        case 46:
            scorePerTap = BInt("33750000000")!
            levelUpCost = BInt("45056000000000")!
            break
        case 47:
            scorePerTap = BInt("42187500000")!
            levelUpCost = BInt("72089600000000")!
            break
        case 48:
            scorePerTap = BInt("105468750000")!
            levelUpCost = BInt("115343360000000")!
            break
        case 49:
            scorePerTap = BInt("158203125000")!
            levelUpCost = BInt("184549376000000")!
            break
        case 50:
            scorePerTap = BInt("237304687005")!
            levelUpCost = BInt("295279001600000")!
            break
        case 51:
            scorePerTap = BInt("355957031200")!
            levelUpCost = BInt("531502202880000")!
            break
        case 52:
            scorePerTap = BInt("533935546800")!
            levelUpCost = BInt("956703965184000")!
            break
        case 53:
            scorePerTap = BInt("8009033203000")!
            levelUpCost = BInt("1722067137331200")!
            break
        case 54:
            scorePerTap = BInt("1201354980400")!
            levelUpCost = BInt("3099720847196160")!
            break
        case 55:
            scorePerTap = BInt("3604064941400")!
            levelUpCost = BInt("5579497524953088")!
            break
        case 56:
            scorePerTap = BInt("10812194824200")!
            levelUpCost = BInt("10043095544915560")!
            break
        case 57:
            scorePerTap = BInt("32436584472600")!
            levelUpCost = BInt("18077571980848000")!
            break
        case 58:
            scorePerTap = BInt("97309753417900")!
            levelUpCost = BInt("32539629565526410")!
            break
        case 59:
            scorePerTap = BInt("15000000000000")!
            levelUpCost = BInt("58571333217947540")!
            break
        case 60:
            scorePerTap = BInt("22500000000000")!
            levelUpCost = BInt("105428399792305617")!
            break
        case 61:
            scorePerTap = BInt("33750000000000")!
            levelUpCost = BInt("100897711196261517")!
            break
        case 62:
            scorePerTap = BInt("506250000000000")!
            levelUpCost = BInt("3415880153270000717")!
            break
        case 63:
            scorePerTap = BInt("6328125000000000")!
            levelUpCost = BInt("61485842758872600017")!
            break
        case 64:
            scorePerTap = BInt("69492187500000000")!
            levelUpCost = BInt("720000000000000000000")!
            break
        case 65:
            scorePerTap = BInt("2135742187500000000")!
            levelUpCost = BInt("67000000000000000000000")!
            break
        case 66:
            scorePerTap = BInt("64072265625000000000")!
            levelUpCost = BInt("480000000000000000000000")!
            break
        case 67:
            scorePerTap = BInt("192216796875000000000")!
            levelUpCost = BInt("1200000000000000000000000")!
            break
        case 68:
            scorePerTap = BInt("961083984375000000000")!
            levelUpCost = BInt("34000000000000000000000000")!
            break
        case 69:
            scorePerTap = BInt("2883251953125000000000")!
            levelUpCost = BInt("560000000000000000000000000")!
            break
        case 70:
            scorePerTap = BInt("864975585937500000000000")!
            levelUpCost = BInt("7900000000000000000000000000")!
            break
        case 71:
            scorePerTap = BInt("2594926757812500000000000")!
            levelUpCost = BInt("9100000000000000000000000000")!
            break
        case 72:
            scorePerTap = BInt("32436584472656250000000000")!
            levelUpCost = BInt("65000000000000000000000000000")!
            break
        case 73:
            scorePerTap = BInt("424365844726562500000000000")!
            levelUpCost = BInt("780000000000000000000000000000")!
            break
        case 74:
            scorePerTap = BInt("7243658447265625000000000000")!
            levelUpCost = BInt("5600000000000000000000000000000")!
            break
        case 75:
            scorePerTap = BInt("112436584472656250000000000000")!
            levelUpCost = BInt("49000000000000000000000000000000")!
            break
            
        default:
            scorePerTap = BInt("112436584472656250000000000000")!
            levelUpCost = BInt("49000000000000000000000000000000")!
            break
        }
    }
}
