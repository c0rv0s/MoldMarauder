//
//  GameViewController.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 1/31/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import UIKit
import SpriteKit
import StoreKit

class GameViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var scene: GameScene!
    var moldShop: MoldShop!
    var breedScene: BreedScene!
    var menu : MenuScene!
    var itemShop: ItemShop!
    var levelScene: LevelScene!
    var premiumShop: PremiumShop!
    var achievements: AchievementsScene!
    var inventory: Inventory!
    var inventoryScene: MoldInventory!
    var creditsScene: CreditsScene!
    var questScene: QuestScene!
    var skView: SKView!
    
    var combos: Combos!
    
    var preventNoTapAbuse: Timer? = nil
    
    @IBOutlet weak var cashHeader: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    
    var cashTimer: Timer? = nil
    var autoTapTimer: Timer? = nil

    //IAP
    let TINY_PRODUCT_ID = "com.SpaceyDreams.MoldMarauder.mold_99_cent_diamond"
    let SMALL_PRODUCT_ID = "com.SpaceyDreams.MoldMarauder.mold_299_cent_diamond"
    let MEDIUM_PRODUCT_ID = "com.SpaceyDreams.MoldMarauder.mold_999_cent_diamond"
    let LARGE_PRODUCT_ID = "com.SpaceyDreams.MoldMarauder.mold_4999_cent_diamond"
    let STAR_PRODUCT_ID = "com.SpaceyDreams.MoldMarauder.mold_star"
    let DEATH_RAY_PRODUCT_ID = "com.SpaceyDreams.MoldMarauder.mold_death_ray"
    let AUTO_TAP_PRODUCT_ID = "com.SpaceyDreams.MoldMarauder.mold_auto_tap"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var nonConsumablePurchaseMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseMade")
    var diamonds = UserDefaults.standard.integer(forKey: "diamonds")  //this is probably changed to diamodns
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAvailableProducts()
        
        let defaults = UserDefaults.standard
        
        //instantiate player inventory
        if let savedInventory = defaults.object(forKey: "inventory") as? Data {
            inventory = NSKeyedUnarchiver.unarchiveObject(with: savedInventory) as! Inventory
        }
        else {
            inventory = Inventory()
        }

        // Configure the view.
        skView = view as! SKView
        skView.isMultipleTouchEnabled = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.name = "scene"
        scene.scaleMode = .aspectFill
        scene.touchHandler = handleTap
        
        //load the data that's displayed in the scene
        scene.molds = inventory.molds   //this line might be unnecessary
        scene.numDiamonds = inventory.diamonds
        scene.tapPoint = inventory.scorePerTap
        //set worm difficulty based on level
        if inventory.level < 29 {
            scene.wormDifficulty = 6 - inventory.laser
        }
        else {
            scene.wormDifficulty = 9 - inventory.laser
        }
        //instaniate the combos
        combos = Combos()
        
        
        //load the saved data if there is any
        if inventory.displayMolds.count > 0 {
            scene.molds = inventory.displayMolds
            scene.updateMolds()
        }
        if inventory.repelTimer > 0 {
            scene.wormRepel = true
            scene.wormRepelCount = inventory.repelTimer
        }
        if inventory.xTapCounter > 0 {
            scene.xTapAmount = inventory.xTapAmount
            scene.xTapCount = inventory.xTapCounter
        }
        if inventory.spritzCounter > 0 {
            scene.spritzAmount = inventory.spritzAmount
            scene.spritzCount = inventory.spritzAmount
        }
        
        // Present the scene.
        skView.presentScene(scene)
        if inventory.background != "cave" {
            scene.backgroundName = inventory.background
            scene.setBackground()
        }
        scene.diamondCLabel.text = String(inventory.diamonds)

        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.myObserverMethod(notification:)), name: .UIApplicationDidEnterBackground, object: nil)
        
        if inventory.currentQuest == "" {
            generateQuest()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //super.viewDidAppear(true)
        reactivateCashTimer()
    }
    
    func reactivateCashTimer() {
        cashTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.addCash), userInfo: nil, repeats: true)
        activateSleepTimer()
    }

    func myObserverMethod(notification : NSNotification) {
        print("Observer method called")
        scene.eventTimer.invalidate()
        cashTimer?.invalidate()
        cashTimer = nil
        preventNoTapAbuse?.invalidate()
        save()
    }
    
    // MARK: - SLEEP
    func activateSleepTimer() {
        if preventNoTapAbuse != nil {
            preventNoTapAbuse?.invalidate()
        }
        
        preventNoTapAbuse = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(GameViewController.sleepMode), userInfo: nil, repeats: true)
        
        if cashTimer == nil {
            reactivateCashTimer()
        }
    }
    
    
    
    func save() {
        if scene.wormRepelCount > 0 {
            inventory.repelTimer = scene.wormRepelCount
        }
        if scene.spritzCount > 0 {
            inventory.spritzAmount = scene.spritzAmount
            inventory.spritzCounter = scene.spritzCount
        }
        if scene.xTapCount > 0 {
            inventory.xTapCounter = scene.xTapCount
            inventory.xTapAmount = scene.xTapAmount
        }
        
        let savedData = NSKeyedArchiver.archivedData(withRootObject: inventory)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "inventory")
    }
    
    func sleepMode() {
        if scene.isActive == false {
            if let dummy = moldShop {
                moldShop.scrollView?.removeFromSuperview()
            }
            if let dummy = breedScene {
                breedScene.scrollView?.removeFromSuperview()
            }
            if let dummy = inventoryScene {
                inventoryScene.scrollView?.removeFromSuperview()
            }
            if let dummy = levelScene {
                levelScene.scrollView?.removeFromSuperview()
            }
            
            incrementDiamonds(newDiamonds: 0)
            scene.molds = inventory.displayMolds
            scene.updateMolds()
            scene.isActive = true
            skView.presentScene(scene)
            
            scene.menuPopUp.removeFromParent()
        }
        preventNoTapAbuse?.invalidate()
        cashTimer?.invalidate()
        scene.sleep()
    }
    
    func generateQuest() {
        let questName = Int(arc4random_uniform(5))
        switch questName {
        case 0:
            //make a number of taps
            inventory.currentQuest = "tap"
            if inventory.level < 10 {
                inventory.questGoal = 250
            }
            else if inventory.level < 30 {
                inventory.questGoal = 800
            }
            else if inventory.level < 60 {
                inventory.questGoal = 2000
            }
            else {
                inventory.questGoal = 5000
            }
            inventory.questAmount = 0
            break
        case 1:
            //purchase 2 of most recently unlocked mold
            inventory.currentQuest = "p "
            var index = inventory.unlockedMolds.count - 1
            var recentMold = inventory.unlockedMolds[index].name
            inventory.currentQuest += recentMold
            inventory.questGoal = 2
            inventory.questAmount = 0
            break
        case 2:
            //discover a new breed
            inventory.currentQuest = "discover"
            inventory.questGoal = 1
            inventory.questAmount = 0
            break
        case 3:
            //kill some number of worms
            inventory.currentQuest = "kill"
            if inventory.level < 10 {
                inventory.questGoal = 8
            }
            else if inventory.level < 30 {
                inventory.questGoal = 20
            }
            else if inventory.level < 60 {
                inventory.questGoal = 35
            }
            else {
                inventory.questGoal = 50
            }
            inventory.questAmount = 0
            break
        case 4:
            //level up twice
            inventory.currentQuest = "level"
            inventory.questGoal = 2
            inventory.questAmount = 0
            break
        default:
            generateQuest()
        }
    }
    
    func questAchieved() {
        generateQuest()
    }
    
    // MARK: - HANDLERS
    // MENU HANDLER
    func menuHandler(action: String) {
        activateSleepTimer()
        if (action == "buy") {
            
            moldShop = MoldShop(size: skView.bounds.size)
            moldShop.name = "moldShop"
            moldShop.unlockedMolds = inventory.unlockedMolds
            moldShop.scaleMode = .resizeFill
            moldShop.touchHandler = shopHandler
            skView.presentScene(moldShop)
            menu.cometLayer.removeAllChildren()
            menu.cometTimer.invalidate()
            moldShop.playSound(select: "select")
        }
        if (action == "item") {
            
            itemShop = ItemShop(size: skView.bounds.size)
            itemShop.name = "itemShop"
            itemShop.scaleMode = .resizeFill
            itemShop.touchHandler = itemHandler
            itemShop.laserBought = inventory.laser
            skView.presentScene(itemShop)
            menu.cometLayer.removeAllChildren()
            menu.cometTimer.invalidate()
            itemShop.playSound(select: "select")
        }
        if (action == "credits") {
            
            creditsScene = CreditsScene(size: skView.bounds.size)
            creditsScene.name = "creditsScene"
            creditsScene.scaleMode = .resizeFill
            creditsScene.touchHandler = creditsHandler
            skView.presentScene(creditsScene)
            menu.cometLayer.removeAllChildren()
            menu.cometTimer.invalidate()
            creditsScene.playSound(select: "select")
        }
        if (action == "quest") {
            
            questScene = QuestScene(size: skView.bounds.size)
            questScene.name = "questScene"
            questScene.scaleMode = .resizeFill
            questScene.touchHandler = questHandler
            questScene.currentQuest = inventory.currentQuest
            questScene.questGoal = inventory.questGoal
            questScene.questAmount = inventory.questAmount
            skView.presentScene(questScene)
            menu.cometLayer.removeAllChildren()
            menu.cometTimer.invalidate()
            questScene.playSound(select: "select")
        }
        if (action == "achieve") {
            
            achievements = AchievementsScene(size: skView.bounds.size)
            achievements.name = "achievements"
            achievements.scaleMode = .resizeFill
            achievements.touchHandler = achieveHandler
            //achievmens progress
            achievements.wormsKilled = inventory.wormsKilled
            achievements.moldsOwned = inventory.molds.count
            achievements.speciesBred = inventory.unlockedMolds.count
            achievements.incLevel = inventory.incubator
            achievements.laserLevel = inventory.laser
            achievements.deathRay = inventory.deathRay
            achievements.level = inventory.level
            
            achievements.rewardAmount = inventory.achieveDiamonds
            
            skView.presentScene(achievements)
            menu.cometLayer.removeAllChildren()
            menu.cometTimer.invalidate()
            achievements.playSound(select: "select")
        }
        if (action == "breed") {
            
            menu.cometLayer.removeAllChildren()
            menu.cometTimer.invalidate()
            breedScene = BreedScene(size: skView.bounds.size)
            breedScene.name = "breedScene"
            breedScene.unlockedMolds = inventory.unlockedMolds
            breedScene.scaleMode = .resizeFill
            breedScene.touchHandler = breedHandler
            
            //populate the owned molds array
            for mold in inventory.molds {
                var transferred = false
                if breedScene.ownedMolds.count > 0 {
                    for ownedMold in breedScene.ownedMolds {
                        if mold.moldType == ownedMold.moldType {
                            transferred = true
                            break
                        }
                    }
                    if transferred == false {
                        breedScene.ownedMolds.append(mold)
                    }
                }
                else {
                    breedScene.ownedMolds.append(mold)
                }
            }
            //populate the possible combos array
            if breedScene.ownedMolds.count > 0 {
                for combo in combos.allCombos {
                    var same = 0
                    //now check if the parents in the combo are the same as the molds in the orgy
                    //check same length
                        //now check if the orgy and the combo members match
                        for mold in breedScene.ownedMolds {
                            for parent in combo.parents {
                                if mold.name == parent.name {
                                    same += 1
                                }
                            }
                        }
                    if same == combo.parents.count {
                        var letsAdd = true
                        for mold in inventory.unlockedMolds {
                            if mold.moldType == combo.child.moldType {
                                letsAdd = false
                            }
                        }
                        if letsAdd == true {
                            breedScene.possibleCombos.append(combo)
                        }
                        
                    }
                }
            }
            
            print("possible combos")
            if breedScene.possibleCombos.count > 0 {
                breedScene.currentDiamondCombo = breedScene.possibleCombos[0]
                for combo in breedScene.possibleCombos {
                    print(combo.child.name)
                }
            }
            
            skView.presentScene(breedScene)
            breedScene.playSound(select: "select")
        }
        if (action == "exit") {
            scene.menuPopUp.size = skView.bounds.size
            
            let disappear = SKAction.scale(to: 0, duration: 0.2)
            //this is the godo case
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            exitMenu()
            scene.menuPopUp.run(action)
            
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
        }
        if (action == "cheat") {
            incrementCash(pointsToAdd: BInt("1000000000000"))
            incrementDiamonds(newDiamonds: 100)
        }
        if (action == "reset") {
            scene.moldLayer.removeAllChildren()
            inventory = Inventory()
            updateLabels()
        }
        if action == "level" {
            
            levelScene = LevelScene(size: skView.bounds.size)
            levelScene.name = "levelScene"
            levelScene.scaleMode = .resizeFill
            levelScene.touchHandler = levelHandler
            levelScene.currentLevel = inventory.level
            levelScene.currentLevelUpCost = inventory.levelUpCost
            levelScene.currentScorePerTap = inventory.scorePerTap
            levelScene.calculateScorePerTap()
            levelScene.cash = inventory.cash
            levelScene.current = inventory.background
            skView.presentScene(levelScene)
            menu.cometLayer.removeAllChildren()
            menu.cometTimer.invalidate()
            levelScene.playSound(select: "select")
        }
    }
    
    func exitMenu() {
        menu.cometLayer.removeAllChildren()
        menu.cometTimer.invalidate()
        scene.molds = inventory.displayMolds
        incrementDiamonds(newDiamonds: 0)
        if inventory.level < 29 {
            scene.wormDifficulty = 6 - inventory.laser
        }
        else {
            scene.wormDifficulty = 9 - inventory.laser
        }
        scene.updateMolds()
        scene.isActive = true
        skView.presentScene(scene)
        scene.playSound(select: "exit")
        //scene.reactivateTimer()
    }
    
    //LEVEL SCENE HANDLER
    func levelHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            levelScene.scrollView?.removeFromSuperview()
            levelScene.cometLayer.removeAllChildren()
            levelScene.cometTimer.invalidate()
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .resizeFill
            menu.touchHandler = menuHandler
            
            skView.presentScene(menu)
            menu.playSound(select: "exit")
        }
        if action == "level" {
            if (inventory.cash > inventory.levelUpCost) && inventory.level < 75 {
                inventory.incrementLevel()
                updateLabels()
                levelScene.cash = inventory.cash
                levelScene.currentLevel = inventory.level
                levelScene.currentLevelUpCost = inventory.levelUpCost
                levelScene.currentScorePerTap = inventory.scorePerTap
                levelScene.calculateScorePerTap()
                levelScene.buttonLayer.removeAllChildren()
                levelScene.createButton()
                levelScene.playSound(select: "levelup")
                if inventory.level == 15 || inventory.level == 30 || inventory.level == 45 || inventory.level == 60 || inventory.level == 75 {
                    levelScene.reloadScroll()
                }
                
                //achievements
                if inventory.level == 10 && inventory.achievementsDicc["level 10"] == false {
                    inventory.achievementsDicc["level 10"] = true
                    inventory.achieveDiamonds += 3
                }
                if inventory.level == 20 && inventory.achievementsDicc["level 20"] == false {
                    inventory.achievementsDicc["level 20"] = true
                    inventory.achieveDiamonds += 3
                }
                if inventory.level == 30 && inventory.achievementsDicc["level 30"] == false {
                    inventory.achievementsDicc["level 30"] = true
                    inventory.achieveDiamonds += 3
                }
                if inventory.level == 40 && inventory.achievementsDicc["level 40"] == false {
                    inventory.achievementsDicc["level 40"] = true
                    inventory.achieveDiamonds += 3
                }
                if inventory.level == 50 && inventory.achievementsDicc["level 50"] == false {
                    inventory.achievementsDicc["level 50"] = true
                    inventory.achieveDiamonds += 3
                }
                if inventory.level == 60 && inventory.achievementsDicc["level 60"] == false {
                    inventory.achievementsDicc["level 60"] = true
                    inventory.achieveDiamonds += 3
                }
                if inventory.level == 70 && inventory.achievementsDicc["level 70"] == false {
                    inventory.achievementsDicc["level 70"] = true
                    inventory.achieveDiamonds += 3
                }
                if inventory.level == 75 && inventory.achievementsDicc["level 75"] == false {
                    inventory.achievementsDicc["level 75"] = true
                    inventory.achieveDiamonds += 5
                }
                
                if inventory.currentQuest == "level" {
                    inventory.questAmount += 1
                    if inventory.questAmount == inventory.questGoal {
                        questAchieved()
                    }
                }
            }
        }
        if action == "cave" {
            inventory.background = "cave"
            scene.backgroundName = "cave"
            scene.setBackground()
        }
        if action == "crysForest" {
            inventory.background = "crystal forest"
            scene.backgroundName = "crystal forest"
            scene.setBackground()
        }
        if action == "apartment" {
            inventory.background = "apartment"
            scene.backgroundName = "apartment"
            scene.setBackground()
        }
        if action == "yachtEx" {
            inventory.background = "yacht exterior"
            scene.backgroundName = "yacht exterior"
            scene.setBackground()
        }
        if action == "apartment2" {
            inventory.background = "apartment 2"
            scene.backgroundName = "apartment 2"
            scene.setBackground()
        }
        if action == "yurt" {
            inventory.background = "yurt"
            scene.backgroundName = "yurt"
            scene.setBackground()
        }
        if action == "sand" {
            inventory.background = "sand castle"
            scene.backgroundName = "sand castle"
            scene.setBackground()
        }
        if action == "space" {
            inventory.background = "space"
            scene.backgroundName = "space"
            scene.setBackground()
        }
        if action == "space 2" {
            inventory.background = "space 2"
            scene.backgroundName = "space 2"
            scene.setBackground()
        }
    }
    
    // INVENTORY SCENE HANDLER
    func inventorySceneHandler(action: String) {
        activateSleepTimer()
        var type: MoldType!
        if action == "slimePlus" {
            type = MoldType.slime
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.slimeLabel.text = String(count + 1)
                }
            }
        }
        if action == "slimeMinus" {
            type = MoldType.slime
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.slimeLabel.text = String(count)
        }
        if action == "cavePlus" {
            type = MoldType.cave
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.caveLabel.text = String(count + 1)
                }
            }
        }
        if action == "caveMinus" {
            type = MoldType.cave
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.caveLabel.text = String(count)
        }
        if action == "sadPlus" {
            type = MoldType.sad
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.sadLabel.text = String(count + 1)
                }
            }
        }
        if action == "sadMinus" {
            type = MoldType.sad
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.sadLabel.text = String(count)
        }
        if action == "angryPlus" {
            type = MoldType.angry
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.angryLabel.text = String(count + 1)
                }
            }
        }
        if action == "angryMinus" {
            type = MoldType.angry
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.angryLabel.text = String(count)
        }
        if action == "alienPlus" {
            type = MoldType.alien
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.alienLabel.text = String(count + 1)
                }
            }
        }
        if action == "alienMinus" {
            type = MoldType.alien
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.alienLabel.text = String(count)
        }
        if action == "pimplyPlus" {
            type = MoldType.pimply
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.pimplyLabel.text = String(count + 1)
                }
            }
        }
        if action == "pimplyMinus" {
            type = MoldType.pimply
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.pimplyLabel.text = String(count)
        }
        if action == "freckledPlus" {
            type = MoldType.freckled
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.freckledLabel.text = String(count + 1)
                }
            }
        }
        if action == "freckledMinus" {
            type = MoldType.freckled
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.freckledLabel.text = String(count)
        }
        if action == "hypnoPlus" {
            type = MoldType.hypno
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.hypnoLabel.text = String(count + 1)
                }
            }
        }
        if action == "hypnoMinus" {
            type = MoldType.hypno
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.hypnoLabel.text = String(count)
        }
        if action == "rainbowPlus" {
            type = MoldType.rainbow
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.rainbowLabel.text = String(count + 1)
                }
            }
        }
        if action == "rainbowMinus" {
            type = MoldType.rainbow
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.rainbowLabel.text = String(count)
        }
        if action == "aluminumPlus" {
            type = MoldType.aluminum
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.aluminumLabel.text = String(count + 1)
                }
            }
        }
        if action == "aluminumMinus" {
            type = MoldType.aluminum
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.aluminumLabel.text = String(count)
        }
        if action == "circuitPlus" {
            type = MoldType.circuit
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.circuitLabel.text = String(count + 1)
                }
            }
        }
        if action == "circuitMinus" {
            type = MoldType.circuit
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.circuitLabel.text = String(count)
        }
        if action == "hologramPlus" {
            type = MoldType.hologram
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.hologramLabel.text = String(count + 1)
                }
            }
        }
        if action == "hologramMinus" {
            type = MoldType.hologram
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.hologramLabel.text = String(count)
        }
        if action == "stormPlus" {
            type = MoldType.storm
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.stormLabel.text = String(count + 1)
                }
            }
        }
        if action == "stormMinus" {
            type = MoldType.storm
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.stormLabel.text = String(count)
        }
        if action == "bacteriaPlus" {
            type = MoldType.bacteria
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.bacteriaLabel.text = String(count + 1)
                }
            }
        }
        if action == "bacteriaMinus" {
            type = MoldType.bacteria
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.bacteriaLabel.text = String(count)
        }
        if action == "virusPlus" {
            type = MoldType.virus
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.virusLabel.text = String(count + 1)
                }
            }
        }
        if action == "virusMinus" {
            type = MoldType.virus
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.virusLabel.text = String(count)
        }
        if action == "xPlus" {
            type = MoldType.x
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.xLabel.text = String(count + 1)
                }
            }
        }
        if action == "xMinus" {
            type = MoldType.x
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.xLabel.text = String(count)
        }
        if action == "flowerPlus" {
            type = MoldType.flower
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.flowerLabel.text = String(count + 1)
                }
            }
        }
        if action == "flowerMinus" {
            type = MoldType.flower
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.flowerLabel.text = String(count)
        }
        if action == "beePlus" {
            type = MoldType.bee
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.beeLabel.text = String(count + 1)
                }
            }
        }
        if action == "beeMinus" {
            type = MoldType.bee
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.beeLabel.text = String(count)
        }
        if action == "disaffectedPlus" {
            type = MoldType.disaffected
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.disaffectedLabel.text = String(count + 1)
                }
            }
        }
        if action == "disaffectedMinus" {
            type = MoldType.disaffected
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.disaffectedLabel.text = String(count)
        }
        if action == "olivePlus" {
            type = MoldType.olive
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.oliveLabel.text = String(count + 1)
                }
            }
        }
        if action == "oliveMinus" {
            type = MoldType.olive
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.oliveLabel.text = String(count)
        }
        if action == "coconutPlus" {
            type = MoldType.coconut
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.coconutLabel.text = String(count + 1)
                }
            }
        }
        if action == "coconutMinus" {
            type = MoldType.coconut
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.coconutLabel.text = String(count)
        }
        if action == "sickPlus" {
            type = MoldType.sick
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.sickLabel.text = String(count + 1)
                }
            }
        }
        if action == "sickMinus" {
            type = MoldType.sick
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.sickLabel.text = String(count)
        }
        if action == "deadPlus" {
            type = MoldType.dead
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.deadLabel.text = String(count + 1)
                }
            }
        }
        if action == "deadMinus" {
            type = MoldType.dead
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.deadLabel.text = String(count)
        }
        if action == "zombiePlus" {
            type = MoldType.zombie
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.zombieLabel.text = String(count + 1)
                }
            }
        }
        if action == "zombieMinus" {
            type = MoldType.zombie
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.zombieLabel.text = String(count)
        }
        if action == "cloudPlus" {
            type = MoldType.cloud
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.cloudLabel.text = String(count + 1)
                }
            }
        }
        if action == "cloudMinus" {
            type = MoldType.cloud
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.cloudLabel.text = String(count)
        }
        if action == "rockPlus" {
            type = MoldType.rock
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.rockLabel.text = String(count + 1)
                }
            }
        }
        if action == "rockMinus" {
            type = MoldType.rock
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.rockLabel.text = String(count)
        }
        if action == "waterPlus" {
            type = MoldType.water
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.waterLabel.text = String(count + 1)
                }
            }
        }
        if action == "waterMinus" {
            type = MoldType.water
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.waterLabel.text = String(count)
        }
        if action == "crystalPlus" {
            type = MoldType.crystal
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.crystalLabel.text = String(count + 1)
                }
            }
        }
        if action == "crystalMinus" {
            type = MoldType.crystal
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.crystalLabel.text = String(count)
        }
        if action == "nuclearPlus" {
            type = MoldType.nuclear
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.nuclearLabel.text = String(count + 1)
                }
            }
        }
        if action == "nuclearMinus" {
            type = MoldType.nuclear
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.nuclearLabel.text = String(count)
        }
        if action == "astronautPlus" {
            type = MoldType.astronaut
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.astronautLabel.text = String(count + 1)
                }
            }
        }
        if action == "astronautMinus" {
            type = MoldType.astronaut
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.astronautLabel.text = String(count)
        }
        if action == "sandPlus" {
            type = MoldType.sand
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.sandLabel.text = String(count + 1)
                }
            }
        }
        if action == "sandMinus" {
            type = MoldType.sand
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.sandLabel.text = String(count)
        }
        if action == "glassPlus" {
            type = MoldType.glass
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.glassLabel.text = String(count + 1)
                }
            }
        }
        if action == "glassMinus" {
            type = MoldType.glass
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.glassLabel.text = String(count)
        }
        if action == "coffeePlus" {
            type = MoldType.coffee
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.coffeeLabel.text = String(count + 1)
                }
            }
        }
        if action == "coffeeMinus" {
            type = MoldType.coffee
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.coffeeLabel.text = String(count)
        }
        if action == "slinkyPlus" {
            type = MoldType.slinky
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.slinkyLabel.text = String(count + 1)
                }
            }
        }
        if action == "slinkyMinus" {
            type = MoldType.slinky
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.slinkyLabel.text = String(count)
        }
        if action == "magmaPlus" {
            type = MoldType.magma
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.magmaLabel.text = String(count + 1)
                }
            }
        }
        if action == "magmaMinus" {
            type = MoldType.magma
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.magmaLabel.text = String(count)
        }
        if action == "samuraiPlus" {
            type = MoldType.samurai
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.samuraiLabel.text = String(count + 1)
                }
            }
        }
        if action == "samuraiMinus" {
            type = MoldType.samurai
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.samuraiLabel.text = String(count)
        }
        if action == "orangePlus" {
            type = MoldType.orange
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.orangeLabel.text = String(count + 1)
                }
            }
        }
        if action == "orangeMinus" {
            type = MoldType.orange
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.orangeLabel.text = String(count)
        }
        if action == "strawberryPlus" {
            type = MoldType.strawberry
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.strawberryLabel.text = String(count + 1)
                }
            }
        }
        if action == "strawberryMinus" {
            type = MoldType.strawberry
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.strawberryLabel.text = String(count)
        }
        if action == "tshirtPlus" {
            type = MoldType.tshirt
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.tshirtLabel.text = String(count + 1)
                }
            }
        }
        if action == "tshirtMinus" {
            type = MoldType.tshirt
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.tshirtLabel.text = String(count)
        }
        if action == "cryptidPlus" {
            type = MoldType.cryptid
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.cryptidLabel.text = String(count + 1)
                }
            }
        }
        if action == "cryptidMinus" {
            type = MoldType.cryptid
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.cryptidLabel.text = String(count)
        }
        if action == "angelPlus" {
            type = MoldType.angel
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.angelLabel.text = String(count + 1)
                }
            }
        }
        if action == "angelMinus" {
            type = MoldType.angel
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.angelLabel.text = String(count)
        }
        if action == "invisiblePlus" {
            type = MoldType.invisible
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.invisibleLabel.text = String(count + 1)
                }
            }
        }
        if action == "invisibleMinus" {
            type = MoldType.invisible
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.invisibleLabel.text = String(count)
        }
        if action == "starPlus" {
            type = MoldType.star
            if inventory.displayMolds.count < 25 {
                var mCount = 0
                for mMold in inventory.molds {
                    if mMold.moldType == type {
                        mCount += 1
                    }
                }
                var count = 0
                for pMold in inventory.displayMolds {
                    if pMold.moldType == type {
                        count += 1
                    }
                }
                if count < mCount {
                    inventory.displayMolds.append(Mold(moldType: type))
                    inventoryScene.totalNum += 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    
                    inventoryScene.starLabel.text = String(count + 1)
                }
            }
        }
        if action == "starMinus" {
            type = MoldType.star
            var index = 0
            loop: for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    inventory.displayMolds.remove(at: index)
                    inventoryScene.totalNum -= 1
                    inventoryScene.totalLabel.text = String(inventoryScene.totalNum)
                    break loop
                }
                index += 1
            }
            var count = 0
            for pMold in inventory.displayMolds {
                if pMold.moldType == type {
                    count += 1
                }
            }
            inventoryScene.starLabel.text = String(count)
        }

        if (action == "exit") {
            scene.menuPopUp.size = skView.bounds.size
            
            let disappear = SKAction.scale(to: 0, duration: 0.2)
            //this is the godo case
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            exitInventory()
            scene.menuPopUp.run(action)
        }
    }
    
    func exitInventory() {
        inventoryScene.cometLayer.removeAllChildren()
        inventoryScene.cometTimer.invalidate()
        scene.molds = inventory.displayMolds
        scene.updateMolds()
        scene.isActive = true
        skView.presentScene(scene)
        scene.playSound(select: "exit")
    }
    
    // SHOP HANDLER
    func shopHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .resizeFill
            menu.touchHandler = menuHandler
            
            moldShop.cometLayer.removeAllChildren()
            moldShop.cometTimer.invalidate()
            skView.presentScene(menu)
            menu.playSound(select: "exit")
        }
        else {
            var mold: Mold!
            if (action == "slime") {
                mold = Mold(moldType: MoldType.slime)
            }
            if (action == "cave") {
                mold = Mold(moldType: MoldType.cave)
            }
            if (action == "sad") {
                mold = Mold(moldType: MoldType.sad)
            }
            if (action == "angry") {
                mold = Mold(moldType: MoldType.angry)
            }
            if (action == "alien") {
                mold = Mold(moldType: MoldType.alien)
            }
            if (action == "freckled") {
                mold = Mold(moldType: MoldType.freckled)
            }
            if (action == "hypno") {
                mold = Mold(moldType: MoldType.hypno)
            }
            if (action == "pimply") {
                mold = Mold(moldType: MoldType.pimply)
            }
            if (action == "rainbow") {
                mold = Mold(moldType: MoldType.rainbow)
            }
            if (action == "aluminum") {
                mold = Mold(moldType: MoldType.aluminum)
            }
            if (action == "circuit") {
                mold = Mold(moldType: MoldType.circuit)
            }
            if (action == "hologram") {
                mold = Mold(moldType: MoldType.hologram)
            }
            if (action == "storm") {
                mold = Mold(moldType: MoldType.storm)
            }
            if (action == "bacteria") {
                mold = Mold(moldType: MoldType.bacteria)
            }
            if (action == "virus") {
                mold = Mold(moldType: MoldType.virus)
            }
            if (action == "flower") {
                mold = Mold(moldType: MoldType.flower)
            }
            if (action == "bee") {
                mold = Mold(moldType: MoldType.bee)
            }
            if (action == "x") {
                mold = Mold(moldType: MoldType.x)
            }
            if (action == "disaffected") {
                mold = Mold(moldType: MoldType.disaffected)
            }
            if (action == "olive") {
                mold = Mold(moldType: MoldType.olive)
            }
            if (action == "coconut") {
                mold = Mold(moldType: MoldType.coconut)
            }
            if (action == "sick") {
                mold = Mold(moldType: MoldType.sick)
            }
            if (action == "dead") {
                mold = Mold(moldType: MoldType.dead)
            }
            if (action == "zombie") {
                mold = Mold(moldType: MoldType.zombie)
            }
            if (action == "rock") {
                mold = Mold(moldType: MoldType.rock)
            }
            if (action == "cloud") {
                mold = Mold(moldType: MoldType.cloud)
            }
            if (action == "water") {
                mold = Mold(moldType: MoldType.water)
            }
            if (action == "crystal") {
                mold = Mold(moldType: MoldType.crystal)
            }
            if (action == "nuclear") {
                mold = Mold(moldType: MoldType.nuclear)
            }
            if (action == "astronaut") {
                mold = Mold(moldType: MoldType.astronaut)
            }
            if (action == "sand") {
                mold = Mold(moldType: MoldType.sand)
            }
            if (action == "glass") {
                mold = Mold(moldType: MoldType.glass)
            }
            if (action == "coffee") {
                mold = Mold(moldType: MoldType.coffee)
            }
            if (action == "slinky") {
                mold = Mold(moldType: MoldType.slinky)
            }
            if (action == "magma") {
                mold = Mold(moldType: MoldType.magma)
            }
            if (action == "samurai") {
                mold = Mold(moldType: MoldType.samurai)
            }
            if (action == "orange") {
                mold = Mold(moldType: MoldType.orange)
            }
            if (action == "strawberry") {
                mold = Mold(moldType: MoldType.strawberry)
            }
            if (action == "tshirt") {
                mold = Mold(moldType: MoldType.tshirt)
            }
            if (action == "cryptid") {
                mold = Mold(moldType: MoldType.cryptid)
            }
            if (action == "angel") {
                mold = Mold(moldType: MoldType.angel)
            }
            if (action == "invisible") {
                mold = Mold(moldType: MoldType.invisible)
            }
            if (inventory.cash > mold.price) {
                inventory.cash -= mold.price
                inventory.molds.append(mold)
                if inventory.displayMolds.count < 25 {
                    inventory.displayMolds.append(mold)
                }
                inventory.scorePerSecond += mold.PPS
                moldShop.playSound(select: "levelup")
                moldShop.animateName(name: mold.name)
                let chance = Int(arc4random_uniform(7))
                if  chance < inventory.incubator {
                    inventory.molds.append(mold)
                    inventory.scorePerSecond += mold.PPS
                    moldShop.animateName(name: "+1")
                    
                }
                if inventory.molds.count == 5 {
                    if inventory.achievementsDicc["own 5"] == false {
                        inventory.achievementsDicc["own 5"] = true
                        inventory.achieveDiamonds += 5
                    }
                }
                else if inventory.molds.count == 25 {
                    if inventory.achievementsDicc["own 25"] == false {
                        inventory.achievementsDicc["own 25"] = true
                        inventory.achieveDiamonds += 5
                    }
                }
                else if inventory.molds.count == 100 {
                    if inventory.achievementsDicc["own 100"] == false {
                        inventory.achievementsDicc["own 100"] = true
                        inventory.achieveDiamonds += 5
                    }
                }
                else if inventory.molds.count == 250 {
                    if inventory.achievementsDicc["own 250"] == false {
                        inventory.achievementsDicc["own 250"] = true
                        inventory.achieveDiamonds += 10
                    }
                }
                
                let index = inventory.currentQuest.index(inventory.currentQuest.startIndex, offsetBy: 3)
                if inventory.currentQuest.substring(to: index) == "p " {
                    var name = inventory.currentQuest.substring(from: index)
                    if mold.name == name {
                        inventory.questAmount += 1
                    }
                    if inventory.questAmount == inventory.questGoal {
                        questAchieved()
                    }
                }
 
            }
            updateLabels()

        }
    }

    // BREED HANDLER
    //honestly this is a freaking mess. so much repeating code this can definitely be shrunk
    func breedHandler(action: String) {
        activateSleepTimer()
        if breedScene.successLayer.children.count > 0 {
            breedScene.successLayer.removeAllChildren()
        }
        if (action == "back") {
            breedScene.cometLayer.removeAllChildren()
            breedScene.cometTimer.invalidate()
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .resizeFill
            menu.touchHandler = menuHandler
            
            /*
            //looks liek the breeding experiemnt failed, oh well, genetic engineering is a dangerous task
                if let orgy = breedScene.selectedMolds {
                    for mold in orgy {
                        var index = 0
                        for target in inventory.molds {
                            if mold.moldType == target.moldType {
                                inventory.molds.remove(at: index)
                                inventory.scorePerSecond -= target.PPS
                                break
                            }
                            index += 1
                        }
                    }
                }
                breedScene.ownedMolds = inventory.molds
            */
            skView.presentScene(menu)
            menu.playSound(select: "exit")
        }
        if action == "clear" {
            //clear selection, tell the user they screwed up
            if breedScene.selectedMolds.count > 0 {
                 breedScene.playSound(select: "loose")
                breedScene.animateName(point: breedScene.center, name: "BREED FAILED", new: 2)
            }
            //kill the selected molds
            if let orgy = breedScene.selectedMolds {
                for mold in orgy {
                    var index = 0
                    for target in inventory.molds {
                        if mold.moldType == target.moldType {
                            inventory.molds.remove(at: index)
                            inventory.scorePerSecond -= target.PPS
                            break
                        }
                        index += 1
                    }
                    index = 0
                    for target in inventory.displayMolds {
                        if mold.moldType == target.moldType {
                            inventory.displayMolds.remove(at: index)
                            inventory.scorePerSecond -= target.PPS
                            break
                        }
                        index += 1
                    }
                }
            }
            //reset all the arrays
            breedScene.ownedMolds = inventory.molds
            //populate the possible combos array
            breedScene.possibleCombos = []
            if breedScene.ownedMolds.count > 0 {
                for combo in combos.allCombos {
                    var same = 0
                    //now check if the parents in the combo are the same as the molds in the orgy
                    //check same length
                    //now check if the orgy and the combo members match
                    for mold in breedScene.ownedMolds {
                        for parent in combo.parents {
                            if mold.name == parent.name {
                                same += 1
                            }
                        }
                    }
                    if same == combo.parents.count {
                        var letsAdd = true
                        for mold in inventory.unlockedMolds {
                            if mold.moldType == combo.child.moldType {
                                letsAdd = false
                            }
                        }
                        if letsAdd == true {
                            breedScene.possibleCombos.append(combo)
                        }
                        
                    }
                }
            }
            //reset the diamonds
            if breedScene.possibleCombos.count > 0 {
                breedScene.currentDiamondCombo = breedScene.possibleCombos[0]
                breedScene.diamondLabel.text = String(breedScene.currentDiamondCombo.parents.count)
            }
            else if breedScene.possibleCombos.count == 0 {
                breedScene.currentDiamondCombo = nil
                breedScene.diamondLabel.text = "0"
            }
            breedScene.selectedMolds = []
            breedScene.reloadScroll()
        }
        if action == "diamonds" {
            //make sure the user has diamonds
            if inventory.diamonds >= breedScene.numDiamonds {
                if breedScene.currentDiamondCombo != nil {
                    let newCombo = breedScene.currentDiamondCombo
                    //ok, this breed hasnt been unlocked yet, time to unlock it!
                    inventory.unlockedMolds.append((newCombo?.child)!)
                    breedScene.unlockedMolds = inventory.unlockedMolds
                    //breedScene.animateName(point: breedScene.center, name: (newCombo?.child.name)!, new: 1)
                    breedScene.playSound(select: "awe")
                    breedScene.showNewBreed(breed: (newCombo?.child.moldType)!)
                    incrementDiamonds(newDiamonds: (-1 * breedScene.numDiamonds))
                    updateBreedAchievements()
                    //update possiblecombos
                    //populate the possible combos array
                    breedScene.possibleCombos = []
                    if breedScene.ownedMolds.count > 0 {
                        for combo in combos.allCombos {
                            var same = 0
                            //now check if the parents in the combo are the same as the molds in the orgy
                            //check same length
                            //now check if the orgy and the combo members match
                            for mold in breedScene.ownedMolds {
                                for parent in combo.parents {
                                    if mold.name == parent.name {
                                        same += 1
                                    }
                                }
                            }
                            if same == combo.parents.count {
                                var letsAdd = true
                                for mold in inventory.unlockedMolds {
                                    if mold.moldType == combo.child.moldType {
                                        letsAdd = false
                                    }
                                }
                                if combo.child.moldType == newCombo?.child.moldType {
                                    letsAdd = false
                                }
                                if letsAdd == true {
                                    breedScene.possibleCombos.append(combo)
                                }
                                
                            }
                        }
                    }
                    if breedScene.possibleCombos.count > 0 {
                        breedScene.currentDiamondCombo = breedScene.possibleCombos[0]
                        breedScene.numDiamonds = breedScene.currentDiamondCombo.parents.count * 2
                        breedScene.diamondLabel.text = String(breedScene.numDiamonds)
                    }
                    else if breedScene.possibleCombos.count == 0 {
                        breedScene.currentDiamondCombo = nil
                        breedScene.diamondLabel.text = "0"
                    }
                    breedScene.diamondLabel.fontColor = UIColor.black
                }

            }
            else {
                breedScene.animateName(point: breedScene.center, name: "OUT OF DIAMONDS", new: 2)
            }

        }
        if (action == "breed") {
            //placeholder for whether molds die or not
            var killMolds = true
            //check that selected molds exists
            if let orgy = breedScene.selectedMolds {
                //run once for each combo in dataset of combos
                for combo in combos.allCombos {
                    var same = 0
                    //now check if the parents in the combo are the same as the molds in the orgy
                    //check same length
                    if combo.parents.count == orgy.count {
                        //now check if the orgy and the combo members match
                        same = 0
                        for mold in orgy {
                            for parent in combo.parents {
                                if mold.name == parent.name {
                                    same += 1
                                }
                            }
                        }
                        if same == orgy.count {
                            //first, check if we've already unlocked this breed
                            var childUnlocked = false
                            for mold in inventory.unlockedMolds {
                                if mold.moldType == combo.child.moldType {
                                    //oops, guess we got this one already!
                                    print("breed already unlocked")
                                    childUnlocked = true
                                    killMolds = false
                                    break
                                }
                            }
                            //check done
                            if childUnlocked == false {
                                //ok, this breed hasnt been unlocked yet, time to unlock it!
                                killMolds = false
                                
                                inventory.unlockedMolds.append(combo.child)
                                print(combo.child.name)
                                breedScene.unlockedMolds = inventory.unlockedMolds
                                //breedScene.animateName(point: breedScene.center, name: combo.child.name, new: 1)
                                breedScene.playSound(select: "awe")
                                breedScene.showNewBreed(breed: combo.child.moldType)
                                //achievements
                                updateBreedAchievements()
                                //update possiblecombos
                                
                                var index = 0
                                for posCombo in breedScene.possibleCombos {
                                    if posCombo.child.moldType == combo.child.moldType {
                                        breedScene.possibleCombos.remove(at: index)
                                        break
                                    }
                                    index += 1
                                }
//                                this is the code toe update tflnewA
                                if breedScene.possibleCombos.count > 0 {
                                    breedScene.currentDiamondCombo = breedScene.possibleCombos[0]
                                    breedScene.numDiamonds = breedScene.currentDiamondCombo.parents.count * 2
                                    breedScene.diamondLabel.text = String(breedScene.numDiamonds)
                                }
                                else if breedScene.possibleCombos.count == 0 {
                                    breedScene.currentDiamondCombo = nil
                                    breedScene.diamondLabel.text = "0"
                                }
                                breedScene.diamondLabel.fontColor = UIColor.black
                            }
                        }
                        
                    }
                }
            }
            //looks liek the breeding experiemnt failed, oh well, genetic engineering is a dangerous task
            if killMolds {
                if let orgy = breedScene.selectedMolds {
                    for mold in orgy {
                        var index = 0
                        //kill the molds
                        for target in inventory.molds {
                            if mold.moldType == target.moldType {
                                inventory.molds.remove(at: index)
                                inventory.scorePerSecond -= target.PPS
                                break
                            }
                            index += 1
                        }
                        index = 0
                        for target in inventory.displayMolds {
                            if mold.moldType == target.moldType {
                                inventory.displayMolds.remove(at: index)
                                inventory.scorePerSecond -= target.PPS
                                break
                            }
                            index += 1
                        }
                    }
                }
                breedScene.playSound(select: "buzzer")
                breedScene.animateName(point: breedScene.center, name: "BREED FAILED", new: 2)
                breedScene.ownedMolds = inventory.molds
                //populate the possible combos array
                breedScene.possibleCombos = []
                if breedScene.ownedMolds.count > 0 {
                    for combo in combos.allCombos {
                        var same = 0
                        //now check if the parents in the combo are the same as the molds in the orgy
                        //check same length
                        //now check if the orgy and the combo members match
                        for mold in breedScene.ownedMolds {
                            for parent in combo.parents {
                                if mold.name == parent.name {
                                    same += 1
                                }
                            }
                        }
                        if same == combo.parents.count {
                            var letsAdd = true
                            for mold in inventory.unlockedMolds {
                                if mold.moldType == combo.child.moldType {
                                    letsAdd = false
                                }
                            }
                            if letsAdd == true {
                                breedScene.possibleCombos.append(combo)
                            }
                            
                        }
                    }
                }
                if breedScene.possibleCombos.count > 0 {
                    breedScene.currentDiamondCombo = breedScene.possibleCombos[0]
                    breedScene.diamondLabel.text = String(breedScene.currentDiamondCombo.parents.count)
                }
                else if breedScene.possibleCombos.count == 0 {
                    breedScene.currentDiamondCombo = nil
                    breedScene.diamondLabel.text = "0"
                }
                breedScene.reloadScroll()
            }
            //clear the selection buffer
            breedScene.selectedMolds = []
        }
        
    }
    
    //ITEM SHOP HANDLER
    func itemHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            itemShop.cometLayer.removeAllChildren()
            itemShop.cometTimer.invalidate()
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .resizeFill
            menu.touchHandler = menuHandler
            
            skView.presentScene(menu)
            menu.playSound(select: "exit")
        }
        if action == "repel" {
            if inventory.cash > 10000 {
                incrementCash(pointsToAdd: -10000)
                scene.wormRepel = true
                scene.wormRepelCount += 30
                itemShop.playSound(select: "levelup")
                shiftTimerLabels()
            }
            
        }
        if (action == "premium") {
            itemShop.cometTimer.invalidate()
            itemShop.cometLayer.removeAllChildren()
            premiumShop = PremiumShop(size: skView.bounds.size)
            premiumShop.name = "premiumShop"
            premiumShop.scaleMode = .resizeFill
            premiumShop.touchHandler = premiumHandler
            if inventory.deathRay {
                premiumShop.deathRayBought = true
            }
            premiumShop.incubatorBought = inventory.incubator
            premiumShop.autoTapBought = inventory.autoTapLevel
            skView.presentScene(premiumShop)
            premiumShop.playSound(select: "select")
        }
        if action == "xTap" {
            if inventory.diamonds >= 10 {
                scene.xTapAmount = 12
                scene.xTapCount += 20
                incrementDiamonds(newDiamonds: -10)
                itemShop.playSound(select: "cash register")
                shiftTimerLabels()
            }
            
        }
        if action == "spritz" {
            if inventory.diamonds >= 20 {
                scene.spritzAmount = 18
                scene.spritzCount += 40
                incrementDiamonds(newDiamonds: -20)
                itemShop.playSound(select: "cash register")
                shiftTimerLabels()
                scene.animateSpritz()
            }
        }
        if action == "laser" {
            var cost = 50000
            switch inventory.laser {
            case 0:
                cost = 50000
                break
            case 1:
                cost = 180000
                break
            case 2:
                cost = 3000000
                break
            default:
                cost = 3000000
                break
            }
            
            if inventory.cash >= cost {
                inventory.laser += 1
                //log laser maxing achievement if level 3
                if inventory.laser == 3 {
                    if inventory.achievementsDicc["lev 3 laser"] == false {
                        inventory.achievementsDicc["lev 3 laser"] = true
                        inventory.achieveDiamonds += 5
                    }
                }
                scene.laserPower = inventory.laser
                itemShop.laserBought = inventory.laser
                var Texture = SKTexture(image: UIImage(named: "upgrade laser 1")!)
                print(itemShop.laserBought)
                if itemShop.laserBought <= 2 {
                    Texture = SKTexture(image: UIImage(named: "upgrade laser \(itemShop.laserBought + 1)")!)
                    itemShop.laserLabel.text = "Kill worms \((itemShop.laserBought + 1)*16)%"
                }
                else {
                    Texture = SKTexture(image: UIImage(named: "upgrade laser bought")!)
                    itemShop.laserLabel.text = "Kill worms \((itemShop.laserBought)*16)%"
                }
                itemShop.laserButton = SKSpriteNode(texture:Texture)
                itemShop.laserButton.position = CGPoint(x:itemShop.frame.midX-90, y:itemShop.frame.midY-100);
                itemShop.addChild(itemShop.laserButton)
                itemShop.playSound(select: "levelup")
                incrementCash(pointsToAdd: (cost * -1))
                switch inventory.laser {
                case 0:
                    cost = 50000
                    break
                case 1:
                    cost = 180000
                    break
                case 2:
                    cost = 3000000
                    break
                default:
                    cost = 3000000
                    break
                }
                itemShop.laserCostLabel.text = "Cost: \(cost)"
            }
            
            
            
        }
        if action == "smallwindfall" {
            if inventory.diamonds > 15 {
                itemShop.playSound(select: "cash register")
                incrementCash(pointsToAdd: inventory.scorePerSecond*BInt(50))
                incrementDiamonds(newDiamonds: -15)
            }
        }
    }
    
    //PREMIUM SHOP HANDLER
    func premiumHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            premiumShop.cometLayer.removeAllChildren()
            premiumShop.cometTimer.invalidate()
            itemShop = ItemShop(size: skView.bounds.size)
            itemShop.scaleMode = .resizeFill
            itemShop.touchHandler = itemHandler
            itemShop.laserBought = inventory.laser
            skView.presentScene(itemShop)
            //menu.cometLayer.removeAllChildren()
            itemShop.playSound(select: "exit")
        }
        if action == "windfall" {
            if inventory.diamonds >= 30 {
                incrementCash(pointsToAdd: inventory.scorePerSecond*BInt(200))
                incrementDiamonds(newDiamonds: -30)
                premiumShop.playSound(select: "cash register")
            }
            
        }
        if action == "death ray" {

            purchaseMyProduct(product: iapProducts[5])
        }
        if action == "incubator" {
            if inventory.diamonds >= 15 {
                premiumShop.playSound(select: "cash register")
                inventory.incubator += 1
                //log achievement is level 6 now
                if inventory.incubator == 6 {
                    if inventory.achievementsDicc["lev 6 inc"] == false {
                        inventory.achievementsDicc["lev 6 inc"] = true
                        inventory.achieveDiamonds += 5
                    }
                }
                premiumShop.incubatorBought = inventory.incubator
                var Texture = SKTexture(image: UIImage(named: "heated incubator")!)
                print(premiumShop.incubatorBought)
                if premiumShop.incubatorBought <= 5 {
                    Texture = SKTexture(image: UIImage(named: "heated incubator \(premiumShop.incubatorBought + 1)")!)
                    premiumShop.incLabel.text = "\((premiumShop.incubatorBought + 1)*10)% chance for a free"
                }
                else {
                    Texture = SKTexture(image: UIImage(named: "incubator bought")!)
                    premiumShop.incLabel.text = "\(premiumShop.incubatorBought*10)% chance for a free"
                }
                premiumShop.incubatorButton.removeFromParent()
                premiumShop.incubatorButton = SKSpriteNode(texture:Texture)
                premiumShop.incubatorButton.position = CGPoint(x:premiumShop.frame.midX-85, y:premiumShop.frame.midY-103)
                premiumShop.addChild(premiumShop.incubatorButton)
                incrementDiamonds(newDiamonds: -15)
            }
            
            
        }
        if action == "auto-tap" {
            if inventory.autoTapLevel < 5 {
                purchaseMyProduct(product: iapProducts[4])
            }
        }
        if action == "star" {

            purchaseMyProduct(product: iapProducts[6])
            
        }
    }
    
    //Achievemnts HANDLER
    func achieveHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            achievements.cometLayer.removeAllChildren()
            achievements.cometTimer.invalidate()
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .resizeFill
            menu.touchHandler = menuHandler
            
            skView.presentScene(menu)
            menu.playSound(select: "exit")
        }
        if action == "claim" {
            if achievements.rewardAmount > 0 {
                achievements.playSound(select: "achieve")
                incrementDiamonds(newDiamonds: achievements.rewardAmount)
                
                let Texture = SKTexture(image: UIImage(named: "claim reward grey")!)
                achievements.claimButton = SKSpriteNode(texture:Texture)
                achievements.claimButton.position = CGPoint(x:achievements.frame.midX, y:achievements.frame.midY-230);
                achievements.addChild(achievements.claimButton)
                
                achievements.rewardAmount = 0
                inventory.achieveDiamonds = 0
            }
        }
    }

    //Credits HANDLER
    func creditsHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            creditsScene.cometLayer.removeAllChildren()
            creditsScene.cometTimer.invalidate()
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .resizeFill
            menu.touchHandler = menuHandler
            
            skView.presentScene(menu)
            menu.playSound(select: "exit")
        }
    }
    
    //Quest HANDLER
    func questHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            questScene.cometLayer.removeAllChildren()
            questScene.cometTimer.invalidate()
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .resizeFill
            menu.touchHandler = menuHandler
            
            skView.presentScene(menu)
            menu.playSound(select: "exit")
        }
    }

    
    //GAME SCENE HANDLER
    func handleTap(action: String) {
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        //this is the godo case
        let animation = SKAction.sequence([disappear, SKAction.removeFromParent()])
        if action == "tap ended" {
            autoTapTimer?.invalidate()
        }
        if action == "awake" {
            activateSleepTimer()
            scene.playSound(select: "select")
            print("wake up")
            scene.sleepLayer.removeAllChildren()
            scene.reactivateTimer()
            scene.isActive = true
            cashTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.addCash), userInfo: nil, repeats: true)
        }

        if action == "touchOFF" {
            self.view.isUserInteractionEnabled = false
            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(enableTouch), userInfo: nil, repeats: true)
        }
        if action == "kiss baby" {
            let mold = Mold(moldType: MoldType.random())
            inventory.molds.append(mold)
            if inventory.displayMolds.count < 25 {
                inventory.displayMolds.append(mold)
                scene.updateMolds()
            }
            inventory.scorePerSecond += mold.PPS
            // Add a label for the score that slowly floats up.
            let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
            scoreLabel.fontSize = 16
            scoreLabel.text = String(mold.description)
            scoreLabel.position = scene.center
            scoreLabel.zPosition = 300
            
            scene.gameLayer.addChild(scoreLabel)
            
            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
            moveAction.timingMode = .easeOut
            scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
        if action == "knockout" {
            if inventory.molds.count > 0 {
                let indexToEat = randomInRange(lo: 0, hi: inventory.molds.count - 1)
                if inventory.molds[indexToEat].moldType != MoldType.star {
                    var eatcount = 0
                    displayLoop: for molds in inventory.displayMolds {
                        if molds.moldType == inventory.molds[indexToEat].moldType {
                            inventory.displayMolds.remove(at: eatcount)
                            break displayLoop
                        }
                        eatcount += 1
                    }
                    inventory.scorePerSecond -= inventory.molds[indexToEat].PPS
                    inventory.molds.remove(at: indexToEat)
                    scene.molds = inventory.displayMolds
                    scene.updateMolds()
                    // Add a label for the score that slowly floats up.
                    let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
                    scoreLabel.fontSize = 16
                    scoreLabel.fontColor = UIColor.red
                    scoreLabel.text = String(inventory.molds[indexToEat].description)
                    scoreLabel.position = scene.center
                    scoreLabel.zPosition = 300
                    
                    scene.gameLayer.addChild(scoreLabel)
                    
                    let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
                    moveAction.timingMode = .easeOut
                    scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                }
            }
            
        }
        if scene.diamondShop == false && action == "tap" {
            tapHelper()
            if inventory.autoTap {
                if inventory.autoTapLevel == 1 {
                    autoTapTimer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(tapHelper), userInfo: nil, repeats: true)
                }
                if inventory.autoTapLevel == 2 {
                    autoTapTimer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(tapHelper), userInfo: nil, repeats: true)
                }
                if inventory.autoTapLevel == 3 {
                    autoTapTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(tapHelper), userInfo: nil, repeats: true)
                }
                if inventory.autoTapLevel == 4 {
                    autoTapTimer = Timer.scheduledTimer(timeInterval: 0.013, target: self, selector: #selector(tapHelper), userInfo: nil, repeats: true)
                }
                if inventory.autoTapLevel == 5 {
                    autoTapTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tapHelper), userInfo: nil, repeats: true)
                }
            }
        }
        if scene.cardsActive {
            if scene.cardRevealed == false {
                
                if action == "card1" {
                    activateSleepTimer()
                    scene.flipTile(node: scene.card1 as! SKSpriteNode, reveal: false)
                    let moveVert = SKAction.move(to: CGPoint(x: scene.card1.position.x,y: scene.card1.position.y + 40), duration:0.5)
                    scene.card1.run(moveVert)
                    scene.card2.run(animation)
                    scene.card3.run(animation)
                    scene.addOkButtons()
                }
                if action == "card2" {
                    activateSleepTimer()
                    scene.flipTile(node: scene.card2 as! SKSpriteNode, reveal: false)
                    scene.card1.run(animation)
                    let moveVert = SKAction.move(to: CGPoint(x: scene.card2.position.x,y: scene.card2.position.y + 40), duration:0.5)
                    scene.card2.run(moveVert)
                    scene.card3.run(animation)
                    scene.addOkButtons()
                }
                if action == "card3" {
                    activateSleepTimer()
                    scene.flipTile(node: scene.card3 as! SKSpriteNode, reveal: false)
                    scene.card1.run(animation)
                    scene.card2.run(animation)
                    let moveVert = SKAction.move(to: CGPoint(x: scene.card3.position.x,y: scene.card3.position.y + 40), duration:0.5)
                    scene.card3.run(moveVert)
                    scene.addOkButtons()
                }
                if action == "revealCards" {
                    activateSleepTimer()
                    scene.flipTile(node: scene.card1 as! SKSpriteNode, reveal: true)
                    scene.flipTile(node: scene.card2 as! SKSpriteNode, reveal: true)
                    scene.flipTile(node: scene.card3 as! SKSpriteNode, reveal: true)
                    scene.cardLayer.removeChildren(in: [scene.revealCards])
                    scene.revealCards = nil
                    scene.cardRevealed = true
                    incrementDiamonds(newDiamonds: -3)
                }
            }
            else {
                if action == "card1" {
                    activateSleepTimer()
                    scene.selectedNum = scene.selectedArray[0]
                    let moveVert = SKAction.move(to: CGPoint(x: scene.card1.position.x,y: scene.card1.position.y + 40), duration:0.5)
                    scene.card1.run(moveVert)
                    scene.card2.run(animation)
                    scene.card3.run(animation)
                    scene.addOkButtons()
                }
                if action == "card2" {
                    activateSleepTimer()
                    scene.selectedNum = scene.selectedArray[1]
                    scene.card1.run(animation)
                    let moveVert = SKAction.move(to: CGPoint(x: scene.card2.position.x,y: scene.card2.position.y + 40), duration:0.5)
                    scene.card2.run(moveVert)
                    scene.card3.run(animation)
                    scene.addOkButtons()
                }
                if action == "card3" {
                    activateSleepTimer()
                    scene.selectedNum = scene.selectedArray[2]
                    scene.card1.run(animation)
                    scene.card2.run(animation)
                    let moveVert = SKAction.move(to: CGPoint(x: scene.card3.position.x,y: scene.card3.position.y + 40), duration:0.5)
                    scene.card3.run(moveVert)
                    scene.addOkButtons()
                }
            }
            
            
        }
        if scene.cardSelected {
            if action == "okButton" {
                activateSleepTimer()
                switch scene.selectedNum {
                case 1:
                    scene.spritzAmount = 18
                    scene.spritzCount += 120
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 2:
                    scene.spritzAmount = 12
                    scene.spritzCount += 180
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 3:
                    scene.spritzAmount = 12
                    scene.spritzCount += 60
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 4:
                    scene.xTapAmount = 30
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 5:
                    scene.xTapAmount = 50
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 6:
                    scene.xTapAmount = 80
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 7:
                    scene.xTapAmount = 120
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 8:
                    scene.spritzAmount = 0
                    scene.spritzCount += 60
                    scene.playSound(select: "bad card")
                    shiftTimerLabels()
                    break
                case 9:
                    scene.spritzAmount = 0
                    scene.spritzCount += 90
                    scene.playSound(select: "bad card")
                    shiftTimerLabels()
                    break
                case 10:
                    scene.spritzAmount = 0
                    scene.spritzCount += 120
                    scene.playSound(select: "bad card")
                    shiftTimerLabels()
                    break
                case 11:
                    let numOMolds = inventory.molds.count - 1
                    if inventory.molds.count > 1 {
                        inventory.molds.remove(at: Int(arc4random_uniform(UInt32(numOMolds))))
                    }
                    scene.molds = inventory.molds
                    scene.updateMolds()
                    scene.playSound(select: "bad card")
                    break
                case 12:
                    let numOMolds = inventory.molds.count - 1
                    if inventory.molds.count > 3 {
                        var goTime = 0
                        while (goTime < 3) {
                            inventory.molds.remove(at: Int(arc4random_uniform(UInt32(numOMolds))))
                            goTime += 1
                        }
                    }
                    else {
                        inventory.molds = []
                    }
                    scene.molds = inventory.molds
                    scene.updateMolds()
                    scene.playSound(select: "bad card")
                    break
                default:
                    break
                }
                scene.card1 = nil
                scene.card2 = nil
                scene.card3 = nil
                scene.okButton = nil
                scene.changeEffectButton = nil
                scene.cardSelected = false
                scene.cardsActive = false
                scene.cardRevealed = false
                scene.selectedArray = [Int]()
                for child in scene.cardLayer.children {
                    child.run(animation)
                }
                scene.reactivateTimer()
            }
            if action == "changeEffect" && inventory.diamonds >= 2 {
                activateSleepTimer()
                incrementDiamonds(newDiamonds: -2)
                switch scene.selectedNum {
                case 1:
                    scene.spritzAmount = 18
                    scene.spritzCount += 240
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 2:
                    scene.spritzAmount = 12
                    scene.spritzCount += 360
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 3:
                    scene.spritzAmount = 12
                    scene.spritzCount += 120
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 4:
                    scene.xTapAmount = 60
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 5:
                    scene.xTapAmount = 100
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 6:
                    scene.xTapAmount = 160
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 7:
                    scene.xTapAmount = 240
                    scene.xTapCount += 20
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                default:
                    break
                }
                scene.card1 = nil
                scene.card2 = nil
                scene.card3 = nil
                scene.okButton = nil
                scene.changeEffectButton = nil
                scene.cardSelected = false
                scene.cardRevealed = false
                scene.cardsActive = false
                scene.selectedArray = [Int]()
                for child in scene.cardLayer.children {
                    child.run(animation)
                }
                scene.reactivateTimer()
            }
            
        }
        
        
        if action == "eat_mold" {
            if inventory.molds.count > 0 {
                let indexToEat = randomInRange(lo: 0, hi: inventory.molds.count - 1)
                if inventory.molds[indexToEat].moldType != MoldType.star {
                    var eatcount = 0
                    displayLoop: for molds in inventory.displayMolds {
                        if molds.moldType == inventory.molds[indexToEat].moldType {
                            inventory.displayMolds.remove(at: eatcount)
                            break displayLoop
                        }
                        eatcount += 1
                    }
                    inventory.scorePerSecond -= inventory.molds[indexToEat].PPS
                    inventory.molds.remove(at: indexToEat)
                    scene.molds = inventory.displayMolds
                    scene.playSound(select: "crunch")
                    scene.updateMolds()
                }
            }
        }
        
        if action == "addDiamond" {
            activateSleepTimer()
            incrementDiamonds(newDiamonds: 1)
        }
        if action == "add2Diamond" {
            activateSleepTimer()
            incrementDiamonds(newDiamonds: 2)
        }
        if action == "wurmded" {
            inventory.wormsKilled += 1
            if inventory.currentQuest == "kill" {
                inventory.questAmount += 1
            }
            if inventory.questAmount == inventory.questGoal {
                questAchieved()
            }
            if inventory.wormsKilled == 20 {
                if inventory.achievementsDicc["kill 20"] == false {
                    inventory.achievementsDicc["kill 20"] = true
                    inventory.achieveDiamonds += 5
                }
            }
            else if inventory.wormsKilled == 100 {
                if inventory.achievementsDicc["kill 100"] == false {
                    inventory.achievementsDicc["kill 100"] = true
                    inventory.achieveDiamonds += 5
                }
            }
            else if inventory.wormsKilled == 500 {
                if inventory.achievementsDicc["kill 500"] == false {
                    inventory.achievementsDicc["kill 500"] = true
                    inventory.achieveDiamonds += 5
                }
            }
            else if inventory.wormsKilled == 5000 {
                if inventory.achievementsDicc["kill 5000"] == false {
                    inventory.achievementsDicc["kill 5000"] = true
                    inventory.achieveDiamonds += 5
                }
            }
            else if inventory.wormsKilled == 10000 {
                if inventory.achievementsDicc["kill 10000"] == false {
                    inventory.achievementsDicc["kill 10000"] = true
                    inventory.achieveDiamonds += 25
                }
            }
        }
        
        if action == "game_scene_buy" {
            activateSleepTimer()
            scene.playSound(select: "select")
            //popup
            var Texture = SKTexture(image: UIImage(named: "cyber_menu_glow")!)
            scene.menuPopUp = SKSpriteNode(texture:Texture)
            // Place in scene
            scene.menuPopUp.position = CGPoint(x:scene.frame.midX, y:scene.frame.midY)
            scene.menuPopUp.size = skView.bounds.size
            
            let appear = SKAction.scale(to: 1, duration: 0.2)
            scene.menuPopUp.setScale(0.01)
            //this is the godo case
            let action = SKAction.sequence([appear])
            scene.menuPopUp.run(action)
            scene.addChild(scene.menuPopUp)
            
            _ = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameViewController.showMenu), userInfo: nil, repeats: false)
            
            
        }
        if action == "game_scene_inventory" {
            activateSleepTimer()
            scene.playSound(select: "select")
            //popup
            var Texture = SKTexture(image: UIImage(named: "cyber_menu_glow")!)
            scene.menuPopUp = SKSpriteNode(texture:Texture)
            // Place in scene
            scene.menuPopUp.position = CGPoint(x:scene.frame.midX, y:scene.frame.midY)
            scene.menuPopUp.size = skView.bounds.size
            
            let appear = SKAction.scale(to: 1, duration: 0.2)
            scene.menuPopUp.setScale(0.01)
            //this is the godo case
            let action = SKAction.sequence([appear])
            scene.menuPopUp.run(action)
            scene.addChild(scene.menuPopUp)
            
            _ = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(GameViewController.showInventory), userInfo: nil, repeats: false)
            
            
        }
        if action == "game_scene_camera" {
            scene.eventTimer.invalidate()
            scene.cameraButton.removeFromParent()
            scene.inventoryButton.removeFromParent()
            scene.header.removeFromParent()
            scene.buyButton.removeFromParent()
            scene.diamondBuy.removeFromParent()
            scene.gameLayer.removeAllChildren()
            scene.diamondIcon.removeFromParent()
            scene.diamondCLabel.removeFromParent()
            cashLabel.isHidden = true
            cashHeader.isHidden = true
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(captureScreen), userInfo: nil, repeats: false)
            
        }
        if action == "diamond_buy" {
            activateSleepTimer()
            scene.doDiamondShop()
            scene.playSound(select: "select")
        }
        if action == "diamond_exit" {
            activateSleepTimer()
            for child in scene.diamondLayer.children {
                child.run(animation)
            }
            scene.diamondShop = false
            scene.playSound(select: "exit")
        }
        if action == "diamond_tiny" {
            scene.playSound(select: "gem case")
            activateSleepTimer()
            purchaseMyProduct(product: iapProducts[3])
        }
        if action == "diamond_small" {
            scene.playSound(select: "gem case")
            activateSleepTimer()
            
            purchaseMyProduct(product: iapProducts[0])
        }
        if action == "diamond_medium" {
            scene.playSound(select: "gem case")
            activateSleepTimer()
            
            purchaseMyProduct(product: iapProducts[2])
        }
        if action == "diamond_large" {
            scene.playSound(select: "chest")
            activateSleepTimer()

            purchaseMyProduct(product: iapProducts[1])
        }
        
    }
    
    func tapHelper() {
        activateSleepTimer()
        scene.tapPoint = inventory.scorePerTap
        if scene.xTapCount > 0 {
            incrementCash(pointsToAdd: (inventory.scorePerTap * BInt(scene.xTapAmount)))
        }
        else {
            incrementCash(pointsToAdd: inventory.scorePerTap)
        }
        
        if scene.diamondShop == false {
            if scene.xTapCount > 0 {
                scene.animateScore(point: scene.tapLoc, amount: scene.tapPoint * BInt(scene.xTapAmount), tap: true)
            }
            else {
                scene.animateScore(point: scene.tapLoc, amount: scene.tapPoint, tap: true)
            }
        }
        if inventory.currentQuest == "tap" {
            inventory.questAmount += 1
        }
        if inventory.questAmount == inventory.questGoal {
            questAchieved()
        }
    }
    
    func captureScreen() {
        
        
        UIGraphicsBeginImageContextWithOptions(skView.bounds.size, true, 0)
        
        skView.drawHierarchy(in: skView.bounds, afterScreenUpdates: true)
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        displayShareSheet(shareContent: image)
        scene.playSound(select: "camera")
    }
    
    func displayShareSheet(shareContent:UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as UIImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {
            self.scene.reactivateTimer()
            self.cashLabel.isHidden = false
            self.cashHeader.isHidden = false
            self.scene.createButton()
            self.scene.diamondCLabel.text = String(self.inventory.diamonds)
        })
    }
    
    func showMenu() {
        scene.isActive = false
        //scene.diamondLabel.text = ""
        menu = MenuScene(size: skView.bounds.size)
        menu.name = "menu"
        menu.scaleMode = .resizeFill
        menu.touchHandler = menuHandler
        skView.presentScene(menu)
    }
    
    func showInventory() {
        //scene.diamondLabel.text = ""
        inventoryScene = MoldInventory(size: skView.bounds.size)
        inventoryScene.name = "inventoryScene"
        inventoryScene.scaleMode = .resizeFill
        inventoryScene.touchHandler = inventorySceneHandler
        inventoryScene.unlockedMolds = inventory.unlockedMolds
        inventoryScene.ownedMolds = inventory.molds
        inventoryScene.totalNum = inventory.displayMolds.count
        inventoryScene.display = inventory.displayMolds
        skView.presentScene(inventoryScene)
        scene.isActive = false
    }
    
    func enableTouch() {
        self.view.isUserInteractionEnabled = true
    }

    
    //set achievements to true
    func updateBreedAchievements() {
        
        if inventory.unlockedMolds.count == 5 {
            if inventory.achievementsDicc["breed 5"] == false {
                inventory.achievementsDicc["breed 5"] = true
                inventory.achieveDiamonds += 5
            }
        }
        else if inventory.unlockedMolds.count == 25 {
            if inventory.achievementsDicc["breed 25"] == false {
                inventory.achievementsDicc["breed 25"] = true
                inventory.achieveDiamonds += 5
            }
        }
        else if inventory.unlockedMolds.count == 42 {
            if inventory.achievementsDicc["breed 42"] == false {
                inventory.achievementsDicc["breed 42"] = true
                inventory.achieveDiamonds += 5
            }
        }
        
        if inventory.currentQuest == "discover" {
            inventory.questAmount += 1
        }
        if inventory.questAmount == inventory.questGoal {
            questAchieved()
        }
    }
    
    //per second function
    func addCash() {
        //chance for two molds nex to each other kiss or fight
        if inventory.displayMolds.count > 1 {
            if Int(arc4random_uniform(60)) < 6 {
                scene.kissOrFight()
            }
        }
        //adjust spritz counter
        if scene.spritzCount > 0 {
            incrementCash(pointsToAdd: (inventory.scorePerSecond * scene.spritzAmount))
            scene.spritzCount -= 1
            scene.spritzLabel.text = String(scene.spritzCount)
            if scene.spritzCount == 0 {
                scene.spritzLabel.text = ""
                scene.spritzLabel.position = CGPoint(x:scene.frame.midX-65, y:scene.frame.midY+190)
                shiftTimerLabels()
            }
        }
            //no spritz just add normal cash
        else {
            incrementCash(pointsToAdd: inventory.scorePerSecond)
            scene.spritzLabel.text = ""
        }
        //calculate animation
        if inventory.scorePerSecond > 0 {
            if scene.diamondShop == false && scene.isActive == true {
                if scene.spritzCount > 0 && scene.spritzAmount > 0 {
                    scene.animateScore(point: scene.center, amount: (inventory.scorePerSecond*scene.spritzAmount), tap: false)
                }
                else if scene.spritzCount > 0 && scene.spritzAmount == 0 {
                    
                }
                else {
                    scene.animateScore(point: scene.center, amount: inventory.scorePerSecond, tap: false)
                }
                
            }
        }
        //handle timers for worm repel and also bonus tap multipliers
        if scene.isActive {
            //worm repel timer
            if scene.wormRepelCount > 0 {
                scene.wormRepelCount -= 1
                scene.wormRepelLabel.text = String(scene.wormRepelCount)
                if scene.wormRepelCount == 0 {
                    scene.wormRepelLabel.text = ""
                    scene.wormRepelLabel.position = CGPoint(x:scene.frame.midX, y:scene.frame.midY+190)
                    shiftTimerLabels()
                }
            }
            

            //xtap
            if scene.xTapCount > 0 {
                scene.xTapCount -= 1
                scene.xTapLabel.text = String(scene.xTapCount)
                if scene.xTapCount == 0 {
                    scene.xTapLabel.text = ""
                    scene.xTapLabel.position = CGPoint(x:scene.frame.midX+65, y:scene.frame.midY+190)
                    shiftTimerLabels()
                }
            }
            
        }
    }
    
    //since there can be up to three timers in the game scene at the same time this method will space them correctly
    func shiftTimerLabels() {
        if scene.wormRepelCount == 0 {
            if scene.xTapCount > 0 {
                var move = SKAction.move(to: CGPoint(x: scene.frame.midX+33,y: scene.xTapLabel.position.y), duration:0.45)
                if scene.spritzCount == 0 {
                    move = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                }
                scene.xTapLabel.run(move)
            }
            if scene.spritzCount > 0 {
                var move = SKAction.move(to: CGPoint(x: scene.frame.midX-33,y: scene.spritzLabel.position.y), duration:0.45)
                if scene.xTapCount == 0 {
                    move = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                }
                scene.spritzLabel.run(move)
            }

        }
        else {
            if scene.xTapCount > 0 {
                var move = SKAction.move(to: CGPoint(x: scene.frame.midX+65,y: scene.xTapLabel.position.y), duration:0.45)
                if scene.spritzCount == 0 {
                    move = SKAction.move(to: CGPoint(x: scene.frame.midX+33,y: scene.xTapLabel.position.y), duration:0.45)
                    var move2 = SKAction.move(to: CGPoint(x: scene.frame.midX-33,y: scene.xTapLabel.position.y), duration:0.45)
                    scene.wormRepelLabel.run(move2)
                }
                else {
                    var move2 = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                    scene.wormRepelLabel.run(move2)
                }
                scene.xTapLabel.run(move)
            }

            if scene.spritzCount > 0 {
                var move = SKAction.move(to: CGPoint(x: scene.frame.midX-65,y: scene.spritzLabel.position.y), duration:0.45)
                if scene.xTapCount == 0 {
                    move = SKAction.move(to: CGPoint(x: scene.frame.midX-33,y: scene.xTapLabel.position.y), duration:0.45)
                    var move2 = SKAction.move(to: CGPoint(x: scene.frame.midX+33,y: scene.xTapLabel.position.y), duration:0.45)
                    scene.wormRepelLabel.run(move2)
                }
                else {
                    var move2 = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                    scene.wormRepelLabel.run(move2)
                }
                scene.spritzLabel.run(move)
            }
            if scene.xTapCount == 0 && scene.spritzCount == 0 {
                var move = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                scene.wormRepelLabel.run(move)
            }
        }
    }
    
    //formats the cash label with proper suffix to stay within 3 digits
    func updateLabels() {
        var cashString = String(describing: inventory.cash)
        if (cashString.characters.count < 4) {
            cashLabel.text = String(describing: inventory.cash)
        }
        else {
            let charsCount = cashString.characters.count
            var cashDisplayString = cashString[0]
            
            var suffix = ""
            switch charsCount {
            case 4:
                suffix = "K"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 5:
                suffix = "K"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 6:
                suffix = "K"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 7:
                suffix = "M"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 8:
                suffix = "M"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 9:
                suffix = "M"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 10:
                suffix = "B"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 11:
                suffix = "B"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 12:
                suffix = "B"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 13:
                suffix = "T"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 14:
                suffix = "T"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 15:
                suffix = "T"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 16:
                suffix = "Q"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 17:
                suffix = "Q"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 18:
                suffix = "Q"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 19:
                suffix = "Qi"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 20:
                suffix = "Qi"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 21:
                suffix = "Qi"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 22:
                suffix = "Se"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 23:
                suffix = "Se"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 24:
                suffix = "Se"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 25:
                suffix = "Sp"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 26:
                suffix = "Sp"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 27:
                suffix = "Sp"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 28:
                suffix = "Oc"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 29:
                suffix = "Oc"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 30:
                suffix = "Oc"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            case 31:
                suffix = "No"
                cashDisplayString = cashDisplayString + "." + cashString[1..<4]
                break
            case 32:
                suffix = "No"
                cashDisplayString = cashDisplayString + cashString[1] + "." + cashString[2..<5]
                break
            case 33:
                suffix = "No"
                cashDisplayString = cashDisplayString + cashString[1..<3] + "." + cashString[3..<6]
                break
            default:
                suffix = "D"
                break
            }
            cashDisplayString += " "
            cashDisplayString += suffix
 
            cashLabel.text = cashDisplayString
        }
        
    }
    
    //add diamonds and update the scene lable
    func incrementDiamonds(newDiamonds: Int) {
        inventory.diamonds += newDiamonds
        scene.diamondCLabel.text = String(inventory.diamonds)
    }
    
    //tap for cash funciotn
    func incrementCash(pointsToAdd: BInt) {
        inventory.cash += pointsToAdd
        updateLabels()
       
    }
    
    //get a random integer in this range. used for some stuff
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        print("fetching products")
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            TINY_PRODUCT_ID,
            SMALL_PRODUCT_ID,
            MEDIUM_PRODUCT_ID,
            LARGE_PRODUCT_ID,
            STAR_PRODUCT_ID,
            DEATH_RAY_PRODUCT_ID,
            AUTO_TAP_PRODUCT_ID
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        print("products request")
        if (response.products.count > 0) {
            iapProducts = response.products
            
            // 1st IAP Product (Consumable) ------------------------------------
            let firstProduct = response.products[0] as SKProduct
            
            // Get its price from iTunes Connect
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = firstProduct.priceLocale
            let price1Str = numberFormatter.string(from: firstProduct.price)
            print(price1Str)
            
            // Show its description
            //consumableLabel.text = firstProduct.localizedDescription + "\nfor just \(price1Str!)"
            // ------------------------------------------------
            
            
            
            // 2nd IAP Product (Consumable) ------------------------------
            let secondProd = response.products[1] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = secondProd.priceLocale
            let price2Str = numberFormatter.string(from: secondProd.price)
            print(price2Str)
            // 3rd IAP Product (Consumable) ------------------------------

            let thirdProd = response.products[2] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = thirdProd.priceLocale
            let price3Str = numberFormatter.string(from: thirdProd.price)
            print(price3Str)
            // 4th IAP Product (Consumable) ------------------------------

            let fourthProd = response.products[3] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = fourthProd.priceLocale
            let price4Str = numberFormatter.string(from: fourthProd.price)
            print(price4Str)
            // 5th IAP Product (Consumable) ------------------------------
            
            let fifthProd = response.products[4] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = fifthProd.priceLocale
            let price5Str = numberFormatter.string(from: fifthProd.price)
            print(price5Str)
            // 6th IAP Product (Non-Consumable) ------------------------------
            
            let sixthProd = response.products[5] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = sixthProd.priceLocale
            let price6Str = numberFormatter.string(from: sixthProd.price)
            print(price6Str)
            // 7th IAP Product (Non-Consumable) ------------------------------
            
            let seventhProd = response.products[6] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = seventhProd.priceLocale
            let price7Str = numberFormatter.string(from: seventhProd.price)
            print(price7Str)
        }
        else {
            UIAlertView(title: "IAP Items",
                        message: "Couldn't load products",
                        delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            
            // IAP Purchases dsabled on the Device
        } else {
            UIAlertView(title: "IAP Tutorial",
                        message: "Purchases are disabled in your device!",
                        delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    if productID == TINY_PRODUCT_ID {

                        incrementDiamonds(newDiamonds: 5)
                        save()

                    }
                    else if productID == SMALL_PRODUCT_ID {

                        incrementDiamonds(newDiamonds: 16)
                        save()

                    }
                    else if productID == MEDIUM_PRODUCT_ID {

                        incrementDiamonds(newDiamonds: 57)
                        save()

                    }
                    else if productID == LARGE_PRODUCT_ID {

                        incrementDiamonds(newDiamonds: 301)
                        save()

                    }
                    else if productID == STAR_PRODUCT_ID {
                        premiumShop.playSound(select: "cash register")
                        let mold = Mold(moldType: MoldType.star)
                        inventory.molds.append(mold)
                        inventory.scorePerSecond += mold.PPS
                        
                        var added = false
                        unlockLoop: for pMold in inventory.unlockedMolds {
                            if pMold.moldType == mold.moldType {
                                added = true
                                break unlockLoop
                            }
                        }
                        if added == false {
                            inventory.unlockedMolds.append(mold)
                        }

                        inventory.molds.append(mold)
                        if inventory.displayMolds.count < 25 {
                            inventory.displayMolds.append(mold)
                        }
                        inventory.scorePerSecond += mold.PPS
                        if inventory.molds.count == 5 {
                            if inventory.achievementsDicc["own 5"] == false {
                                inventory.achievementsDicc["own 5"] = true
                                inventory.achieveDiamonds += 5
                            }
                        }
                        else if inventory.molds.count == 25 {
                            if inventory.achievementsDicc["own 25"] == false {
                                inventory.achievementsDicc["own 25"] = true
                                inventory.achieveDiamonds += 5
                            }
                        }
                        else if inventory.molds.count == 100 {
                            if inventory.achievementsDicc["own 100"] == false {
                                inventory.achievementsDicc["own 100"] = true
                                inventory.achieveDiamonds += 5
                            }
                        }
                        else if inventory.molds.count == 250 {
                            if inventory.achievementsDicc["own 250"] == false {
                                inventory.achievementsDicc["own 250"] = true
                                inventory.achieveDiamonds += 10
                            }
                        }
                        
                        updateLabels()
                        save()
                    }
                    else if productID == DEATH_RAY_PRODUCT_ID {
                        inventory.deathRay = true
                        scene.deathRay = true
                        premiumShop.deathRayBought = true
                        premiumShop.playSound(select: "cash register")
                        let Texture = SKTexture(image: UIImage(named: "death ray bought")!)
                        premiumShop.deathRayButton = SKSpriteNode(texture:Texture)
                        premiumShop.deathRayButton.position = CGPoint(x:premiumShop.frame.midX+50, y:premiumShop.frame.midY+170)
                        premiumShop.addChild(premiumShop.deathRayButton)
                        //death ray achievmenet
                        if inventory.achievementsDicc["death ray"] == false {
                            inventory.achievementsDicc["death ray"] = true
                            inventory.achieveDiamonds += 5
                        }
                        save()
                    }
                    else if productID == AUTO_TAP_PRODUCT_ID {
                        premiumShop.playSound(select: "cash register")
                        if inventory.autoTap == false {
                            inventory.autoTap = true
                        }
                        inventory.autoTapLevel += 1
                        
                        premiumShop.autoTapBought = inventory.autoTapLevel
                        var Texture = SKTexture(image: UIImage(named: "auto-miner 1")!)
                        print(premiumShop.autoTapBought)
                        if premiumShop.autoTapBought <= 4 {
                            Texture = SKTexture(image: UIImage(named: "auto-miner \(premiumShop.autoTapBought + 1)")!)
                        }
                        else {
                            Texture = SKTexture(image: UIImage(named: "auto-miner purchased")!)
                        }
                        premiumShop.autoTapButton.removeFromParent()
                        premiumShop.autoTapButton = SKSpriteNode(texture:Texture)
                        premiumShop.autoTapButton.position = CGPoint(x:premiumShop.frame.midX+50, y:premiumShop.frame.midY+50);
                        premiumShop.addChild(premiumShop.autoTapButton)
                        save()
                    }
                    
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
    
}
