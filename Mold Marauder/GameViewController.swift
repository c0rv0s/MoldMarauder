
//
//  GameViewController.swift
//  Mold Marauder
//
//  Created by Nathan Mueller on 1/31/17.
//  Copyright © 2017 Nathan Mueller. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import StoreKit
import AVFoundation
import GameKit

//facebook stuf for info/ads
//import FBSDKCoreKit
//import FBSDKLoginKit
//import FBSDKShareKit
//import FBSDKCoreKit.FBSDKAppEvents

class GameViewController: UIViewController, ARSKViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver,
GKGameCenterControllerDelegate {
    var scene: GameScene!
    var ARgameScene: ARScene!
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
    var helpScene: HelpScene!
    var reinvestments: Reinvestments!
    var timePrison: TimePrison!
    
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var arskView: ARSKView!
    
    var aroff = true
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    var backgroundMusicPlayer = AVAudioPlayer()
    var APP_ID = "com.Spacey-Dreams.Mold-Marauder-by-Nathan"
    
    var combos: Combos!
    
    var preventNoTapAbuse: Timer? = nil
    
    @IBOutlet weak var cashHeader: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
    var cashTimer: Timer? = nil
    var autoTapTimer: Timer? = nil
    
    //    leaderboard stuff
    /* Variables */
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "num_molds"
    
    //IAP
    var available = false
    let TINY_PRODUCT_ID = "com.SpaceyDreams.MoldMarauderbyNathan.mold_99_cent_diamond"
    let SMALL_PRODUCT_ID = "com.SpaceyDreams.MoldMarauderbyNathan.mold_299_cent_diamond"
    let MEDIUM_PRODUCT_ID = "com.SpaceyDreams.MoldMarauderbyNathan.mold_999_cent_diamond"
    let LARGE_PRODUCT_ID = "com.SpaceyDreams.MoldMarauderbyNathan.mold_4999_cent_diamond"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var nonConsumablePurchaseMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseMade")
    var diamonds = UserDefaults.standard.integer(forKey: "diamonds")
    let backgrounds: Set = ["cave", "crystal forest", "yurt", "apartment", "yacht", "space", "dream"]
    
    //    iclodu thing
    var iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
    
    //    level molds
    //    after 400 just go by every 100 after that
    let moldLevCounts = [10,20,40,65,90,125,165,210,265,320,370,425]
    
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
        // Call the GC authentication controller
        authenticateLocalPlayer()
        //    get purchaseable products
        fetchAvailableProducts()
        
        let defaults = UserDefaults.standard
        
        //instantiate player inventory
        if let savedInventory = defaults.object(forKey: "inventory") as? Data {
            do {
                if let loadedInventory = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedInventory) as? Inventory {
                    inventory = loadedInventory
                }
            } catch {
                print("Couldn't load inventory.")
            }
        }
        else {
            inventory = Inventory()
            // check icloud
            if (iCloudKeyStore?.string(forKey: "level")) != nil {
                loadiCloud()
            }
        }
        
        //    TESTING - REMOVE
//            inventory = Inventory()
//        inventory.tutorialProgress = 19
        //    inventory.autoTap = false
        //    inventory.autoTapLevel = 0
//        inventory.diamonds += 500
//            inventory.level = 75
//            incrementCash(pointsToAdd: BInt("9999999999999999999999999999")!)
//            inventory.unlockedMolds.append(Mold(moldType: MoldType.invisible))
//            inventory.molds.append(Mold(moldType: MoldType.invisible))
//        inventory.moldCountDicc["Metaphase Mold"] = 3
//            inventory.reinvestmentCount = 3
//        inventory.molds.append(Mold(moldType: MoldType.metaphase))
//        inventory.moldCountDicc["Metaphase Mold"] = 1
//        inventory.unlockedMolds.append(Mold(moldType: MoldType.metaphase))
//        inventory.timePrisonEnabled = true
//        inventory.background = "dream"
//        inventory.molds.append(Mold(moldType: MoldType.god))
//        inventory.unlockedMolds.append(Mold(moldType: MoldType.god))
//        inventory.moldCountDicc["God Mold"] = 1
//        inventory.scorePerSecond += MoldType.god.pointsPerSecond
//        inventory.phaseCrystals = BInt("10000000")!
        
        
        // Configure the view.
        ARgameScene = ARScene(size: arskView.bounds.size)
        // Tell the session to automatically detect horizontal planes
        configuration.planeDetection = .horizontal
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.name = "scene"
        scene.scaleMode = .aspectFill
        scene.touchHandler = handleTap
        scene.mute = inventory.muteSound
        
        //load the data that's displayed in the scene
        scene.molds = inventory.displayMolds   //this line might be unnecessary
        scene.numDiamonds = inventory.diamonds
        scene.tapPoint = inventory.scorePerTap
        scene.tutorial = inventory.tutorialProgress
        //set worm difficulty based on level
        if inventory.level < 3 {
            scene.wormDifficulty = 4 - inventory.laser + 1
        }
            
        else if inventory.level < 29 {
            scene.wormDifficulty = 5 - inventory.laser
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
        }
        scene.deathRay = inventory.deathRay
        
        // Present the scene.
        skView.presentScene(scene)
        if inventory.background != "cave" {
            scene.backgroundName = inventory.background
            scene.setBackground()
        }
        playBackgroundMusic(filename: "\(inventory.background).wav")
        scene.diamondCLabel.text = String(inventory.diamonds)
        
        //  reinvest count
        scene.reinvestCount = inventory.reinvestmentCount
        //  add save game observer
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.myObserverMethod(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        //    check quests
        if inventory.questGoal == 0  {
            generateQuest()
        }
        
        //    ui adjustment for screen size
        switch UIDevice().screenType {
        case .iPhone4:
            //iPhone 4
            topMargin.constant -= 18
            cashHeader.font = cashHeader.font.withSize(12)
            cashLabel.font = cashLabel.font.withSize(12)
            break
        case .iPhone5:
            //iPhone 5
            topMargin.constant -= 12
            cashHeader.font = cashHeader.font.withSize(12)
            cashLabel.font = cashLabel.font.withSize(12)
            break
        case .iPhone8:
            topMargin.constant += 25
        case .iPhone8Plus:
            topMargin.constant += 30
        case .iPhoneX:
            topMargin.constant -= 10
            cashHeader.font = cashHeader.font.withSize(14)
            cashLabel.font = cashLabel.font.withSize(14)
        default:
            break
        }
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.offlineCash()
        }
        
        shiftTimerLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewDidAppear(true)
        reactivateCashTimer()
        
        if scene.eventTimer == nil && inventory.tutorialProgress != 0 {
            scene.reactivateTimer()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if aroff == false {
            // Pause the view's session
            arskView.session.pause()
        }
        
    }
    //    auth game center
    // MARK: - GAME CENTER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }
    
    func SubmitToGC(_ sender: AnyObject) {
        
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(inventory.molds.count)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    //    MARK: - ICLOUD
    //    save to icloud
    func saveToiCloud() {
        //non array or dictionary stuff
        //like ints and booleans
        iCloudKeyStore?.set(inventory.level, forKey: "level")
        let sScorePerTap = String(describing: inventory.scorePerTap)
        let sLevelUpCost = String(describing: inventory.levelUpCost)
        let sScorePerSecond = String(describing: inventory.scorePerSecond)
        let sCash = String(describing: inventory.cash)
        iCloudKeyStore?.set(sScorePerTap, forKey: "scorePerTap")
        iCloudKeyStore?.set(sLevelUpCost, forKey: "levelUpCost")
        iCloudKeyStore?.set(sScorePerSecond, forKey: "scorePerSecond")
        iCloudKeyStore?.set(sCash, forKey: "cash")
        iCloudKeyStore?.set(inventory.diamonds, forKey: "diamonds")
        iCloudKeyStore?.set(inventory.displayAmount, forKey: "displayAmount")
        iCloudKeyStore?.set(inventory.deathRay, forKey: "deathRay")
        iCloudKeyStore?.set(inventory.incubator, forKey: "incubator")
        iCloudKeyStore?.set(inventory.laser, forKey: "laser")
        iCloudKeyStore?.set(inventory.wormsKilled, forKey: "wormsKilled")
        iCloudKeyStore?.set(inventory.achieveDiamonds, forKey: "achieveDiamonds")
        
        iCloudKeyStore?.set(inventory.autoTap, forKey: "autoTap")
        iCloudKeyStore?.set(inventory.autoTapLevel, forKey: "autoTapLevel")
        
        iCloudKeyStore?.set(inventory.repelTimer, forKey: "repelTimer")
        iCloudKeyStore?.set(inventory.xTapAmount, forKey: "xTapAmount")
        iCloudKeyStore?.set(inventory.xTapCount, forKey: "xTapCounter")
        iCloudKeyStore?.set(inventory.spritzAmount, forKey: "spritzAmount")
        iCloudKeyStore?.set(inventory.spritzCount, forKey: "spritzCounter")
        iCloudKeyStore?.set(inventory.background, forKey: "background")
        iCloudKeyStore?.set(inventory.currentQuest, forKey: "currentQuest")
        iCloudKeyStore?.set(inventory.questGoal, forKey: "questGoal")
        iCloudKeyStore?.set(inventory.questAmount, forKey: "questAmount")
        iCloudKeyStore?.set(inventory.questReward, forKey: "questReward")
        iCloudKeyStore?.set(inventory.likedFB, forKey: "likedFB")
        iCloudKeyStore?.set(inventory.muteMusic, forKey: "muteMusic")
        iCloudKeyStore?.set(inventory.muteSound, forKey: "muteSound")
        
        iCloudKeyStore?.set(inventory.tutorialProgress, forKey: "tutorialProgress")
        
        iCloudKeyStore?.set(inventory.reinvestmentCount, forKey: "reinvestmentCount")
        iCloudKeyStore?.set(inventory.timePrisonEnabled, forKey: "timePrisonEnabled")
        iCloudKeyStore?.set(inventory.freedFromTimePrison, forKey: "freedFromTimePrison")
        let sCrystals = String(describing: inventory.phaseCrystals)
        iCloudKeyStore?.set(sCrystals, forKey: "phaseCrystals")
        
        //now for achievmeents and molds
        var saveMolds = [Int]()
        for mold in inventory.molds {
            saveMolds.append(mold.moldType.rawValue)
        }
        var saveDisplayMolds = [Int]()
        for mold in inventory.displayMolds {
            saveDisplayMolds.append(mold.moldType.rawValue)
        }
        var saveUnlockedMolds = [Int]()
        for mold in inventory.unlockedMolds {
            saveUnlockedMolds.append(mold.moldType.rawValue)
        }
        
        iCloudKeyStore?.set(saveMolds, forKey: "molds")
        iCloudKeyStore?.set(saveDisplayMolds, forKey: "displayMolds")
        iCloudKeyStore?.set(saveUnlockedMolds, forKey: "unlockedMolds")
        iCloudKeyStore?.set(inventory.achievementsDicc, forKey: "achievementsDicc")
        
        iCloudKeyStore?.set(inventory.levDicc, forKey: "levDicc")
        
        iCloudKeyStore?.set(inventory.moldCountDicc, forKey: "moldCountDicc")
        
        // using current date and time as an example
        let someDate = Date()
        
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970
        
        // convert to Integer
        let myInt = Int(timeInterval)
        
        iCloudKeyStore?.set(myInt, forKey: "quitTime")
        iCloudKeyStore?.set(inventory.offlineLevel, forKey: "offlineLevel")
        iCloudKeyStore?.synchronize()
        print("icloud saved")
    }
    //    load from icloud
    func loadiCloud() {
        inventory.level = iCloudKeyStore?.object(forKey: "level") as! Int
        inventory.scorePerTap = BInt(iCloudKeyStore?.object(forKey: "scorePerTap") as! String)!
        inventory.levelUpCost = BInt(iCloudKeyStore?.object(forKey: "levelUpCost") as! String)!
        inventory.scorePerSecond = BInt(iCloudKeyStore?.object(forKey: "scorePerSecond") as! String)!
        inventory.cash = BInt(iCloudKeyStore?.object(forKey: "cash") as! String)!
        inventory.diamonds = iCloudKeyStore?.object(forKey: "diamonds") as! Int
        inventory.displayAmount = iCloudKeyStore?.object(forKey: "displayAmount") as! Int
        inventory.deathRay = ((iCloudKeyStore?.object(forKey: "deathRay")) != nil)
        inventory.incubator = iCloudKeyStore?.object(forKey: "incubator") as! Int
        inventory.laser = iCloudKeyStore?.object(forKey: "laser") as! Int
        inventory.wormsKilled = iCloudKeyStore?.object(forKey: "wormsKilled") as! Int
        inventory.achieveDiamonds = iCloudKeyStore?.object(forKey: "achieveDiamonds") as! Int
        
        inventory.autoTap = ((iCloudKeyStore?.object(forKey: "autoTap")) != nil)
        inventory.autoTapLevel = iCloudKeyStore?.object(forKey: "autoTapLevel") as! Int
        
        inventory.repelTimer = iCloudKeyStore?.object(forKey: "repelTimer") as! Int
        inventory.xTapAmount = iCloudKeyStore?.object(forKey: "xTapAmount") as! Int
        if (iCloudKeyStore?.object(forKey: "xTapCount") != nil) {
            inventory.xTapCount = iCloudKeyStore?.object(forKey: "xTapCount") as! Int
        }
        else {
            inventory.xTapCount = 0
        }
        inventory.spritzAmount = iCloudKeyStore?.object(forKey: "spritzAmount") as! Int
        if (iCloudKeyStore?.object(forKey: "spritzCount") != nil) {
            inventory.spritzCount = iCloudKeyStore?.object(forKey: "spritzCount") as! Int
        }
        else {
            inventory.spritzCount = 0
        }
        inventory.background = iCloudKeyStore?.object(forKey: "background") as! String
        inventory.currentQuest = iCloudKeyStore?.object(forKey: "currentQuest") as! String
        inventory.questGoal = iCloudKeyStore?.object(forKey: "questGoal") as! Int
        inventory.questAmount = iCloudKeyStore?.object(forKey: "questAmount") as! Int
        inventory.questReward = iCloudKeyStore?.object(forKey: "questReward") as! Int
        inventory.likedFB = iCloudKeyStore?.object(forKey: "likedFB") as! Bool
        inventory.muteMusic = iCloudKeyStore?.object(forKey: "muteMusic") as! Bool
        inventory.muteSound = iCloudKeyStore?.object(forKey: "muteSound") as! Bool
        
        inventory.tutorialProgress = iCloudKeyStore?.object(forKey: "tutorialProgress") as! Int
        
        inventory.reinvestmentCount = iCloudKeyStore?.object(forKey: "reinvestmentCount") as! Int
        inventory.timePrisonEnabled = iCloudKeyStore?.object(forKey: "timePrisonEnabled") as! Bool
        inventory.freedFromTimePrison = iCloudKeyStore?.object(forKey: "freedFromTimePrison") as! Array<Bool>
        inventory.phaseCrystals = BInt(iCloudKeyStore?.object(forKey: "phaseCrystals") as! String)!
        
        let saveMolds = iCloudKeyStore?.object(forKey: "molds") as! Array<Int>
        let saveDisplayMolds = iCloudKeyStore?.object(forKey: "displayMolds") as! Array<Int>
        let saveUnlockedMolds = iCloudKeyStore?.object(forKey: "unlockedMolds") as! Array<Int>
        
        inventory.molds = [Mold]()
        for mold in saveMolds {
            inventory.molds.append(Mold(moldType: MoldType(rawValue: mold)!))
        }
        inventory.displayMolds = [Mold]()
        for mold in saveDisplayMolds {
            inventory.displayMolds.append(Mold(moldType: MoldType(rawValue: mold)!))
        }
        inventory.unlockedMolds = [Mold]()
        for mold in saveUnlockedMolds {
            inventory.unlockedMolds.append(Mold(moldType: MoldType(rawValue: mold)!))
        }
        
        inventory.achievementsDicc = iCloudKeyStore?.object(forKey: "achievementsDicc") as! [String : Bool]
        inventory.levDicc = iCloudKeyStore?.object(forKey: "levDicc") as! [String : Int]
        inventory.moldCountDicc = iCloudKeyStore?.object(forKey: "moldCountDicc") as! [String : Int]
        inventory.quitTime = iCloudKeyStore?.object(forKey: "quitTime") as! Int
        inventory.offlineLevel = iCloudKeyStore?.object(forKey: "offlineLevel") as! Int
        print("icloud loaded")
    }
    
    //MARK: - TIMERS
    
    func reactivateCashTimer() {
        cashTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.addCash), userInfo: nil, repeats: true)
        activateSleepTimer()
    }
    
    @objc func offlineCash() {
        // using current date and time as an example
        let someDate = Date()
        
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970
        
        // convert to Integer
        let myInt = Int(timeInterval)
        var difference = myInt - inventory.quitTime
        print("time dif:\(difference)")
        
        //under max alloted time
        if difference < (inventory.offlineLevel*1800) {
            print("under max")
            let multiplier = Int(Double(difference) * 0.06)
            let amount = inventory.scorePerSecond * multiplier
            if amount > 0 {
                incrementCash(pointsToAdd: amount)
                scene.animateScore(point: scene.center, amount: amount, tap: false, fairy: false, offline: true)
            }
            print("offline earnings: \(amount)")
        }
            //over alloted time
        else {
            print("over max")
            difference = inventory.offlineLevel*1800
            let multiplier = Int(Double(difference) * 0.06)
            let amount = inventory.scorePerSecond * multiplier
            if amount > 0 {
                incrementCash(pointsToAdd: amount)
                scene.animateScore(point: scene.center, amount: amount, tap: false, fairy: false, offline: true)
            }
            print("offline earnings: \(amount)")
        }
        
    }
    
    @objc func myObserverMethod(notification : NSNotification) {
        print("Observer method called")
        if scene.eventTimer != nil {
            scene.eventTimer.invalidate()
        }
        
        cashTimer?.invalidate()
        cashTimer = nil
        preventNoTapAbuse?.invalidate()
        save()
        //    save to icloud
        saveToiCloud()
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
        //this is for the case where the user is still in the first part of the tutorial
        // - the part that is managed entirely by the scene.tutorial variable
        if scene.tutorial <= 11 {
            inventory.tutorialProgress = scene.tutorial
        }
        
        do {
            let savedData = try NSKeyedArchiver.archivedData(withRootObject: inventory!, requiringSecureCoding: false)
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "inventory")
            print("saved")
        } catch {
            print("Couldn't save inventory")
        }
    }
    
    @objc func sleepMode() {
        if scene.isActive == false {
            if (moldShop) != nil {
                moldShop.scrollView?.removeFromSuperview()
            }
            if (breedScene) != nil {
                breedScene.scrollView?.removeFromSuperview()
            }
            if (inventoryScene) != nil {
                inventoryScene.scrollView?.removeFromSuperview()
            }
            if (levelScene) != nil {
                levelScene.scrollView?.removeFromSuperview()
            }
            if (helpScene) != nil {
                helpScene.scrollView?.removeFromSuperview()
            }
            
            incrementDiamonds(newDiamonds: 0)
            scene.molds = inventory.displayMolds
            scene.updateMolds()
            scene.isActive = true
            
            skView.presentScene(scene)
            
            scene.menuPopUp.removeFromParent()
            playBackgroundMusic(filename: "\(inventory.background).wav")
        }
        preventNoTapAbuse?.invalidate()
        cashTimer?.invalidate()
        scene.sleep()
        scene.isPaused = true
    }
    
    // MARK: - QUEST
    func generateQuest() {
        let questName = Int(arc4random_uniform(8))
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
                inventory.questGoal = 2500
            }
            else {
                inventory.questGoal = 7500
            }
            break
        case 1:
            //purchase 2 of most recently unlocked mold
            inventory.currentQuest = ""
            let index = inventory.unlockedMolds.count - 1
            let recentMold = inventory.unlockedMolds[index].name
            inventory.currentQuest += recentMold
            inventory.currentQuest += "&"
            inventory.questGoal = 2
            if inventory.level > 65 {
                inventory.questGoal = 4
            }
            inventory.questAmount = 0
            break
        case 2:
            //discover a new breed
            if inventory.unlockedMolds.count < 42 {
                inventory.currentQuest = "discover"
                inventory.questGoal = 1
            }
            else {
                generateQuest()
            }
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
            break
        case 4:
            //level up twice
            if inventory.level < 72 {
                inventory.currentQuest = "level"
                inventory.questGoal = 2
            }
            else {
                generateQuest()
            }
            break
        case 5:
            //capture some number of fairies
            inventory.currentQuest = "faerie"
            if inventory.level < 10 {
                inventory.questGoal = 12
            }
            else if inventory.level < 30 {
                inventory.questGoal = 26
            }
            else if inventory.level < 60 {
                inventory.questGoal = 40
            }
            else {
                inventory.questGoal = 60
            }
            break
        case 6:
            //like fb page
            if inventory.likedFB == false {
                inventory.currentQuest = "FB"
                inventory.questGoal = 1
            }
            else {
                generateQuest()
            }
            break
        case 7:
            //share a screenshot
            inventory.currentQuest = "screenshot"
            inventory.questGoal = 1
            break
        default:
            generateQuest()
            break
        }
        inventory.questAmount = 0
    }
    
    func questAchieved() {
        scene.addQuestClaimButton()
    }
    
    func checkMaxMolds() {
        for (mold, count) in inventory.moldCountDicc {
            if count >= 50 {
                moldShop.blockedMolds.insert(mold)
            }
        }
    }
    
    func updateMoldPrices() {
        for item in moldShop.unlockedMolds {
            moldShop.prices[item.name] = item.price + ((inventory.moldCountDicc[item.name] ?? 0) * (item.price / BInt(10)))
        }
    }
    
    
    // MARK: - HANDLERS
    // MENU HANDLER
    func menuHandler(action: String) {
        activateSleepTimer()
        if (action == "buy") {
            moldShop = MoldShop(size: skView.bounds.size)
            moldShop.levDicc = inventory.levDicc
            checkMaxMolds()
            moldShop.name = "moldShop"
            moldShop.unlockedMolds = inventory.unlockedMolds
            // remove the star mold, not necessary for the shop
            var index = 0
            star: for mold in moldShop.unlockedMolds {
                if mold.moldType == MoldType.star {
                    moldShop.unlockedMolds.remove(at: index)
                    break star
                }
                index += 1
            }
            // update prices
            updateMoldPrices()
            moldShop.scaleMode = .aspectFill
            moldShop.touchHandler = shopHandler
            if aroff {
                skView.presentScene(moldShop)
            }
            else {
                skView.presentScene(moldShop)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            moldShop.mute = inventory.muteSound
            moldShop.playSound(select: "select")
            
            if inventory.tutorialProgress == 12 {
                menu.tutorialLayer.removeAllChildren()
                moldShop.buyMoldTutorial()
                inventory.tutorialProgress = 13
            }
        }
        if (action == "item") {
            itemShop = ItemShop(size: skView.bounds.size)
            itemShop.name = "itemShop"
            itemShop.scaleMode = .aspectFill
            itemShop.touchHandler = itemHandler
            itemShop.laserBought = inventory.laser
            itemShop.level = inventory.level
            if aroff {
                skView.presentScene(itemShop)
            }
            else {
                skView.presentScene(itemShop)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            itemShop.mute = inventory.muteSound
            itemShop.playSound(select: "select")
        }
        if (action == "credits") {
            creditsScene = CreditsScene(size: skView.bounds.size)
            creditsScene.name = "creditsScene"
            creditsScene.scaleMode = .aspectFill
            creditsScene.touchHandler = creditsHandler
            if aroff {
                skView.presentScene(creditsScene)
            }
            else {
                skView.presentScene(creditsScene)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            creditsScene.mute = inventory.muteSound
            creditsScene.playSound(select: "select")
            if inventory.muteSound {
                creditsScene.addMuteSound()
            }
            if inventory.muteMusic {
                creditsScene.addMuteMusic()
            }
        }
        if (action == "help") {
            helpScene = HelpScene(size: skView.bounds.size)
            helpScene.name = "helpScene"
            helpScene.scaleMode = .aspectFill
            helpScene.touchHandler = helpHandler
            if aroff {
                skView.presentScene(helpScene)
            }
            else {
                skView.presentScene(helpScene)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            helpScene.mute = inventory.muteSound
            helpScene.playSound(select: "select")
        }
        if (action == "quest") {
            questScene = QuestScene(size: skView.bounds.size)
            questScene.name = "questScene"
            questScene.scaleMode = .aspectFill
            questScene.touchHandler = questHandler
            questScene.currentQuest = inventory.currentQuest
            questScene.questGoal = inventory.questGoal
            questScene.questAmount = inventory.questAmount
            if aroff {
                skView.presentScene(questScene)
            }
            else {
                skView.presentScene(questScene)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            questScene.mute = inventory.muteSound
            questScene.playSound(select: "select")
        }
        if (action == "achieve") {
            achievements = AchievementsScene(size: skView.bounds.size)
            achievements.name = "achievements"
            achievements.scaleMode = .aspectFill
            achievements.touchHandler = achieveHandler
            //achievmens progress
            achievements.wormsKilled = inventory.wormsKilled
            achievements.moldsOwned = inventory.molds.count
            achievements.speciesBred = inventory.unlockedMolds.count
            achievements.incLevel = inventory.incubator
            achievements.laserLevel = inventory.laser
            achievements.deathRay = inventory.deathRay
            achievements.level = inventory.level
            achievements.cash = inventory.cash
            
            achievements.rewardAmount = inventory.achieveDiamonds
            if aroff {
                skView.presentScene(achievements)
            }
            else {
                skView.presentScene(achievements)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            achievements.mute = inventory.muteSound
            achievements.playSound(select: "select")
        }
        if (action == "breed") {
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            breedScene = BreedScene(size: skView.bounds.size)
            breedScene.name = "breedScene"
            breedScene.unlockedMolds = inventory.unlockedMolds
            breedScene.scaleMode = .aspectFill
            breedScene.touchHandler = breedHandler
            
            //populate the owned molds array
            var moldSet = Set<String>()
            for mold in inventory.molds {
                if !moldSet.contains(mold.description) {
                    breedScene.ownedMolds.append(mold)
                    moldSet.insert(mold.description)
                }
            }
            //populate the possible combos array
            if breedScene.ownedMolds.count > 0 {
                for combo in combos.allCombos {
                    if inventory.unlockedMolds.contains(where: {$0.name == combo.child.name}) {
                        continue
                    }
                    var addCombo = true
                    for parent in combo.parents {
                        if !moldSet.contains(parent.description) {
                            addCombo = false
                            break
                        }
                    }
                    if addCombo {
                        breedScene.possibleCombos.append(combo)
                    }
                }
            }
            
            print("possible combos")
            breedScene.possibleCombos.forEach{combo in print(combo.child.description)}
            if breedScene.possibleCombos.count > 0 {
                breedScene.currentDiamondCombo = breedScene.possibleCombos[0]
            }
            if aroff {
                skView.presentScene(breedScene)
            }
            else {
                skView.presentScene(breedScene)
            }
            
            breedScene.mute = inventory.muteSound
            breedScene.playSound(select: "select")
            
            if inventory.tutorialProgress == 17 {
                //user is ready for the breeding tutorial
                if breedScene.possibleCombos.count > 0 {
                    breedScene.beginBreedTutorial()
                    inventory.tutorialProgress = 18
                }
            }
            
            print("tutorial")
            print(inventory.tutorialProgress)
        }
        if (action == "exit") {
            exitMenu()
        }
        if action == "level" {
            levelScene = LevelScene(size: skView.bounds.size)
            levelScene.name = "levelScene"
            levelScene.scaleMode = .aspectFill
            levelScene.timePrisonEnabled = inventory.timePrisonEnabled
            levelScene.touchHandler = levelHandler
            levelScene.currentLevel = inventory.level
            levelScene.currentScorePerTap = inventory.scorePerTap
            levelScene.levelUpCostActual = inventory.levelUpCost
            levelScene.calculateScorePerTap()
            levelScene.cash = inventory.cash
            levelScene.diamonds = inventory.diamonds
            levelScene.offlineLev = inventory.offlineLevel
            levelScene.current = inventory.background
            
            if aroff {
                skView.presentScene(levelScene)
            }
            else {
                skView.presentScene(levelScene)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            levelScene.mute = inventory.muteSound
            levelScene.playSound(select: "select")
        }
        if (action == "reinvest") {
            reinvestments = Reinvestments(size: skView.bounds.size)
            reinvestments.reinvestList = inventory.reinvestmentCount
            check: for mold in inventory.molds {
                if mold.moldType == MoldType.invisible {
                    reinvestments.canReinvest = true
                    break check
                }
            }
            reinvestments.name = "itemShop"
            reinvestments.scaleMode = .aspectFill
            reinvestments.touchHandler = reinvestHandler
            
            if aroff {
                skView.presentScene(reinvestments)
            }
            else {
                skView.presentScene(reinvestments)
            }
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            reinvestments.mute = inventory.muteSound
            reinvestments.playSound(select: "select")
        }
        if (action == "leaderboards") {
            SubmitToGC(self)
            let gcVC = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = .leaderboards
            gcVC.leaderboardIdentifier = LEADERBOARD_ID
            present(gcVC, animated: true, completion: nil)
        }
        if (action == "ar") {
            //   switch var
            if aroff {
                aroff = false
            }
            else {
                aroff = true
            }
            menu.playSound(select: "select")
            // open the ar scene
            var texSwitch = SKTexture(image: UIImage(named: "armodeon")!)
            if aroff {
                texSwitch = SKTexture(image: UIImage(named: "armodeoff")!)
            }
            menu.arButton.removeFromParent()
            menu.arButton = SKSpriteNode(texture: texSwitch)
            menu.arButton.position = CGPoint(x:menu.frame.midX-65, y:menu.frame.midY-100);
            menu.addChild(menu.arButton)
        }
        if (action == "time prison") {
            timePrison = TimePrison(size: skView.bounds.size)
            timePrison.name = "timePrison"
            timePrison.scaleMode = .aspectFill
            timePrison.touchHandler = timePrisonHandler
            timePrison.freedFromTimePrison = inventory.freedFromTimePrison
            timePrison.phaseCrystals = inventory.phaseCrystals
            if aroff {
                skView.presentScene(timePrison)
            }
            else {
                skView.presentScene(timePrison)
            }
            
            menu.cometLayer.removeAllChildren()
            menu.cometLayer.cometTimer.invalidate()
            timePrison.mute = inventory.muteSound
            timePrison.playSound(select: "select")
            cashLabel.isHidden = true
            cashHeader.isHidden = true
        }
        
    }
    
    //TIME PRISON HANDLER
    func timePrisonHandler(action: String) {
        activateSleepTimer()
        if timePrison.successLayer.children.count > 0 {
            timePrison.successLayer.removeAllChildren()
        }
        if (action == "back") {
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            cashLabel.isHidden = false
            cashHeader.isHidden = false
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        else if action == "god" {
            let metaFree = inventory.freedFromTimePrison[..<8].allSatisfy({$0 == true})
            if inventory.phaseCrystals < 1000000 || !metaFree {
                var text1Text = "You must free all Metaphase"
                var text2Text = "Molds before you can free"
                var text3Text = "the Mold God"
                if metaFree {
                    text1Text = "You need 1 million phase"
                    text2Text = "crystals to free the Mold God"
                    text3Text = ""
                }
                let textBox = SKSpriteNode(texture: SKTexture(image: UIImage(named: "pink dialogue")!))
                textBox.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY)
                textBox.setScale(1.25)
                timePrison.dialogueLayer.addChild(textBox)
                
                let text1 = SKLabelNode(fontNamed: "Lemondrop")
                text1.fontSize = 15
                text1.fontColor = UIColor.black
                text1.text = text1Text
                text1.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY+30);
                timePrison.dialogueLayer.addChild(text1)
                
                let text2 = SKLabelNode(fontNamed: "Lemondrop")
                text2.fontSize = 15
                text2.fontColor = UIColor.black
                text2.text = text2Text
                text2.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY+10);
                timePrison.dialogueLayer.addChild(text2)
                
                let text3 = SKLabelNode(fontNamed: "Lemondrop")
                text3.fontSize = 15
                text3.fontColor = UIColor.black
                text3.text = text3Text
                text3.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY-10);
                timePrison.dialogueLayer.addChild(text3)
                
                timePrison.noButton = SKLabelNode(fontNamed: "Lemondrop")
                timePrison.noButton.fontSize = 15
                timePrison.noButton.fontColor = UIColor.black
                timePrison.noButton.text = "Close"
                timePrison.noButton.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY-60);
                timePrison.dialogueLayer.addChild(timePrison.noButton)
            }
            else {
                let textBox = SKSpriteNode(texture: SKTexture(image: UIImage(named: "pink dialogue")!))
                textBox.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY)
                textBox.setScale(1.25)
                timePrison.dialogueLayer.addChild(textBox)
                
                let text1 = SKLabelNode(fontNamed: "Lemondrop")
                text1.fontSize = 15
                text1.fontColor = UIColor.black
                text1.text = "Spend 1 million phase crystals"
                text1.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY+10);
                timePrison.dialogueLayer.addChild(text1)
                
                let text2 = SKLabelNode(fontNamed: "Lemondrop")
                text2.fontSize = 15
                text2.fontColor = UIColor.black
                text2.text = "to free the Mold God?"
                text2.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY-10);
                timePrison.dialogueLayer.addChild(text2)
                
                timePrison.yesButton = SKLabelNode(fontNamed: "Lemondrop")
                timePrison.yesButton.fontSize = 15
                timePrison.yesButton.fontColor = UIColor.black
                timePrison.yesButton.text = "Yes"
                timePrison.yesButton.position = CGPoint(x:timePrison.frame.midX-60, y:timePrison.frame.midY-60);
                timePrison.dialogueLayer.addChild(timePrison.yesButton)
                
                timePrison.noButton = SKLabelNode(fontNamed: "Lemondrop")
                timePrison.noButton.fontSize = 15
                timePrison.noButton.fontColor = UIColor.black
                timePrison.noButton.text = "No"
                timePrison.noButton.position = CGPoint(x:timePrison.frame.midX+60, y:timePrison.frame.midY-60);
                timePrison.dialogueLayer.addChild(timePrison.noButton)
            }
        }
        if action == "meta" {
            if inventory.phaseCrystals < 1000000 {
                let textBox = SKSpriteNode(texture: SKTexture(image: UIImage(named: "pink dialogue")!))
                textBox.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY)
                textBox.setScale(1.25)
                timePrison.dialogueLayer.addChild(textBox)
                
                let text1 = SKLabelNode(fontNamed: "Lemondrop")
                text1.fontSize = 15
                text1.fontColor = UIColor.black
                text1.text = "You need 1 million phase crystals"
                text1.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY+10);
                timePrison.dialogueLayer.addChild(text1)
                
                let text2 = SKLabelNode(fontNamed: "Lemondrop")
                text2.fontSize = 15
                text2.fontColor = UIColor.black
                text2.text = "to free the Metaphase Mold"
                text2.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY-10);
                timePrison.dialogueLayer.addChild(text2)
                
                timePrison.noButton = SKLabelNode(fontNamed: "Lemondrop")
                timePrison.noButton.fontSize = 15
                timePrison.noButton.fontColor = UIColor.black
                timePrison.noButton.text = "Close"
                timePrison.noButton.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY-60);
                timePrison.dialogueLayer.addChild(timePrison.noButton)
            }
            else {
                let textBox = SKSpriteNode(texture: SKTexture(image: UIImage(named: "pink dialogue")!))
                textBox.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY)
                textBox.setScale(1.25)
                timePrison.dialogueLayer.addChild(textBox)
                
                let text1 = SKLabelNode(fontNamed: "Lemondrop")
                text1.fontSize = 15
                text1.fontColor = UIColor.black
                text1.text = "Spend 1 million phase crystals"
                text1.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY+10);
                timePrison.dialogueLayer.addChild(text1)
                
                let text2 = SKLabelNode(fontNamed: "Lemondrop")
                text2.fontSize = 15
                text2.fontColor = UIColor.black
                text2.text = "to free the Metaphase Mold?"
                text2.position = CGPoint(x:timePrison.frame.midX, y:timePrison.frame.midY-10);
                timePrison.dialogueLayer.addChild(text2)
                
                timePrison.yesButton = SKLabelNode(fontNamed: "Lemondrop")
                timePrison.yesButton.fontSize = 15
                timePrison.yesButton.fontColor = UIColor.black
                timePrison.yesButton.text = "Yes"
                timePrison.yesButton.position = CGPoint(x:timePrison.frame.midX-60, y:timePrison.frame.midY-60);
                timePrison.dialogueLayer.addChild(timePrison.yesButton)
                
                timePrison.noButton = SKLabelNode(fontNamed: "Lemondrop")
                timePrison.noButton.fontSize = 15
                timePrison.noButton.fontColor = UIColor.black
                timePrison.noButton.text = "No"
                timePrison.noButton.position = CGPoint(x:timePrison.frame.midX+60, y:timePrison.frame.midY-60);
                timePrison.dialogueLayer.addChild(timePrison.noButton)
            }
        }
        if action == "yes" {
            var moldData = Mold(moldType: MoldType.metaphase)
            if timePrison.metaNum == 8 {
                moldData = Mold(moldType: MoldType.god)
            }
            inventory.freedFromTimePrison[timePrison.metaNum] = true
            inventory.phaseCrystals -= 1000000
            timePrison.phaseCrystals = inventory.phaseCrystals
            timePrison.freedFromTimePrison = inventory.freedFromTimePrison
            if !inventory.unlockedMolds.contains(where: {$0.name == moldData.name}) {
                inventory.unlockedMolds.append(moldData)
            }
            inventory.molds.append(moldData)
            inventory.moldCountDicc[moldData.name]! += 1
            inventory.scorePerSecond += moldData.PPS
            if inventory.displayMolds.count < 25 {
                inventory.displayMolds.append(moldData)
            }
            timePrison.gameLayer.removeAllChildren()
            timePrison.dialogueLayer.removeAllChildren()
            timePrison.createButton()
            timePrison.playSound(select: "awe")
            timePrison.showNewBreed(breed: moldData.moldType)
        }
        if action == "no" {
            timePrison.dialogueLayer.removeAllChildren()
        }
    }
    
    //REINVEST HANDLER
    func reinvestHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            reinvestments.scrollView?.removeFromSuperview()
            reinvestments.cometLayer.removeAllChildren()
            reinvestments.cometLayer.cometTimer.invalidate()
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        if action == "reinvest" {
            reinvestments.confirmReinvest()
        }
        if action == "confirm reinvest" {
            reinvestments.gameLayer.removeAllChildren()
            
            let tempDiamonds = inventory.diamonds
            let tempdeath = inventory.deathRay
            let tempAuto = inventory.autoTap
            let tempAutoLev = inventory.autoTapLevel
            let tempTut = inventory.tutorialProgress
            let tempFB = inventory.likedFB
            let tempMuteM = inventory.muteMusic
            let tempMuteS = inventory.muteSound
            let tempReinvest = inventory.reinvestmentCount + 1
            var metaphaseCount = inventory.moldCountDicc["Metaphase Mold"] ?? 0
            var starCount = inventory.moldCountDicc["Star Mold"] ?? 0
            
            inventory = Inventory()
            inventory.diamonds += tempDiamonds
            inventory.deathRay = tempdeath
            inventory.autoTap = tempAuto
            inventory.autoTapLevel = tempAutoLev
            inventory.tutorialProgress = tempTut
            inventory.likedFB = tempFB
            inventory.muteSound = tempMuteS
            inventory.muteMusic = tempMuteM
            inventory.reinvestmentCount = tempReinvest
            if metaphaseCount > 0 {
                inventory.moldCountDicc["Metaphase Mold"] = metaphaseCount
                inventory.unlockedMolds.append(Mold(moldType: MoldType.metaphase))
                while metaphaseCount > 0 {
                    inventory.molds.append(Mold(moldType: MoldType.metaphase))
                    metaphaseCount -= 1
                }
            }
            if starCount > 0 {
                inventory.moldCountDicc["Star Mold"] = starCount
                inventory.unlockedMolds.append(Mold(moldType: MoldType.star))
                while starCount > 0 {
                    inventory.molds.append(Mold(moldType: MoldType.star))
                    starCount -= 1
                }
            }
            
            if inventory.reinvestmentCount >= 4 {
                print("the voice of god")
            }
            
            let disappear = SKAction.scale(to: 0, duration: 0.1)
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            reinvestments.scrollView?.removeFromSuperview()
            reinvestments.cometLayer.removeAllChildren()
            reinvestments.cometLayer.cometTimer.invalidate()
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            scene.wormDifficulty = 4 - inventory.laser + 1
            scene.updateMolds()
            scene.isActive = true
            scene.isPaused = false
            skView.presentScene(scene)
            scene.menuPopUp.run(action)
            
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
            updateLabels()
            shiftTimerLabels()
            generateQuest()
            scene.playSound(select: "reinvest")
            scene.reinvestCount = inventory.reinvestmentCount
            playBackgroundMusic(filename: "\(inventory.background).wav")
        }
    }
    //LEVEL SCENE HANDLER
    func levelHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            levelScene.scrollView?.removeFromSuperview()
            levelScene.cometLayer.removeAllChildren()
            levelScene.cometLayer.cometTimer.invalidate()
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        if action == "level" {
            if (inventory.cash > inventory.levelUpCost) && inventory.level < 75 {
                inventory.incrementLevel()
                // FBSDKAppEvents.logEvent("level up")
                updateLabels()
                levelScene.cash = inventory.cash
                levelScene.currentLevel = inventory.level
                levelScene.levelUpCostActual = inventory.levelUpCost
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
        if action == "offlinelevel" {
            if inventory.offlineLevel < 24 {
                if inventory.diamonds >= 2 {
                    inventory.offlineLevel += 1
                    levelScene.playSound(select: "ding")
                    levelScene.offlineLev = inventory.offlineLevel
                    levelScene.buttonLayer.removeAllChildren()
                    levelScene.createButton()
                    incrementDiamonds(newDiamonds: -2)
                }
                else {
                    levelScene.addBuyDiamondsButton()
                }
            }
            if inventory.offlineLevel >= 24 && inventory.offlineLevel < 48 {
                if inventory.diamonds >= 4 {
                    inventory.offlineLevel += 1
                    levelScene.playSound(select: "ding")
                    levelScene.offlineLev = inventory.offlineLevel
                    levelScene.buttonLayer.removeAllChildren()
                    levelScene.createButton()
                    incrementDiamonds(newDiamonds: -4)
                }
                else {
                    levelScene.addBuyDiamondsButton()
                }
            }
            
        }
        if action == "addDiamonds" {
            let disappear = SKAction.scale(to: 0, duration: 0.1)
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            levelScene.cometLayer.removeAllChildren()
            levelScene.cometLayer.cometTimer.invalidate()
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            if inventory.level < 3 {
                scene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                scene.wormDifficulty = 5 - inventory.laser
            }
            else {
                scene.wormDifficulty = 9 - inventory.laser
            }
            
            scene.updateMolds()
            scene.isActive = true
            skView.presentScene(scene)
            scene.menuPopUp.run(action)
            
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
            scene.doDiamondShop()
        }
        if backgrounds.contains(action) {
            inventory.background = action
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
        if action == "metaPlus" {
            type = MoldType.metaphase
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
                    
                    inventoryScene.metaLabel.text = String(count + 1)
                }
            }
        }
        if action == "metaMinus" {
            type = MoldType.metaphase
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
            inventoryScene.metaLabel.text = String(count)
        }
        if action == "godPlus" {
            type = MoldType.god
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
                    
                    inventoryScene.godLabel.text = String(count + 1)
                }
            }
        }
        if action == "godMinus" {
            type = MoldType.god
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
            inventoryScene.godLabel.text = String(count)
        }
        
        if (action == "exit") {
            exitInventory()
        }
    }
    
    
    // SHOP HANDLER
    func shopHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            
            moldShop.cometLayer.removeAllChildren()
            moldShop.cometLayer.cometTimer.invalidate()
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
            if inventory.tutorialProgress == 13 {
                moldShop.tutorialLayer.removeAllChildren()
                inventory.tutorialProgress = 14
            }
        }
        else {
            var mold: Mold!
            var pos: CGPoint!
            if (action == "slime") {
                mold = Mold(moldType: MoldType.slime)
                pos = moldShop.slimeButton.position
            }
            if (action == "cave") {
                mold = Mold(moldType: MoldType.cave)
                pos = moldShop.caveButton.position
            }
            if (action == "sad") {
                mold = Mold(moldType: MoldType.sad)
                pos = moldShop.sadButton.position
            }
            if (action == "angry") {
                mold = Mold(moldType: MoldType.angry)
                pos = moldShop.angryButton.position
            }
            if (action == "alien") {
                mold = Mold(moldType: MoldType.alien)
                pos = moldShop.angryButton.position
            }
            if (action == "freckled") {
                mold = Mold(moldType: MoldType.freckled)
                pos = moldShop.freckledButton.position
            }
            if (action == "hypno") {
                mold = Mold(moldType: MoldType.hypno)
                pos = moldShop.hypnoButton.position
            }
            if (action == "pimply") {
                mold = Mold(moldType: MoldType.pimply)
                pos = moldShop.pimplyButton.position
            }
            if (action == "rainbow") {
                mold = Mold(moldType: MoldType.rainbow)
                pos = moldShop.rainbowButton.position
            }
            if (action == "aluminum") {
                mold = Mold(moldType: MoldType.aluminum)
                pos = moldShop.aluminumButton.position
            }
            if (action == "circuit") {
                mold = Mold(moldType: MoldType.circuit)
                pos = moldShop.circuitButton.position
            }
            if (action == "hologram") {
                mold = Mold(moldType: MoldType.hologram)
                pos = moldShop.hologramButton.position
            }
            if (action == "storm") {
                mold = Mold(moldType: MoldType.storm)
                pos = moldShop.stormButton.position
            }
            if (action == "bacteria") {
                mold = Mold(moldType: MoldType.bacteria)
                pos = moldShop.bacteriaButton.position
            }
            if (action == "virus") {
                mold = Mold(moldType: MoldType.virus)
                pos = moldShop.virusButton.position
            }
            if (action == "flower") {
                mold = Mold(moldType: MoldType.flower)
                pos = moldShop.flowerButton.position
            }
            if (action == "bee") {
                mold = Mold(moldType: MoldType.bee)
                pos = moldShop.beeButton.position
            }
            if (action == "x") {
                mold = Mold(moldType: MoldType.x)
                pos = moldShop.xButton.position
            }
            if (action == "disaffected") {
                mold = Mold(moldType: MoldType.disaffected)
                pos = moldShop.disaffectedButton.position
            }
            if (action == "olive") {
                mold = Mold(moldType: MoldType.olive)
                pos = moldShop.oliveButton.position
            }
            if (action == "coconut") {
                mold = Mold(moldType: MoldType.coconut)
                pos = moldShop.coconutButton.position
            }
            if (action == "sick") {
                mold = Mold(moldType: MoldType.sick)
                pos = moldShop.sickButton.position
            }
            if (action == "dead") {
                mold = Mold(moldType: MoldType.dead)
                pos = moldShop.deadButton.position
            }
            if (action == "zombie") {
                mold = Mold(moldType: MoldType.zombie)
                pos = moldShop.zombieButton.position
            }
            if (action == "rock") {
                mold = Mold(moldType: MoldType.rock)
                pos = moldShop.rockButton.position
            }
            if (action == "cloud") {
                mold = Mold(moldType: MoldType.cloud)
                pos = moldShop.cloudButton.position
            }
            if (action == "water") {
                mold = Mold(moldType: MoldType.water)
                pos = moldShop.waterButton.position
            }
            if (action == "crystal") {
                mold = Mold(moldType: MoldType.crystal)
                pos = moldShop.crystalButton.position
            }
            if (action == "nuclear") {
                mold = Mold(moldType: MoldType.nuclear)
                pos = moldShop.nuclearButton.position
            }
            if (action == "astronaut") {
                mold = Mold(moldType: MoldType.astronaut)
                pos = moldShop.astronautButton.position
            }
            if (action == "sand") {
                mold = Mold(moldType: MoldType.sand)
                pos = moldShop.sandButton.position
            }
            if (action == "glass") {
                mold = Mold(moldType: MoldType.glass)
                pos = moldShop.glassButton.position
            }
            if (action == "coffee") {
                mold = Mold(moldType: MoldType.coffee)
                pos = moldShop.coffeeButton.position
            }
            if (action == "slinky") {
                mold = Mold(moldType: MoldType.slinky)
                pos = moldShop.slinkyButton.position
            }
            if (action == "magma") {
                mold = Mold(moldType: MoldType.magma)
                pos = moldShop.magmaButton.position
            }
            if (action == "samurai") {
                mold = Mold(moldType: MoldType.samurai)
                pos = moldShop.samuraiButton.position
            }
            if (action == "orange") {
                mold = Mold(moldType: MoldType.orange)
                pos = moldShop.orangeButton.position
            }
            if (action == "strawberry") {
                mold = Mold(moldType: MoldType.strawberry)
                pos = moldShop.strawberryButton.position
            }
            if (action == "tshirt") {
                mold = Mold(moldType: MoldType.tshirt)
                pos = moldShop.tshirtButton.position
            }
            if (action == "cryptid") {
                mold = Mold(moldType: MoldType.cryptid)
                pos = moldShop.cryptidButton.position
            }
            if (action == "angel") {
                mold = Mold(moldType: MoldType.angel)
                pos = moldShop.angelButton.position
            }
            if (action == "invisible") {
                mold = Mold(moldType: MoldType.invisible)
                pos = moldShop.invisibleButton.position
            }
            // get teh latest price from the database
            var currentPrice = BInt("0")
            for plsFind in moldShop.unlockedMolds {
                if plsFind.moldType == mold.moldType {
                    currentPrice = plsFind.price
                }
            }
            if (inventory.cash > currentPrice!) {
                inventory.cash -= currentPrice!
                inventory.molds.append(mold)
                inventory.moldCountDicc[mold.name]! += 1
                moldShop.prices[mold.name]! += mold.price / BInt(10)
                moldShop.updatePrice(mold: mold)
                // FBSDKAppEvents.logEvent("new mold")
                if inventory.displayMolds.count < 25 {
                    inventory.displayMolds.append(mold)
                }
                inventory.scorePerSecond += mold.PPS
                
                
                // check level to see how much more to add
                let hearts = inventory.levDicc[mold.name]!
                var levs = 0
                if hearts < 426 {
                    for num in moldLevCounts {
                        if hearts > num {
                            levs += 1
                        }
                    }
                }
                else {
                    levs = moldLevCounts.count
                    levs += ((hearts - 425) / 100)
                }
                
                inventory.scorePerSecond += levs*mold.PPS/5
                
                moldShop.playSound(select: "levelup")
                moldShop.animateName(name: mold.name)
                // incubator roll
                if  Int(arc4random_uniform(7)) < inventory.incubator {
                    inventory.molds.append(mold)
                    inventory.scorePerSecond += mold.PPS
                    moldShop.animateName(name: "+1")
                    
                }
                // log any achievements
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
                
                // calculate if a quest has been achieved
                if inventory.currentQuest.count > 1 {
                    if inventory.currentQuest.suffix(1) == "&" {
                        let name = inventory.currentQuest[..<inventory.currentQuest.index(before: inventory.currentQuest.endIndex)]
                        
                        if mold.name == name {
                            inventory.questAmount += 1
                        }
                        if inventory.questAmount == inventory.questGoal {
                            questAchieved()
                        }
                    }
                }
                
                // check if the limit is reached
                if inventory.moldCountDicc[mold.name] ?? 0 >= 50 {
                    moldShop.blockedMolds.insert(mold.moldType.description)
                    let maxLabel = SKSpriteNode(texture: moldShop.maxTex)
                    maxLabel.position = pos
                    moldShop.page1ScrollView.addChild(maxLabel)
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
        if action == "addDiamonds" {
            let disappear = SKAction.scale(to: 0, duration: 0.1)
            //this is the godo case
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            breedScene.cometLayer.removeAllChildren()
            breedScene.cometLayer.cometTimer.invalidate()
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            if inventory.level < 3 {
                scene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                scene.wormDifficulty = 5 - inventory.laser
            }
            else {
                scene.wormDifficulty = 9 - inventory.laser
            }
            
            scene.updateMolds()
            scene.isActive = true
            skView.presentScene(scene)
            scene.menuPopUp.run(action)
            
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
            scene.doDiamondShop()
        }
        if (action == "back") {
            breedScene.cometLayer.removeAllChildren()
            breedScene.cometLayer.cometTimer.invalidate()
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        if action == "diamonds" {
            //make sure the user has diamonds
            if inventory.diamonds >= breedScene.numDiamonds {
                if breedScene.currentDiamondCombo != nil {
                    if inventory.tutorialProgress == 18 {
                        breedScene.tutorialLayer.removeAllChildren()
                        inventory.tutorialProgress = 19
                        scene.tutorial = 19
                    }
                    let newCombo = breedScene.currentDiamondCombo
                    //ok, this breed hasnt been unlocked yet, time to unlock it!
                    inventory.unlockedMolds.append((newCombo?.child)!)
                    breedScene.unlockedMolds = inventory.unlockedMolds
                    
                    // FBSDKAppEvents.logEvent("new breed")
                    breedScene.playSound(select: "awe")
                    save()
                    breedScene.showNewBreed(breed: (newCombo?.child.moldType)!)
                    incrementDiamonds(newDiamonds: (-1 * breedScene.numDiamonds))
                    updateBreedAchievements()
                    //update possiblecombos
                    //populate the possible combos array
                    breedScene.possibleCombos = breedScene.possibleCombos.filter {$0.child.description != newCombo?.child.description}
                    breedScene.selectedMolds = []
                    breedScene.bubbleLayer.removeAllChildren()
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
                breedScene.addBuyDiamondsButton()
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
                                breedScene.playSound(select: "awe")
                                //    FBSDKAppEvents.logEvent("new breed")
                                save()
                                
                                print("tutorial progress")
                                print(inventory.tutorialProgress)
                                if inventory.tutorialProgress == -1 {
                                    breedScene.tutorialLayer.removeAllChildren()
                                    inventory.tutorialProgress = 19
                                    scene.tutorial = 19
                                }
                                
                                breedScene.showNewBreed(breed: combo.child.moldType)
                                //achievements
                                updateBreedAchievements()
                                //update possiblecombos
                                breedScene.possibleCombos = breedScene.possibleCombos.filter {$0.child.description != combo.child.description}
                                breedScene.selectedMolds = []
                                breedScene.bubbleLayer.removeAllChildren()
                                //    this is the code toe update tflnewA
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
                        //kill the molds
                        inventory.moldCountDicc[mold.name]! -= 1
                        var index = inventory.molds.firstIndex(where: {$0.name == mold.name})
                        inventory.molds.remove(at: index!)
                        inventory.scorePerSecond -= mold.PPS
                        index = inventory.displayMolds.firstIndex(where: {$0.name == mold.name})
                        if index != nil {
                            inventory.displayMolds.remove(at: index!)
                        }
                    }
                }
                breedScene.playSound(select: "buzzer")
                breedScene.animateName(point: breedScene.center, name: "BREED FAILED", new: 2)
                breedScene.bubbleLayer.removeAllChildren()
                breedScene.selectedMolds = []
                breedScene.ownedMolds = []
                breedScene.possibleCombos = []
                //populate the owned molds array
                var moldSet = Set<String>()
                for mold in inventory.molds {
                    if !moldSet.contains(mold.description) {
                        breedScene.ownedMolds.append(mold)
                        moldSet.insert(mold.description)
                    }
                }
                //populate the possible combos array
                if breedScene.ownedMolds.count > 0 {
                    for combo in combos.allCombos {
                        if inventory.unlockedMolds.contains(where: {$0.name == combo.child.name}) {
                            continue
                        }
                        var addCombo = true
                        for parent in combo.parents {
                            if !moldSet.contains(parent.description) {
                                addCombo = false
                                break
                            }
                        }
                        if addCombo {
                            breedScene.possibleCombos.append(combo)
                        }
                    }
                }
                if breedScene.possibleCombos.count > 0 {
                    breedScene.currentDiamondCombo = breedScene.possibleCombos[0]
                    breedScene.numDiamonds = breedScene.currentDiamondCombo.parents.count * 2
                }
                else {
                    breedScene.currentDiamondCombo = nil
                    breedScene.numDiamonds = 0
                }
                breedScene.diamondLabel.text = String(breedScene.numDiamonds)
                breedScene.reloadScroll()
            }
        }
        //tutorial handlers
        if action == "check tutorial progress" {
            if inventory.tutorialProgress == 19 {
                breedScene.finalTut()
                inventory.tutorialProgress = 20
            }
            else if inventory.tutorialProgress == 20 {
                inventory.tutorialProgress = 100
                breedScene.tutorialLayer.removeAllChildren()
                save()
            }
        }
    }
    
    //ITEM SHOP HANDLER
    func itemHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            itemShop.cometLayer.removeAllChildren()
            itemShop.cometLayer.cometTimer.invalidate()
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        if action == "addDiamonds" {
            let disappear = SKAction.scale(to: 0, duration: 0.1)
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            itemShop.cometLayer.removeAllChildren()
            itemShop.cometLayer.cometTimer.invalidate()
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            if inventory.level < 3 {
                scene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                scene.wormDifficulty = 5 - inventory.laser
            }
            else {
                scene.wormDifficulty = 9 - inventory.laser
            }
            scene.updateMolds()
            scene.isActive = true
            skView.presentScene(scene)
            scene.menuPopUp.run(action)
            
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
            scene.doDiamondShop()
        }
        if action == "repel" {
            if inventory.level < 3 {
                if inventory.cash > 1000 {
                    incrementCash(pointsToAdd: -1000)
                    inventory.repelTimer += 30
                    scene.wormRepel = true
                    itemShop.playSound(select: "levelup")
                    shiftTimerLabels()
                }
            }
                
            else if inventory.level < 29 {
                if inventory.cash > 12000 {
                    incrementCash(pointsToAdd: -12000)
                    scene.wormRepel = true
                    inventory.repelTimer += 30
                    
                    itemShop.playSound(select: "levelup")
                    shiftTimerLabels()
                }
            }
            else {
                if inventory.cash > 1800000 {
                    incrementCash(pointsToAdd: -1800000)
                    inventory.repelTimer += 30
                    scene.wormRepel = true
                    itemShop.playSound(select: "levelup")
                    shiftTimerLabels()
                }
            }
        }
        if (action == "premium") {
            itemShop.cometLayer.cometTimer.invalidate()
            itemShop.cometLayer.removeAllChildren()
            premiumShop = PremiumShop(size: skView.bounds.size)
            premiumShop.name = "premiumShop"
            premiumShop.scaleMode = .aspectFill
            premiumShop.touchHandler = premiumHandler
            if inventory.deathRay {
                premiumShop.deathRayBought = true
            }
            premiumShop.incubatorBought = inventory.incubator
            premiumShop.autoTapBought = inventory.autoTapLevel
            if aroff {
                skView.presentScene(premiumShop)
            }
            else {
                skView.presentScene(premiumShop)
            }
            
            premiumShop.mute = inventory.muteSound
            premiumShop.playSound(select: "select")
        }
        if action == "xTap" {
            if inventory.diamonds >= 10 {
                inventory.xTapAmount = 12
                inventory.xTapCount += 20
                scene.xTap = true
                incrementDiamonds(newDiamonds: -10)
                itemShop.playSound(select: "cash register")
                shiftTimerLabels()
            }
            else {
                itemShop.addBuyDiamondsButton()
            }
        }
        if action == "spritz" {
            if inventory.diamonds >= 12 {
                
                inventory.spritzAmount = 18
                inventory.spritzCount += 40
                
                incrementDiamonds(newDiamonds: -12)
                itemShop.playSound(select: "cash register")
                shiftTimerLabels()
                scene.animateSpritz()
            }
            else {
                itemShop.addBuyDiamondsButton()
            }
        }
        if action == "laser" {
            var cost = BInt("50000")
            switch inventory.laser {
            case 0:
                cost = BInt("50000")
                break
            case 1:
                cost = BInt("180000000")
                break
            case 2:
                cost = BInt("30000000000")
                break
            default:
                cost = BInt("30000000000")
                break
            }
            
            if inventory.cash >= cost! {
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
                incrementCash(pointsToAdd: (cost! * -1))
                
                var cost = BInt("50000")
                switch inventory.laser {
                case 0:
                    cost = BInt("50000")
                    break
                case 1:
                    cost = BInt("180000000")
                    break
                case 2:
                    cost = BInt("30000000000")
                    break
                default:
                    cost = BInt("30000000000")
                    break
                }
                itemShop.laserCostLabel.text = "Cost: \(formatNumber(points: cost!))"
                
                switch UIDevice().screenType {
                case .iPhone4:
                    //iPhone 5
                    itemShop.laserButton.setScale(0.9)
                    itemShop.laserLabel.setScale(0.85)
                    itemShop.laserCostLabel.setScale(0.85)
                    itemShop.laserButton.position = CGPoint(x:itemShop.frame.midX-90, y:itemShop.frame.midY-150)
                    itemShop.laserLabel.position = CGPoint(x:itemShop.frame.midX-85, y:itemShop.frame.midY-215)
                    itemShop.laserCostLabel.position = CGPoint(x:itemShop.frame.midX-85, y:itemShop.frame.midY-230)
                    break
                case .iPhone5:
                    //iPhone 5
                    itemShop.laserButton.setScale(0.9)
                    itemShop.laserLabel.setScale(0.85)
                    itemShop.laserCostLabel.setScale(0.85)
                    itemShop.laserButton.position = CGPoint(x:itemShop.frame.midX-90, y:itemShop.frame.midY-120)
                    itemShop.laserLabel.position = CGPoint(x:itemShop.frame.midX-85, y:itemShop.frame.midY-185)
                    itemShop.laserCostLabel.position = CGPoint(x:itemShop.frame.midX-85, y:itemShop.frame.midY-215)
                    break
                default:
                    break
                }
            }
        }
        if action == "smallwindfall" {
            if inventory.diamonds > 12 {
                itemShop.playSound(select: "cash register")
                incrementCash(pointsToAdd: inventory.scorePerSecond*BInt(50))
                incrementDiamonds(newDiamonds: -12)
            }
            else {
                itemShop.addBuyDiamondsButton()
            }
        }
    }
    
    //PREMIUM SHOP HANDLER
    func premiumHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            premiumShop.cometLayer.removeAllChildren()
            premiumShop.cometLayer.cometTimer.invalidate()
            itemShop.scaleMode = .aspectFill
            itemShop.touchHandler = itemHandler
            itemShop.laserBought = inventory.laser
            itemShop.level = inventory.level
            if aroff {
                skView.presentScene(itemShop)
            }
            else {
                skView.presentScene(itemShop)
            }
            itemShop.mute = inventory.muteSound
            itemShop.playSound(select: "exit")
        }
        if action == "addDiamonds" {
            let disappear = SKAction.scale(to: 0, duration: 0.1)
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            premiumShop.cometLayer.removeAllChildren()
            premiumShop.cometLayer.cometTimer.invalidate()
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            if inventory.level < 3 {
                scene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                scene.wormDifficulty = 5 - inventory.laser
            }
            else {
                scene.wormDifficulty = 9 - inventory.laser
            }
            
            scene.updateMolds()
            scene.isActive = true
            skView.presentScene(scene)
            scene.menuPopUp.run(action)
            
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
            scene.doDiamondShop()
        }
        if action == "windfall" {
            if inventory.diamonds >= 25 {
                incrementCash(pointsToAdd: inventory.scorePerSecond*BInt(200))
                incrementDiamonds(newDiamonds: -25)
                premiumShop.playSound(select: "cash register")
            }
            else {
                premiumShop.addBuyDiamondsButton()
            }
        }
        if action == "death ray" {
            if inventory.diamonds >= 500 {
                incrementDiamonds(newDiamonds: -500)
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
        }
        if action == "incubator" {
            if inventory.diamonds >= 6 {
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
                incrementDiamonds(newDiamonds: -6)
                
                switch UIDevice().screenType {
                case .iPhone4:
                    //iPhone 5
                    premiumShop.incubatorButton.setScale(0.9)
                    premiumShop.incLabel.setScale(0.75)
                    premiumShop.incubatorButton.position = CGPoint(x:premiumShop.frame.midX-85, y:premiumShop.frame.midY-133)
                    premiumShop.incLabel.position = CGPoint(x:premiumShop.frame.midX-85, y:premiumShop.frame.midY-195)
                    break
                case .iPhone5:
                    //iPhone 5
                    premiumShop.incubatorButton.setScale(0.9)
                    premiumShop.incLabel.setScale(0.75)
                    premiumShop.incubatorButton.position = CGPoint(x:premiumShop.frame.midX-85, y:premiumShop.frame.midY-103)
                    premiumShop.incLabel.position = CGPoint(x:premiumShop.frame.midX-85, y:premiumShop.frame.midY-165)
                    break
                default:
                    break
                }
            }
            else {
                premiumShop.addBuyDiamondsButton()
            }
        }
        if action == "auto-tap" {
            if inventory.autoTapLevel < 5 && inventory.diamonds >= 200 {
                incrementDiamonds(newDiamonds: -200)
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
                
                switch UIDevice().screenType {
                case .iPhone4:
                    //iPhone 5
                    premiumShop.autoTapButton.setScale(0.9)
                    premiumShop.autoTapButton.position = CGPoint(x:premiumShop.frame.midX+50, y:premiumShop.frame.midY)
                    break
                case .iPhone5:
                    //iPhone 5
                    premiumShop.autoTapButton.setScale(0.9)
                    premiumShop.autoTapButton.position = CGPoint(x:premiumShop.frame.midX+50, y:premiumShop.frame.midY+30)
                    break
                default:
                    break
                }
            }
        }
        if action == "star" {
            if inventory.diamonds >= 30 {
                incrementDiamonds(newDiamonds: -30)
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
        }
    }
    
    //Achievemnts HANDLER
    func achieveHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            achievements.cometLayer.removeAllChildren()
            achievements.cometLayer.cometTimer.invalidate()
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        if action == "claim" {
            if achievements.rewardAmount > 0 {
                achievements.playSound(select: "achieve")
                incrementDiamonds(newDiamonds: achievements.rewardAmount)
                
                let Texture = SKTexture(image: UIImage(named: "claim reward grey")!)
                achievements.claimButton = SKSpriteNode(texture:Texture)
                achievements.claimButton.position = CGPoint(x:achievements.frame.midX, y:achievements.frame.midY-200);
                achievements.addChild(achievements.claimButton)
                
                achievements.rewardAmount = 0
                inventory.achieveDiamonds = 0
                save()
            }
        }
    }
    
    //Credits HANDLER
    func creditsHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            creditsScene.cometLayer.removeAllChildren()
            creditsScene.cometLayer.cometTimer.invalidate()
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        if action == "review" {
            rateApp(appId: APP_ID) { success in
                print("RateApp \(success)")
            }
        }
        if action == "music" {
            if inventory.muteMusic {
                inventory.muteMusic = false
                creditsScene.removeMuteMusic()
                playBackgroundMusic(filename: "menu.wav")
            }
            else {
                inventory.muteMusic = true
                creditsScene.addMuteMusic()
                backgroundMusicPlayer.pause()
            }
        }
        if action == "sound" {
            if inventory.muteSound {
                inventory.muteSound = false
                creditsScene.removeMuteSound()
            }
            else {
                inventory.muteSound = true
                creditsScene.addMuteSound()
            }
        }
    }
    
    //Help HANDLER
    func helpHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            helpScene.scrollView?.removeFromSuperview()
            helpScene.cometLayer.removeAllChildren()
            helpScene.cometLayer.cometTimer.invalidate()
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
    }
    
    //Quest HANDLER
    func questHandler(action: String) {
        activateSleepTimer()
        if (action == "back") {
            questScene.cometLayer.removeAllChildren()
            questScene.cometLayer.cometTimer.invalidate()
            menu = MenuScene(size: skView.bounds.size)
            menu.scaleMode = .aspectFill
            menu.touchHandler = menuHandler
            menu.timePrisonEnabled = inventory.timePrisonEnabled
            
            if aroff {
                skView.presentScene(menu)
            }
            else {
                skView.presentScene(menu)
            }
            menu.mute = inventory.muteSound
            menu.playSound(select: "exit")
        }
        if action == "facebook" {
            inventory.likedFB = true
            inventory.questAmount = 1
            let url = URL(string: "https://www.facebook.com/MoldMarauder/")!
            UIApplication.shared.open(url)
            questAchieved()
        }
        if action == "skip quest" {
            if inventory.diamonds >= 3 {
                questScene.playSound(select: "select")
                incrementDiamonds(newDiamonds: -3)
                generateQuest()
                questScene.currentQuest = inventory.currentQuest
                questScene.questGoal = inventory.questGoal
                questScene.questAmount = inventory.questAmount
                questScene.labelLayer.removeAllChildren()
                questScene.barLayer.removeAllChildren()
                questScene.createButton()
            }
            else {
                questScene.addBuyDiamondsButton()
            }
        }
        if action == "claim quest" {
            scene.removeQuestButton()
            let reward = Int(arc4random_uniform(4))
            switch reward {
            case 0:
                //free cash
                let cashPrize = inventory.cash / BInt(randomInRange(lo: 90, hi: 125))
                incrementCash(pointsToAdd: cashPrize)
                questScene.animateCoins()
                questScene.animateName(name: "Free Cash")
                break
            case 1:
                //2 free diamonds
                incrementDiamonds(newDiamonds: 2)
                
                //animate dimmond
                let Texture = SKTexture(image: UIImage(named: "diamond_glow_double")!)
                let animDiamond = SKSpriteNode(texture:Texture)
                animDiamond.position = CGPoint(x: questScene.frame.midX, y: questScene.frame.midY)
                questScene.gameLayer.addChild(animDiamond)
                let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 1.2)
                moveAction.timingMode = .easeOut
                animDiamond.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                questScene.animateName(name: "Free Diamonds")
                break
            case 2:
                //20 seconds of tap bonus
                inventory.xTapAmount = 8
                inventory.xTapCount += 20
                scene.xTap = true
                questScene.animateCoins()
                shiftTimerLabels()
                questScene.animateName(name: "Tap Multiplier")
                break
            default:
                //30 seconds of sprtiz
                inventory.spritzAmount = 12
                inventory.spritzCount += 20
                shiftTimerLabels()
                scene.animateSpritz()
                questScene.animateName(name: "Free Spritz")
                break
            }
            questScene.playSound(select: "quest")
            generateQuest()
            questScene.currentQuest = inventory.currentQuest
            questScene.questGoal = inventory.questGoal
            questScene.questAmount = inventory.questAmount
            questScene.labelLayer.removeAllChildren()
            questScene.barLayer.removeAllChildren()
            questScene.createButton()
            save()
        }
        if action == "addDiamonds" {
            let disappear = SKAction.scale(to: 0, duration: 0.1)
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            questScene.cometLayer.removeAllChildren()
            questScene.cometLayer.cometTimer.invalidate()
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            if inventory.level < 3 {
                scene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                scene.wormDifficulty = 5 - inventory.laser
            }
            else {
                scene.wormDifficulty = 9 - inventory.laser
            }
            
            scene.updateMolds()
            scene.isActive = true
            skView.presentScene(scene)
            scene.menuPopUp.run(action)
            
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
            scene.doDiamondShop()
        }
    }
    
    //    ARSCENE TAP HANDLER
    func handleARTap(action: String) {
        if action == "diamond_buy" {
            ARgameScene.isPaused = true
            arskView.session.pause()
            arskView.isHidden = true
            arskView.isUserInteractionEnabled = false
            skView.isHidden = false
            skView.isUserInteractionEnabled = true
            scene.laserPower = inventory.laser
            scene.deathRay = inventory.deathRay
            scene.touchHandler = handleTap
            scene.menuPopUp.removeFromParent()
            
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            if inventory.level < 3 {
                scene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                scene.wormDifficulty = 5 - inventory.laser
            }
            else {
                scene.wormDifficulty = 9 - inventory.laser
            }
            
            scene.updateMolds()
            scene.isActive = true
            scene.isPaused = false
            skView.presentScene(scene)
            scene.mute = inventory.muteSound
            scene.playSound(select: "exit")
            activateSleepTimer()
            scene.doDiamondShop()
            scene.playSound(select: "select")
            aroff = true
        }
        if action == "addDiamond" {
            incrementDiamonds(newDiamonds: 1)
        }
        if action == "ar_scene_buy" {
            activateSleepTimer()
            ARgameScene.playSound(select: "select")
            //popup
            let Texture = SKTexture(image: UIImage(named: "cyber_menu_glow")!)
            ARgameScene.menuPopUp = SKSpriteNode(texture:Texture)
            // Place in scene
            ARgameScene.menuPopUp.position = CGPoint(x:ARgameScene.frame.midX, y:ARgameScene.frame.midY)
            ARgameScene.menuPopUp.size = arskView.bounds.size
            
            let appear = SKAction.scale(to: 1, duration: 0.2)
            ARgameScene.menuPopUp.setScale(0.01)
            let action = SKAction.sequence([appear])
            ARgameScene.menuPopUp.run(action)
            ARgameScene.addChild(ARgameScene.menuPopUp)
            autoTapTimer?.invalidate()
            autoTapTimer = nil
            
            let when = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.showMenu()
            }
        }
        if action == "ar_inventory" {
            ARgameScene.playSound(select: "select")
            //popup
            let Texture = SKTexture(image: UIImage(named: "cyber_menu_glow")!)
            ARgameScene.menuPopUp = SKSpriteNode(texture:Texture)
            // Place in scene
            ARgameScene.menuPopUp.position = CGPoint(x:ARgameScene.frame.midX, y:ARgameScene.frame.midY)
            ARgameScene.menuPopUp.size = arskView.bounds.size
            
            let appear = SKAction.scale(to: 1, duration: 0.2)
            ARgameScene.menuPopUp.setScale(0.01)
            let action = SKAction.sequence([appear])
            ARgameScene.menuPopUp.run(action)
            ARgameScene.addChild(ARgameScene.menuPopUp)
            autoTapTimer?.invalidate()
            autoTapTimer = nil
            
            ARgameScene.isPaused = true
            let when = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.showInventory()
            }
        }
        if action == "addDiamond" {
            activateSleepTimer()
            incrementDiamonds(newDiamonds: 1)
            ARgameScene.diamondCLabel.text = String(inventory.diamonds)
        }
        if action == "add2Diamond" {
            activateSleepTimer()
            incrementDiamonds(newDiamonds: 2)
            ARgameScene.diamondCLabel.text = String(inventory.diamonds)
        }
        if action == "wurmded" {
            inventory.wormsKilled += 1
            if inventory.currentQuest == "kill" {
                inventory.questAmount += 1
                if inventory.questAmount == inventory.questGoal {
                    questAchieved()
                }
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
            if inventory.tutorialProgress == 14 {
                scene.tutorialLayer.removeAllChildren()
                inventory.tutorialProgress = 15
                scene.killWormCongrats()
            }
        }
        if action == "level_mold" {
            let curType = ARgameScene.moldName
            inventory.levDicc[curType]! += 1
            // now check if we level, first do the within predefined dictionary case
            if inventory.levDicc[curType]! < 426 {
                for num in moldLevCounts {
                    if inventory.levDicc[curType]! == num {
                        // just hit a new level, time to amp up the cash
                        var additive = 0
                        var pps: BInt!
                        for xmold in inventory.molds {
                            if xmold.name == curType {
                                additive += 1
                            }
                        }
                        findp: for xmold in inventory.molds {
                            if xmold.name == curType {
                                pps = xmold.PPS
                                break findp
                            }
                        }
                        // increase PPS
                        inventory.scorePerSecond += additive*pps/5
                        
                        // show user
                        // Add a label for the score that slowly floats up.
                        let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
                        scoreLabel.fontSize = 18
                        scoreLabel.name = "naw"
                        scoreLabel.text = String(curType + " Level Up!")
                        scoreLabel.position = ARgameScene.center
                        scoreLabel.fontColor = UIColor.green
                        scoreLabel.zPosition = 300
                        
                        ARgameScene.addChild(scoreLabel)
                        
                        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
                        moveAction.timingMode = .easeOut
                        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                    }
                }
            }
                //  count how far after
            else {
                if (inventory.levDicc[curType]! - 425) % 100 == 0 {
                    var additive = 0
                    var pps: BInt!
                    for xmold in inventory.molds {
                        if xmold.name == curType {
                            additive += 1
                        }
                    }
                    findp: for xmold in inventory.molds {
                        if xmold.name == curType {
                            pps = xmold.PPS
                            break findp
                        }
                    }
                    // increase PPS
                    
                    inventory.scorePerSecond += additive*pps/5
                    // show user
                    // Add a label for the score that slowly floats up.
                    let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
                    scoreLabel.fontSize = 18
                    scoreLabel.name = "naw"
                    scoreLabel.fontColor = UIColor.green
                    scoreLabel.text = String(curType + " Level Up!")
                    scoreLabel.position = ARgameScene.center
                    scoreLabel.zPosition = 300
                    
                    ARgameScene.addChild(scoreLabel)
                    
                    let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
                    moveAction.timingMode = .easeOut
                    scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                }
            }
        }
        /*
         if action == "ar_camera" {
         //scene.eventTimer.invalidate()
         ARgameScene.cameraButton.removeFromParent()
         ARgameScene.inventoryButton.removeFromParent()
         ARgameScene.header.removeFromParent()
         ARgameScene.buyButton.removeFromParent()
         ARgameScene.diamondBuy.removeFromParent()
         //scene.gameLayer.removeAllChildren()
         ARgameScene.diamondIcon.removeFromParent()
         ARgameScene.diamondCLabel.removeFromParent()
         ARgameScene.wormRepelLabel.removeFromParent()
         ARgameScene.spritzLabel.removeFromParent()
         ARgameScene.xTapLabel.removeFromParent()
         cashLabel.isHidden = true
         cashHeader.isHidden = true
         //autoTapTimer?.invalidate()
         //autoTapTimer = nil
         _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(captureScreen), userInfo: nil, repeats: false)
         }
         */
    }
    
    //GAME SCENE HANDLER
    func handleTap(action: String) {
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        //this is the godo case
        let animation = SKAction.sequence([disappear, SKAction.removeFromParent()])
        if action == "level_mold" {
            let currType = scene.currType
            inventory.levDicc[currType]! += 1
            // now check if we level, first do the within predefined dictionary case
            if inventory.levDicc[currType]! < 426 {
                for num in moldLevCounts {
                    if inventory.levDicc[currType]! == num {
                        // just hit a new level, time to amp up the cash
                        var pps: BInt!
                        findp: for xmold in inventory.molds {
                            if xmold.name == currType {
                                pps = xmold.PPS
                                break findp
                            }
                        }
                        // increase PPS
                        inventory.scorePerSecond += inventory.moldCountDicc[currType]! * pps / 5
                        
                        // show user
                        // Add a label for the score that slowly floats up.
                        let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
                        scoreLabel.fontSize = 18
                        scoreLabel.text = String(currType + " Level Up!")
                        scoreLabel.position = scene.center
                        scoreLabel.fontColor = UIColor.green
                        scoreLabel.zPosition = 300
                        
                        scene.gameLayer.addChild(scoreLabel)
                        
                        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
                        moveAction.timingMode = .easeOut
                        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                    }
                }
            }
                //  count how far after
            else {
                if (inventory.levDicc[currType]! - 425) % 100 == 0 {
                    var pps: BInt!
                    findp: for xmold in inventory.molds {
                        if xmold.name == currType {
                            pps = xmold.PPS
                            break findp
                        }
                    }
                    // increase PPS
                    
                    inventory.scorePerSecond += inventory.moldCountDicc[currType]! * pps / 5
                    // show user
                    // Add a label for the score that slowly floats up.
                    let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
                    scoreLabel.fontSize = 18
                    scoreLabel.fontColor = UIColor.green
                    scoreLabel.text = String(currType + " Level Up!")
                    scoreLabel.position = scene.center
                    scoreLabel.zPosition = 300
                    
                    scene.gameLayer.addChild(scoreLabel)
                    
                    let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
                    moveAction.timingMode = .easeOut
                    scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                }
            }
        }
        if action == "succ_mold" {
            // trigger the blak hole mold death
            let pick = randomInRange(lo: 0, hi: inventory.molds.count - 1)
            if inventory.molds.count > 0 {
                if inventory.molds[pick].moldType != MoldType.star && inventory.molds[pick].moldType != MoldType.metaphase && inventory.molds[pick].moldType != MoldType.god {
                    let moldData = inventory.molds[pick]
                    let fade = SKAction.scale(to: 0.0, duration: 0.75)
                    let imName = String(moldData.name)
                    let Image = UIImage(named: imName)
                    let Texture = SKTexture(image: Image!)
                    let moldPic = SKSpriteNode(texture:Texture)
                    moldPic.position = scene.holeLayer.children[0].position
                    scene.holeLayer.addChild(moldPic)
                    moldPic.run(SKAction.sequence([fade, SKAction.removeFromParent()]))
                    scene.playSound(select: "mold succ")
                    
                    inventory.molds.remove(at: pick)
                    
                    var index = inventory.displayMolds.firstIndex(where: {$0.name == moldData.name})
                    if index != nil {
                        inventory.displayMolds.remove(at: index!)
                        scene.molds = inventory.displayMolds
                        index = scene.moldLayer.children.firstIndex(where: {$0.name == moldData.name})
                        scene.moldLayer.children[index!].removeFromParent()
                    }
                    
                    // check level to see how much more to remove
                    let hearts = inventory.levDicc[moldData.name]!
                    var levs = 0
                    if hearts < 426 {
                        for num in moldLevCounts {
                            if hearts > num {
                                levs += 1
                            }
                        }
                    }
                    else {
                        levs = moldLevCounts.count
                        levs += ((hearts - 425) / 100)
                    }
                    inventory.scorePerSecond -= moldData.PPS
                    inventory.scorePerSecond -= levs*moldData.PPS/5
                }
            }
        }
        if action == "reactivate timers" {
            print("tutorial ")
            print(inventory.tutorialProgress)
            //inventory.tutorialProgress = 0
            if inventory.tutorialProgress == 0 {
                scene.buyEnabled = false
                scene.beginTut()
            }
            if inventory.tutorialProgress > 16 || inventory.tutorialProgress < 0 {
                scene.reactivateTimer()
            }
        }
        if action == "tap ended" {
            autoTapTimer?.invalidate()
            autoTapTimer = nil
            if scene.isCircle {
                print("CIRCLE")
                findCircledView(scene.fitResult.center)
            }
            scene.touchedPoints = [CGPoint]()
        }
        if action == "tutorial next" {
            scene.tutorialLayer.removeAllChildren()
            scene.tapTut()
        }
        if action == "awake" {
            activateSleepTimer()
            scene.playSound(select: "select")
            print("wake up")
            scene.sleepLayer.removeAllChildren()
            scene.reactivateTimer()
            scene.isActive = true
            scene.isPaused = false
            cashTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.addCash), userInfo: nil, repeats: true)
        }
        if action == "claim quest" {
            if autoTapTimer != nil {
                autoTapTimer?.invalidate()
                autoTapTimer = nil
            }
            
            scene.removeQuestButton()
            questScene = QuestScene(size: skView.bounds.size)
            questScene.name = "questScene"
            questScene.scaleMode = .aspectFill
            questScene.touchHandler = questHandler
            questScene.currentQuest = inventory.currentQuest
            questScene.questGoal = inventory.questGoal
            questScene.questAmount = inventory.questAmount
            skView.presentScene(questScene)
            questScene.mute = inventory.muteSound
            questScene.playSound(select: "select")
        }
        if action == "touchOFF" {
            self.view.isUserInteractionEnabled = false
            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(enableTouch), userInfo: nil, repeats: true)
            autoTapTimer?.invalidate()
            autoTapTimer = nil
        }
        if action == "kiss baby" {
            let moldData = Mold(moldType: MoldType.random())
            inventory.molds.append(moldData)
            if inventory.displayMolds.count < 25 {
                inventory.displayMolds.append(moldData)
                scene.molds = inventory.displayMolds
                scene.updateMolds()
            }
            inventory.scorePerSecond += moldData.PPS
            // Add a label for the score that slowly floats up.
            let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
            scoreLabel.fontSize = 16
            scoreLabel.fontColor = UIColor.magenta
            scoreLabel.text = "New Baby! \(moldData.description)"
            scoreLabel.position = scene.center
            scoreLabel.zPosition = 300
            
            scene.gameLayer.addChild(scoreLabel)
            
            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
            moveAction.timingMode = .easeOut
            scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
        if action == "knockout" {
            var array = [SKNode]()
            for node in scene.moldLayer.children {
                if node is SKSpriteNode {
                    let dx = scene.kfPoint.x - node.position.x
                    let dy = scene.kfPoint.y - node.position.y

                    let distance = sqrt(dx*dx + dy*dy)
                    if (distance <= 50) {
                        array.append(node)
                        break
                    }
                }
            }
            
            var index = inventory.displayMolds.firstIndex(where: {$0.name == array[0].name})
            let moldData = inventory.displayMolds[index!]
            
            if moldData.moldType != MoldType.metaphase && moldData.moldType != MoldType.star && moldData.moldType != MoldType.god {
                if index != nil {
                    inventory.displayMolds.remove(at: index!)
                    index = inventory.molds.firstIndex(where: {$0.name == moldData.name})
                    inventory.molds.remove(at: index!)
                    scene.molds = inventory.displayMolds
                    index = scene.moldLayer.children.firstIndex(where: {$0.name == moldData.name})
                    scene.moldLayer.children[index!].removeFromParent()
                }
                
                // check level to see how much more to remove
                let hearts = inventory.levDicc[moldData.name]!
                var levs = 0
                if hearts < 426 {
                    for num in moldLevCounts {
                        if hearts > num {
                            levs += 1
                        }
                    }
                }
                else {
                    levs = moldLevCounts.count
                    levs += ((hearts - 425) / 100)
                }
                inventory.scorePerSecond -= moldData.PPS
                inventory.scorePerSecond -= levs*moldData.PPS/5
                        
                // Add a label for the score that slowly floats up.
                let scoreLabel = SKLabelNode(fontNamed: "Lemondrop")
                scoreLabel.fontSize = 16
                scoreLabel.fontColor = UIColor.red
                scoreLabel.text = "A death: \(moldData.description)"
                scoreLabel.position = scene.center
                scoreLabel.zPosition = 300
                
                scene.gameLayer.addChild(scoreLabel)
                
                let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 3)
                moveAction.timingMode = .easeOut
                scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
            }
        }
        if scene.diamondShop == false && action == "tap" {
            tapHelper()
            if inventory.autoTap {
                let intervals = [0.06, 0.03, 0.02, 0.013, 0.01]
                autoTapTimer = Timer.scheduledTimer(timeInterval: intervals[inventory.autoTapLevel-1], target: self, selector: #selector(tapHelper), userInfo: nil, repeats: true)
            }
            if inventory.tutorialProgress == 16 {
                scene.tutorialLayer.removeAllChildren()
                scene.reactivateTimer()
                inventory.tutorialProgress = 17
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
                    if inventory.diamonds >= 3 {
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
                    inventory.spritzAmount = 18
                    inventory.spritzCount += 120
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 2:
                    inventory.spritzAmount = 12
                    inventory.spritzCount += 180
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 3:
                    inventory.spritzAmount = 12
                    inventory.spritzCount += 60
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 4:
                    inventory.xTapAmount = 30
                    inventory.xTapCount += 20
                    scene.xTap = true
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 5:
                    inventory.xTapAmount = 50
                    inventory.xTapCount += 20
                    scene.xTap = true
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 6:
                    inventory.xTapAmount = 80
                    inventory.xTapCount += 20
                    scene.xTap = true
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 7:
                    inventory.xTapAmount = 120
                    inventory.xTapCount += 20
                    scene.xTap = true
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 8:
                    inventory.spritzAmount = 0
                    inventory.spritzCount += 60
                    scene.playSound(select: "bad card")
                    shiftTimerLabels()
                    break
                case 9:
                    inventory.spritzAmount = 0
                    inventory.spritzCount += 90
                    scene.playSound(select: "bad card")
                    shiftTimerLabels()
                    break
                case 10:
                    inventory.spritzAmount = 0
                    inventory.spritzCount += 120
                    scene.playSound(select: "bad card")
                    shiftTimerLabels()
                    break
                case 11:
                    if inventory.molds.count > 0 {
                        let indexToEat = randomInRange(lo: 0, hi: inventory.molds.count - 1)
                        if inventory.molds[indexToEat].moldType != MoldType.star && inventory.molds[indexToEat].moldType != MoldType.metaphase && inventory.molds[indexToEat].moldType != MoldType.god {
                            let moldData = inventory.molds[indexToEat]
                            scene.playSound(select: "crunch")
                            inventory.molds.remove(at: indexToEat)
                            
                            var index = inventory.displayMolds.firstIndex(where: {$0.name == moldData.name})
                            if index != nil {
                                inventory.displayMolds.remove(at: index!)
                                scene.molds = inventory.displayMolds
                                index = scene.moldLayer.children.firstIndex(where: {$0.name == moldData.name})
                                scene.moldLayer.children[index!].removeFromParent()
                            }
                            
                            // check level to see how much more to remove
                            let hearts = inventory.levDicc[moldData.name]!
                            var levs = 0
                            if hearts < 426 {
                                for num in moldLevCounts {
                                    if hearts > num {
                                        levs += 1
                                    }
                                }
                            }
                            else {
                                levs = moldLevCounts.count
                                levs += ((hearts - 425) / 100)
                            }
                            inventory.scorePerSecond -= moldData.PPS
                            inventory.scorePerSecond -= levs*moldData.PPS/5
                        }
                    }
                    scene.playSound(select: "bad card")
                    break
                case 12:
                    if inventory.molds.count > 3 {
                        var runCount = 0
                        while (runCount < 3) {
                            let indexToEat = randomInRange(lo: 0, hi: inventory.molds.count - 1)
                            if inventory.molds[indexToEat].moldType != MoldType.star && inventory.molds[indexToEat].moldType != MoldType.metaphase && inventory.molds[indexToEat].moldType != MoldType.god {
                                let moldData = inventory.molds[indexToEat]
                                scene.playSound(select: "crunch")
                                inventory.molds.remove(at: indexToEat)
                                
                                var index = inventory.displayMolds.firstIndex(where: {$0.name == moldData.name})
                                if index != nil {
                                    inventory.displayMolds.remove(at: index!)
                                    scene.molds = inventory.displayMolds
                                    index = scene.moldLayer.children.firstIndex(where: {$0.name == moldData.name})
                                    scene.moldLayer.children[index!].removeFromParent()
                                }
                                
                                // check level to see how much more to remove
                                let hearts = inventory.levDicc[moldData.name]!
                                var levs = 0
                                if hearts < 426 {
                                    for num in moldLevCounts {
                                        if hearts > num {
                                            levs += 1
                                        }
                                    }
                                }
                                else {
                                    levs = moldLevCounts.count
                                    levs += ((hearts - 425) / 100)
                                }
                                inventory.scorePerSecond -= moldData.PPS
                                inventory.scorePerSecond -= levs*moldData.PPS/5
                            }
                            runCount += 1
                        }
                    }
                    else {
                        inventory.molds = []
                        inventory.displayMolds = []
                        inventory.scorePerSecond = 0
                    }
                    scene.molds = inventory.displayMolds
                    scene.updateMolds()
                    scene.playSound(select: "bad card")
                    break
                case 13:
                    scene.playSound(select: "ding")
                    incrementDiamonds(newDiamonds: 5)
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
                    inventory.spritzAmount = 18
                    inventory.spritzCount += 240
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 2:
                    inventory.spritzAmount = 12
                    inventory.spritzCount += 360
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 3:
                    inventory.spritzAmount = 12
                    inventory.spritzCount += 120
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 4:
                    inventory.xTapAmount = 60
                    inventory.xTapCount += 20
                    scene.xTap = true
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 5:
                    inventory.xTapAmount = 100
                    inventory.xTapCount += 20
                    scene.xTap = true
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 6:
                    inventory.xTapAmount = 160
                    inventory.xTapCount += 20
                    scene.xTap = true
                    scene.playSound(select: "ding")
                    shiftTimerLabels()
                    break
                case 7:
                    inventory.xTapAmount = 240
                    inventory.xTapCount += 20
                    scene.xTap = true
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
                if inventory.molds[indexToEat].moldType != MoldType.star && inventory.molds[indexToEat].moldType != MoldType.metaphase && inventory.molds[indexToEat].moldType != MoldType.god {
                    let moldData = inventory.molds[indexToEat]
                    scene.playSound(select: "crunch")
                    inventory.molds.remove(at: indexToEat)
                    
                    var index = inventory.displayMolds.firstIndex(where: {$0.name == moldData.name})
                    if index != nil {
                        inventory.displayMolds.remove(at: index!)
                        scene.molds = inventory.displayMolds
                        index = scene.moldLayer.children.firstIndex(where: {$0.name == moldData.name})
                        scene.moldLayer.children[index!].removeFromParent()
                    }
                    
                    // check level to see how much more to remove
                    let hearts = inventory.levDicc[moldData.name]!
                    var levs = 0
                    if hearts < 426 {
                        for num in moldLevCounts {
                            if hearts > num {
                                levs += 1
                            }
                        }
                    }
                    else {
                        levs = moldLevCounts.count
                        levs += ((hearts - 425) / 100)
                    }
                    inventory.scorePerSecond -= moldData.PPS
                    inventory.scorePerSecond -= levs*moldData.PPS/5
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
                if inventory.questAmount == inventory.questGoal {
                    questAchieved()
                }
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
            if inventory.tutorialProgress == 14 {
                scene.tutorialLayer.removeAllChildren()
                inventory.tutorialProgress = 15
                scene.killWormCongrats()
            }
        }
        
        if action == "game_scene_buy" {
            if scene.buyEnabled {
                activateSleepTimer()
                scene.playSound(select: "select")
                
                //popup
                let Texture = SKTexture(image: UIImage(named: "cyber_menu_glow")!)
                scene.menuPopUp = SKSpriteNode(texture:Texture)
                // Place in scene
                scene.menuPopUp.position = CGPoint(x:scene.frame.midX, y:scene.frame.midY)
                scene.menuPopUp.size = skView.bounds.size
                
                let appear = SKAction.scale(to: 1, duration: 0.2)
                scene.menuPopUp.setScale(0.01)
                let action = SKAction.sequence([appear])
                scene.menuPopUp.run(action)
                scene.addChild(scene.menuPopUp)
                autoTapTimer?.invalidate()
                autoTapTimer = nil
                let when = DispatchTime.now() + 0.2
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.showMenu()
                }
            }
        }
        if action == "game_scene_inventory" {
            activateSleepTimer()
            scene.playSound(select: "select")
            
            //popup
            let Texture = SKTexture(image: UIImage(named: "cyber_menu_glow")!)
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
            autoTapTimer?.invalidate()
            autoTapTimer = nil
            let when = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.showInventory()
            }
        }
        if action == "game_scene_camera" {
            if scene.eventTimer != nil {
                scene.eventTimer.invalidate()
            }
            
            scene.cameraButton.removeFromParent()
            scene.inventoryButton.removeFromParent()
            scene.header.removeFromParent()
            scene.buyButton.removeFromParent()
            scene.diamondBuy.removeFromParent()
            scene.gameLayer.removeAllChildren()
            scene.diamondIcon.removeFromParent()
            scene.diamondCLabel.removeFromParent()
            scene.wormRepelLabel.removeFromParent()
            scene.spritzLabel.removeFromParent()
            scene.xTapLabel.removeFromParent()
            cashLabel.isHidden = true
            cashHeader.isHidden = true
            autoTapTimer?.invalidate()
            autoTapTimer = nil
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.captureScreen()
            }
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
            scene.isPaused = false
            scene.playSound(select: "exit")
        }
        if action == "diamond_tiny" {
            scene.playSound(select: "gem case")
            activateSleepTimer()
            if available {
                purchaseMyProduct(product: iapProducts[3])
            }
            else {
                let alert = UIAlertController(title: "Whoops!", message: "In-app purchases aren't available right now.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                present(alert, animated: true)
            }
        }
        if action == "diamond_small" {
            scene.playSound(select: "gem case")
            activateSleepTimer()
            if available {
                purchaseMyProduct(product: iapProducts[0])
            }
            else {
                let alert = UIAlertController(title: "Whoops!", message: "In-app purchases aren't available right now.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                present(alert, animated: true)
            }
        }
        if action == "diamond_medium" {
            scene.playSound(select: "gem case")
            activateSleepTimer()
            if available {
                purchaseMyProduct(product: iapProducts[2])
            }
            else {
                let alert = UIAlertController(title: "Whoops!", message: "In-app purchases aren't available right now.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                present(alert, animated: true)
            }
        }
        if action == "diamond_large" {
            scene.playSound(select: "chest")
            activateSleepTimer()
            if available {
                purchaseMyProduct(product: iapProducts[1])
            }
            else {
                let alert = UIAlertController(title: "Whoops!", message: "In-app purchases aren't available right now.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                present(alert, animated: true)
            }
        }
        if action == "increment tutorial worm congrats" {
            inventory.tutorialProgress = 16
            //scene.fairyTut()
        }
    }
    
    @objc func tapHelper() {
        activateSleepTimer()
        scene.tapPoint = inventory.scorePerTap
        
        if inventory.xTapCount > 0 {
            if inventory.reinvestmentCount >= 3 {
                let div = (inventory.scorePerTap * BInt(inventory.xTapAmount))
                incrementCash(pointsToAdd: div / 2)
            }
            else{
                incrementCash(pointsToAdd: (inventory.scorePerTap * BInt(inventory.xTapAmount)))
            }
            
        }
        else {
            scene.xTap = false
            if inventory.reinvestmentCount >= 3 {
                let div = inventory.scorePerTap
                incrementCash(pointsToAdd: div / 2)
            }
            else{
                incrementCash(pointsToAdd: inventory.scorePerTap)
            }
        }
        
        if scene.diamondShop == false {
            if inventory.xTapCount > 0 {
                if inventory.reinvestmentCount >= 3 {
                    scene.animateScore(point: scene.tapLoc, amount: (scene.tapPoint * BInt(inventory.xTapAmount))/2, tap: true, fairy: false, offline: false)
                }
                else{
                    scene.animateScore(point: scene.tapLoc, amount: scene.tapPoint * BInt(inventory.xTapAmount), tap: true, fairy: false, offline: false)
                }
                
            }
            else {
                if inventory.reinvestmentCount >= 3 {
                    scene.animateScore(point: scene.tapLoc, amount: scene.tapPoint/2, tap: true, fairy: false, offline: false)
                }
                else{
                    scene.animateScore(point: scene.tapLoc, amount: scene.tapPoint, tap: true, fairy: false, offline: false)
                }
                
            }
        }
        if inventory.currentQuest == "tap" {
            inventory.questAmount += 1
            if inventory.questAmount == inventory.questGoal {
                questAchieved()
            }
        }
        
    }
    
    //    MARK: - NOT HANDLERS BUT SIMILAIR
    func exitInventory() {
        inventoryScene.cometLayer.removeAllChildren()
        inventoryScene.cometLayer.cometTimer.invalidate()
        if aroff {
            scene.menuPopUp.size = skView.bounds.size
            let disappear = SKAction.scale(to: 0, duration: 0.2)
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            scene.moldLayer.removeAllChildren()
            scene.molds = inventory.displayMolds
            scene.updateMolds()
            scene.isActive = true
            scene.isPaused = false
            skView.presentScene(scene)
            scene.mute = inventory.muteSound
            scene.playSound(select: "exit")
            scene.menuPopUp.run(action)
        }
        else {
            
            // Configure the view.
            arskView.isHidden = false
            arskView.isUserInteractionEnabled = true
            skView.isHidden = true
            skView.isUserInteractionEnabled = false
            ARgameScene = ARScene(size: arskView.bounds.size)
            ARgameScene.scaleMode = .resizeFill
            
            ARgameScene.numDiamonds = inventory.diamonds
            ARgameScene.laserPower = scene.laserPower
            ARgameScene.deathRay = scene.deathRay
            
            
            
            ARgameScene.touchHandler = handleARTap
            ARgameScene.ARdisplayCount = inventory.displayMolds.count - 1
            if inventory.level < 3 {
                ARgameScene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                ARgameScene.wormDifficulty = 5 - inventory.laser
            }
            else {
                ARgameScene.wormDifficulty = 9 - inventory.laser
            }
            
            // Run the view's session
            arskView.session.run(configuration)
            
            // Set the scene to the view
            arskView.presentScene(ARgameScene)
            ARgameScene.createButton()
            if ARgameScene.menuPopUp != nil {
                let disappear = SKAction.scale(to: 0, duration: 0.1)
                //this is the godo case
                let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
                ARgameScene.menuPopUp.run(action)
            }
        }
    }
    
    func exitMenu() {
        menu.cometLayer.removeAllChildren()
        menu.cometLayer.cometTimer.invalidate()
        //    no ar load as usual
        if aroff {
            if menu.arSwitch {
                arskView.isHidden = true
                arskView.isUserInteractionEnabled = false
                skView.isHidden = false
                skView.isUserInteractionEnabled = true
                scene.laserPower = inventory.laser
                scene.deathRay = inventory.deathRay
                scene.touchHandler = handleTap
            }
            scene.menuPopUp.size = skView.bounds.size
            
            let disappear = SKAction.scale(to: 0, duration: 0.2)
            let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
            
            scene.molds = inventory.displayMolds
            incrementDiamonds(newDiamonds: 0)
            if inventory.level < 3 {
                scene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                scene.wormDifficulty = 5 - inventory.laser
            }
            else {
                scene.wormDifficulty = 9 - inventory.laser
            }
            
            
            scene.updateMolds()
            scene.isActive = true
            scene.isPaused = false
            skView.presentScene(scene)
            scene.mute = inventory.muteSound
            scene.playSound(select: "exit")
            if inventory.tutorialProgress == 14 {
                scene.wormTutorial()
            }
            if inventory.background != scene.backgroundName {
                scene.backgroundName = inventory.background
                scene.setBackground()
            }
            
            scene.menuPopUp.run(action)
        }
            //    there some ar afoot, lets dive in
        else {
            
            // Configure the view.
            arskView.isHidden = false
            arskView.isUserInteractionEnabled = true
            skView.isHidden = true
            skView.isUserInteractionEnabled = false
            ARgameScene = ARScene(size: arskView.bounds.size)
            ARgameScene.scaleMode = .resizeFill
            
            ARgameScene.numDiamonds = inventory.diamonds
            ARgameScene.laserPower = scene.laserPower
            ARgameScene.deathRay = scene.deathRay
            
            ARgameScene.touchHandler = handleARTap
            ARgameScene.ARdisplayCount = inventory.displayMolds.count - 1
            if inventory.level < 3 {
                ARgameScene.wormDifficulty = 4 - inventory.laser + 1
            }
                
            else if inventory.level < 29 {
                ARgameScene.wormDifficulty = 5 - inventory.laser
            }
            else {
                ARgameScene.wormDifficulty = 9 - inventory.laser
            }
            
            // Run the view's session
            arskView.session.run(configuration)
            
            // Set the scene to the view
            arskView.presentScene(ARgameScene)
            ARgameScene.createButton()
            if ARgameScene.menuPopUp != nil {
                let disappear = SKAction.scale(to: 0, duration: 0.1)
                let action = SKAction.sequence([disappear, SKAction.removeFromParent()])
                ARgameScene.menuPopUp.run(action)
            }
        }
        playBackgroundMusic(filename: "\(inventory.background).wav")
    }
    
    
    func findCircledView(_ center: CGPoint) {
        // walk through the fairies
        if scene.fairyLayer.children.count > 0 {
            for fairy in scene.fairyLayer.children {
                if fairy.contains(center) {
                    scene.playSound(select: "fairy")
                    let Texture = SKTexture(image: UIImage(named: "fairy circle")!)
                    let circle = SKSpriteNode(texture:Texture)
                    circle.position = CGPoint(x:center.x, y:center.y)
                    scene.fairyLayer.addChild(circle)
                    
                    let disappear = SKAction.scale(to: 0, duration: 0.2)
                    
                    fairy.run(SKAction.sequence([disappear, SKAction.removeFromParent()]))
                    circle.run(SKAction.sequence([SKAction.fadeOut(withDuration: (0.8)), SKAction.removeFromParent()]))
                    
                    let particle = SKTexture(image: UIImage(named: "glowing particle")!)
                    var counter = 0
                    while (counter < 15) {
                        let partNode = SKSpriteNode(texture: particle)
                        let size = Double.random0to1() * 0.3
                        partNode.setScale(CGFloat(size))
                        let ranX = randomInRange(lo: -30, hi: 30)
                        let ranY = randomInRange(lo: -30, hi: 30)
                        partNode.position = CGPoint(x: fairy.position.x, y: fairy.position.y)
                        scene.diamondLayer.addChild(partNode)
                        let moveAction = SKAction.move(by: CGVector(dx: ranX, dy: ranY), duration: 0.8)
                        
                        partNode.run(SKAction.sequence([moveAction, SKAction.fadeOut(withDuration: (0.15)), SKAction.removeFromParent()]))
                        counter += 1
                    }
                    let cashPrize = inventory.cash / BInt(randomInRange(lo: 25, hi: 90))
                    scene.animateScore(point: center, amount: cashPrize, tap: false, fairy: true, offline: false)
                    incrementCash(pointsToAdd: cashPrize)
                    if inventory.currentQuest == "faerie" {
                        inventory.questAmount += 1
                        if inventory.questAmount == inventory.questGoal {
                            questAchieved()
                        }
                    }
                }
            }
        }
    }
    
    
    
    @objc func captureScreen() {
        UIGraphicsBeginImageContextWithOptions(skView.bounds.size, true, 0)
        
        skView.drawHierarchy(in: skView.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
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
            self.shiftTimerLabels()
            if self.inventory.currentQuest == "screenshot" {
                self.inventory.questAmount += 1
                if self.inventory.questAmount == self.inventory.questGoal {
                    self.questAchieved()
                }
            }
        })
    }
    
    func showMenu() {
        
        if aroff {
            menu = MenuScene(size: skView.bounds.size)
        }
        else {
            menu = MenuScene(size: arskView.bounds.size)
        }
        
        menu.name = "menu"
        menu.scaleMode = .aspectFill
        menu.touchHandler = menuHandler
        menu.timePrisonEnabled = inventory.timePrisonEnabled
        if aroff {
            skView.presentScene(menu)
        }
        else {
            ARgameScene.isPaused = true
            arskView.session.pause()
            
            arskView.isHidden = true
            arskView.isUserInteractionEnabled = false
            skView.isHidden = false
            skView.isUserInteractionEnabled = true
            
            skView.presentScene(menu)
            let texSwitch = SKTexture(image: UIImage(named: "armodeon")!)
            menu.arButton.removeFromParent()
            menu.arButton = SKSpriteNode(texture: texSwitch)
            menu.arButton.position = CGPoint(x:menu.frame.midX-65, y:menu.frame.midY-100);
            menu.addChild(menu.arButton)
        }
        
        
        if scene.tutorial == 11 {
            scene.tutorialLayer.removeAllChildren()
            inventory.tutorialProgress = 12
            menu.buyMoldTut()
            scene.tutorial = -1
        }
        scene.isActive = false
        scene.isPaused = true
        playBackgroundMusic(filename: "menu.wav")
    }
    
    func showInventory() {
        if aroff {
            inventoryScene = MoldInventory(size: skView.bounds.size)
            inventoryScene.mute = inventory.muteSound
        }
        else {
            ARgameScene.isPaused = true
            arskView.session.pause()
            
            arskView.isHidden = true
            arskView.isUserInteractionEnabled = false
            skView.isHidden = false
            skView.isUserInteractionEnabled = true
            
            inventoryScene = MoldInventory(size: skView.bounds.size)
        }
        inventoryScene.name = "inventoryScene"
        inventoryScene.scaleMode = .aspectFill
        inventoryScene.touchHandler = inventorySceneHandler
        inventoryScene.unlockedMolds = inventory.unlockedMolds
        inventoryScene.ownedMolds = inventory.molds
        inventoryScene.totalNum = inventory.displayMolds.count
        inventoryScene.display = inventory.displayMolds
        if aroff {
            skView.presentScene(inventoryScene)
        }
        else {
            arskView.session.pause()
            skView.presentScene(inventoryScene)
        }
        scene.isActive = false
        scene.isPaused = true
    }
    
    @objc func enableTouch() {
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
            if inventory.questAmount == inventory.questGoal {
                questAchieved()
            }
        }
        
    }
    
    //per second function
    @objc func addCash() {
        let metaMult = 1 + inventory.moldCountDicc["Metaphase Mold"]!
        //hotpatch: delete extra worms
        if scene.wormLayer.children.count > 0 && scene.wormHP.count == 0 {  
            scene.wormKill()
        }
        //    this fixes a bug where your points per second goes negative
        if inventory.scorePerSecond < 0 {
            inventory.scorePerSecond = 0
        }
        //chance for two molds nex to each other kiss or fight
        if inventory.displayMolds.count > 1 && scene.isActive {
            if Int(arc4random_uniform(60)) < 4 {
                scene.kissOrFight()
            }
        }
        if arskView.isHidden {
            //adjust spritz counter
            if inventory.spritzCount > 0 {
                let div = inventory.scorePerSecond * inventory.spritzAmount * metaMult
                if inventory.reinvestmentCount >= 2 {
                    incrementCash(pointsToAdd: div / 2)
                }
                else{
                    incrementCash(pointsToAdd: div)
                }
                
                inventory.spritzCount -= 1
                scene.spritzLabel.text = String(inventory.spritzCount)
                if inventory.spritzCount == 0 {
                    scene.spritzLabel.text = ""
                    scene.playSound(select: "powerdown")
                    shiftTimerLabels()
                }
            }
                //no spritz just add normal cash
            else {
                let div = inventory.scorePerSecond * metaMult
                if inventory.reinvestmentCount >= 2 {
                    incrementCash(pointsToAdd: div / 2)
                }
                else{
                    incrementCash(pointsToAdd: div)
                }
                
                scene.spritzLabel.text = ""
            }
            //calculate animation
            if inventory.scorePerSecond > 0 {
                if scene.diamondShop == false && scene.isActive == true {
                    if inventory.spritzCount > 0 && inventory.spritzAmount > 0 {
                        if inventory.reinvestmentCount >= 2 {
                            scene.animateScore(point: scene.center, amount: (inventory.scorePerSecond*inventory.spritzAmount*metaMult)/2, tap: false, fairy: false, offline: false)
                        }
                        else {
                            scene.animateScore(point: scene.center, amount: (inventory.scorePerSecond*inventory.spritzAmount*metaMult), tap: false, fairy: false, offline: false)
                        }
                    }
                    else if inventory.spritzCount > 0 && inventory.spritzAmount == 0 {
                        
                    }
                    else {
                        if inventory.reinvestmentCount >= 2 {
                            scene.animateScore(point: scene.center, amount: inventory.scorePerSecond*metaMult/2, tap: false, fairy: false, offline: false)
                        }
                        else {
                            scene.animateScore(point: scene.center, amount: inventory.scorePerSecond*metaMult, tap: false, fairy: false, offline: false)
                        }
                        
                    }
                    
                }
            }
            //handle timers for worm repel and also bonus tap multipliers
            if scene.isActive {
                //worm repel timer
                if inventory.repelTimer > 0 {
                    inventory.repelTimer -= 1
                    scene.wormRepelLabel.text = String(inventory.repelTimer)
                    if inventory.repelTimer == 0 {
                        scene.wormRepelLabel.text = ""
                        scene.endRepelTimer()
                        scene.playSound(select: "powerdown")
                        shiftTimerLabels()
                    }
                }
                
                
                //xtap
                if inventory.xTapCount > 0 {
                    inventory.xTapCount -= 1
                    scene.xTapLabel.text = String(inventory.xTapCount)
                    if inventory.xTapCount == 0 {
                        scene.xTapLabel.text = ""
                        scene.playSound(select: "powerdown")
                        shiftTimerLabels()
                    }
                }
                
            }
        }
            // same thing for AR scene
        else {
            //adjust spritz counter
            if inventory.spritzCount > 0 {
                let div = inventory.scorePerSecond * inventory.spritzAmount * metaMult
                if inventory.reinvestmentCount >= 2 {
                    incrementCash(pointsToAdd: div / 2)
                }
                else{
                    incrementCash(pointsToAdd: div)
                }
                
                inventory.spritzCount -= 1
                ARgameScene.spritzLabel.text = String(inventory.spritzCount)
                if inventory.spritzCount == 0 {
                    ARgameScene.spritzLabel.text = ""
                    ARgameScene.playSound(select: "powerdown")
                    shiftTimerLabels()
                }
            }
                //no spritz just add normal cash
            else {
                let div = inventory.scorePerSecond * metaMult
                if inventory.reinvestmentCount >= 2 {
                    incrementCash(pointsToAdd: div / 2)
                }
                else{
                    incrementCash(pointsToAdd: div)
                }
                
                ARgameScene.spritzLabel.text = ""
            }
            //handle timers for worm repel and also bonus tap multipliers
            if ARgameScene.isPaused == false {
                //worm repel timer
                if inventory.repelTimer > 0 {
                    inventory.repelTimer -= 1
                    ARgameScene.wormRepelLabel.text = String(inventory.repelTimer)
                    if inventory.repelTimer == 0 {
                        ARgameScene.wormRepelLabel.text = ""
                        //ARgameScene.endRepelTimer()
                        ARgameScene.playSound(select: "powerdown")
                        shiftTimerLabels()
                    }
                }
                
                
                //xtap
                if inventory.xTapCount > 0 {
                    inventory.xTapCount -= 1
                    ARgameScene.xTapLabel.text = String(inventory.xTapCount)
                    if inventory.xTapCount == 0 {
                        ARgameScene.xTapLabel.text = ""
                        ARgameScene.playSound(select: "powerdown")
                        shiftTimerLabels()
                    }
                }
                
            }
        }
    }
    
    //since there can be up to three timers in the game scene at the same time this method will space them correctly
    func shiftTimerLabels() {
        //    perform shifting in the 2d scene
        if arskView.isHidden {
            if inventory.repelTimer == 0 {
                if inventory.xTapCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: scene.frame.midX+42,y: scene.xTapLabel.position.y), duration:0.45)
                    if inventory.spritzCount == 0 {
                        move = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                    }
                    scene.xTapLabel.run(move)
                    
                }
                if inventory.spritzCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: scene.frame.midX-42,y: scene.spritzLabel.position.y), duration:0.45)
                    if inventory.xTapCount == 0 {
                        move = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                    }
                    scene.spritzLabel.run(move)
                    
                }
                
            }
            else {
                if inventory.xTapCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: scene.frame.midX+74,y: scene.xTapLabel.position.y), duration:0.45)
                    if inventory.spritzCount == 0 {
                        move = SKAction.move(to: CGPoint(x: scene.frame.midX+42,y: scene.xTapLabel.position.y), duration:0.45)
                        let move2 = SKAction.move(to: CGPoint(x: scene.frame.midX-42,y: scene.xTapLabel.position.y), duration:0.45)
                        scene.wormRepelLabel.run(move2)
                        
                    }
                    else {
                        let move2 = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                        scene.wormRepelLabel.run(move2)
                        
                    }
                    scene.xTapLabel.run(move)
                    
                }
                
                if inventory.spritzCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: scene.frame.midX-74,y: scene.spritzLabel.position.y), duration:0.45)
                    if inventory.xTapCount == 0 {
                        move = SKAction.move(to: CGPoint(x: scene.frame.midX-42,y: scene.xTapLabel.position.y), duration:0.45)
                        let move2 = SKAction.move(to: CGPoint(x: scene.frame.midX+42,y: scene.xTapLabel.position.y), duration:0.45)
                        scene.wormRepelLabel.run(move2)
                        
                    }
                    else {
                        let move2 = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                        scene.wormRepelLabel.run(move2)
                        
                    }
                    scene.spritzLabel.run(move)
                    
                }
                if inventory.xTapCount == 0 && inventory.spritzCount == 0 {
                    let move = SKAction.move(to: CGPoint(x: scene.frame.midX,y: scene.xTapLabel.position.y), duration:0.45)
                    scene.wormRepelLabel.run(move)
                    
                }
            }
        }
            //   perform shifting in the ARScene
        else {
            if inventory.repelTimer == 0 {
                if inventory.xTapCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX+42,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                    if inventory.spritzCount == 0 {
                        move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                    }
                    ARgameScene.xTapLabel.run(move)
                    
                }
                if inventory.spritzCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX-42,y: ARgameScene.spritzLabel.position.y), duration:0.45)
                    if inventory.xTapCount == 0 {
                        move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                    }
                    ARgameScene.spritzLabel.run(move)
                    
                }
                
            }
            else {
                if inventory.xTapCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX+74,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                    if inventory.spritzCount == 0 {
                        move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX+42,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                        let move2 = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX-42,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                        ARgameScene.wormRepelLabel.run(move2)
                        
                    }
                    else {
                        let move2 = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                        ARgameScene.wormRepelLabel.run(move2)
                        
                    }
                    ARgameScene.xTapLabel.run(move)
                    
                }
                
                if inventory.spritzCount > 0 {
                    var move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX-74,y: ARgameScene.spritzLabel.position.y), duration:0.45)
                    if inventory.xTapCount == 0 {
                        move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX-42,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                        let move2 = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX+42,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                        ARgameScene.wormRepelLabel.run(move2)
                        
                    }
                    else {
                        let move2 = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                        ARgameScene.wormRepelLabel.run(move2)
                        
                    }
                    ARgameScene.spritzLabel.run(move)
                    
                }
                if inventory.xTapCount == 0 && inventory.spritzCount == 0 {
                    let move = SKAction.move(to: CGPoint(x: ARgameScene.frame.midX,y: ARgameScene.xTapLabel.position.y), duration:0.45)
                    ARgameScene.wormRepelLabel.run(move)
                    
                }
            }
        }
    }
    
    //formats the cash label with proper suffix to stay within 3 digits
    func updateLabels() {
        cashLabel.text = formatNumber(points: inventory.cash)
    }
    
    //add diamonds and update the scene lable
    func incrementDiamonds(newDiamonds: Int) {
        inventory.diamonds += newDiamonds
        scene.diamondCLabel.text = String(inventory.diamonds)
    }
    
    //tap for cash function
    func incrementCash(pointsToAdd: BInt) {
        inventory.cash += pointsToAdd
        if inventory.cash > BInt("10000000000000000000000000000000000")! {
            inventory.cash = BInt("10000000000000000000000000000000000")!
            if inventory.achievementsDicc["max cash"] == false {
                inventory.achievementsDicc["max cash"] = true
                inventory.achieveDiamonds += 25
            }
        }
        updateLabels()
    }
    
    // MARK: - AR STUFF
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        var skNode: SKNode!
        //    this will run if we're still droppign the molds in
        if ARgameScene.ARdisplayCount > 0 {
            let pick = ARgameScene.ARdisplayCount
            skNode = SKSpriteNode(imageNamed: inventory.displayMolds[pick!].name)
            skNode.name = inventory.displayMolds[pick!].name
            ARgameScene.moldCollection.append(skNode)
            let frames = ARgameScene.animateMold(moldData: inventory.displayMolds[pick!]).frames
            
            print(inventory.displayMolds[pick!].name)
            skNode.run(SKAction.repeatForever(
                SKAction.animate(with: frames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true)),
                       withKey:"moldAR")
            ARgameScene.ARdisplayCount! -= 1
        }
            // this will run if the molds are already placed
            // (basically everythign after teh first like 2 seconds
        else {
            print("making a non-mold sknode")
            // make worm shortcut
            if ARgameScene.wormHole {
                skNode = ARgameScene.wormAttack().wormPic
                skNode.name = String(ARgameScene.wormDifficulty - ARgameScene.laserPower)
                ARgameScene.wormCollection.append(skNode)
                
                let frames = ARgameScene.wormAttack().frames
                print("worm attack")
                ARgameScene.playSound(select: "worm appear")
                let timterval = Float.random(in: 2.1 ..< 3.6)
                ARgameScene.wormChompTimers.append(Timer.scheduledTimer(timeInterval: TimeInterval(timterval), target: self, selector: #selector(eatARMold), userInfo: nil, repeats: true))
                skNode.run(SKAction.animate(with: frames,
                                            timePerFrame: 0.1,
                                            resize: false,
                                            restore: true))
            }
            else {
                // create a black hole
                if randomInRange(lo: 1, hi: 9) == 2 {
                    skNode = BlackHole(size:CGSize(width:600, height:600))
                    skNode.name = "hole"
                    ARgameScene.holeCollection.append(skNode as! BlackHole)
                    if let hole = skNode as! BlackHole? {
                        hole.place()
                        ARgameScene.playSound(select: "black hole hi")
                        let when = DispatchTime.now() + 0.8
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.succMold(index: self.ARgameScene.holeCollection.count - 1)
                        }
                    }
                    
                }
                    // otherwise just add a worm
                else {
                    if inventory.repelTimer < 1 {
                        // if there is no worm repel then you can add a worm
                        skNode = ARgameScene.wormAttack().wormPic
                        skNode.name = String(ARgameScene.wormDifficulty - ARgameScene.laserPower)
                        ARgameScene.wormCollection.append(skNode)
                        
                        let frames = ARgameScene.wormAttack().frames
                        print("worm attack")
                        ARgameScene.playSound(select: "worm appear")
                        let timterval = Float.random(in: 2.1 ..< 3.6)
                        ARgameScene.wormChompTimers.append(Timer.scheduledTimer(timeInterval: TimeInterval(timterval), target: self, selector: #selector(eatARMold), userInfo: nil, repeats: true))
                        skNode.run(SKAction.animate(with: frames,
                                                    timePerFrame: 0.1,
                                                    resize: false,
                                                    restore: true))
                    }
                }
            }
            
        }
        ARgameScene.wormBottom = 4.0
        ARgameScene.wormTop = 8.0
        ARgameScene.wormHole = false
        return skNode
    }
    
    //    succ mold in AR
    func succMold(index: Int) {
        //    succ mold code
        let pick = randomInRange(lo: 0, hi: inventory.molds.count - 1)
        if inventory.molds[pick].moldType != MoldType.star {
            let moldData = inventory.molds[pick]
            let fade = SKAction.scale(to: 0.0, duration: 0.55)
            let imName = String(moldData.name)
            let Image = UIImage(named: imName)
            let Texture = SKTexture(image: Image!)
            let moldPic = SKSpriteNode(texture:Texture)
            moldPic.name = "naw"
            moldPic.position = ARgameScene.holeCollection[index].position
            ARgameScene.addChild(moldPic)
            moldPic.run(SKAction.sequence([fade, SKAction.removeFromParent()]))
            ARgameScene.playSound(select: "mold succ")
            
            var eatcount = 0
            displayLoop: for molds in inventory.displayMolds {
                if molds.moldType == inventory.molds[pick].moldType {
                    inventory.displayMolds.remove(at: eatcount)
                    break displayLoop
                }
                eatcount += 1
            }
            inventory.scorePerSecond -= inventory.molds[pick].PPS
            
            // check level to see how much more to remove
            let hearts = inventory.levDicc[inventory.molds[pick].name]!
            var levs = 0
            if hearts < 426 {
                for num in moldLevCounts {
                    if hearts > num {
                        levs += 1
                    }
                }
            }
            else {
                levs = moldLevCounts.count
                levs += ((hearts - 425) / 100)
            }
            
            inventory.scorePerSecond -= levs*inventory.molds[pick].PPS/5
            
            inventory.molds.remove(at: pick)
        }
        //    now either remove hole or call worms and 'ave another go
        if randomInRange(lo: 0, hi: 2) == 1 {
            var when = DispatchTime.now() + 1.35
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.ARgameScene.holeCollection[index].disappear()
                self.ARgameScene.playSound(select: "black hole bye")
                
                when = DispatchTime.now() + 0.55
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.ARgameScene.holeCollection[index].removeFromParent()
                }
            }
        }
        else {
            let when = DispatchTime.now() + 1.25
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.succMold(index: index)
            }
            
            var worms = randomInRange(lo: 0, hi: 3)
            while worms > 0 {
                print("add worm")
                ARgameScene.wormHole = true
                ARgameScene.wormBottom = 0.5
                ARgameScene.wormTop = 0.8
                //ARgameScene.createAnchor()
                worms -= 1
            }
            
        }
    }
    
    //eat mold
    @objc func eatARMold() {
        print("eat mold")
        //    first run the animation (as it is for some reason)
        var attackFrames = [SKTexture]()
        let side = randomInRange(lo: 0, hi: 1)
        if side == 0 {
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep left")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm strike left")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep left")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm left")!))
        }
        else {
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep right")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm strike right")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm prep right")!))
            attackFrames.append(SKTexture(image: UIImage(named: "worm right")!))
        }
        var pick = 0
        if ARgameScene.wormCollection.count > 1 {
            pick = randomInRange(lo: 0, hi: ARgameScene.wormCollection.count - 1)
        }
        ARgameScene.playSound(select: "crunch")
        if pick < ARgameScene.wormCollection.count {
            ARgameScene.wormCollection[pick].run(SKAction.animate(with: attackFrames,
                                                                  timePerFrame: 0.1,
                                                                  resize: false,
                                                                  restore: true))
        }
        
        //    pick a mold to eat
        if inventory.molds.count > 0 {
            pick = randomInRange(lo: 0, hi: inventory.molds.count-1)
            
            let hearts = inventory.levDicc[inventory.molds[pick].name]!
            var levs = 0
            if hearts < 426 {
                for num in moldLevCounts {
                    if hearts > num {
                        levs += 1
                    }
                }
            }
            else {
                levs = moldLevCounts.count
                levs += ((hearts - 425) / 100)
            }
            
            inventory.scorePerSecond -= levs*inventory.molds[pick].PPS/5
            inventory.scorePerSecond -= inventory.molds[pick].PPS
            
            var index = 0
            loop: for node in ARgameScene.moldCollection {
                if node.name == inventory.molds[pick].name {
                    node.removeFromParent()
                    ARgameScene.moldCollection.remove(at: index)
                    break loop
                }
                index += 1
            }
            
            inventory.molds.remove(at: pick)
        }
        
        
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        print("fetching products")
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            TINY_PRODUCT_ID,
            SMALL_PRODUCT_ID,
            MEDIUM_PRODUCT_ID,
            LARGE_PRODUCT_ID
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
            _ = numberFormatter.string(from: firstProduct.price)

            // 2nd IAP Product (Consumable) ------------------------------
            let secondProd = response.products[1] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = secondProd.priceLocale
            _ = numberFormatter.string(from: secondProd.price)
            // 3rd IAP Product (Consumable) ------------------------------
            
            let thirdProd = response.products[2] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = thirdProd.priceLocale
            _ = numberFormatter.string(from: thirdProd.price)
            // 4th IAP Product (Consumable) ------------------------------
            
            let fourthProd = response.products[3] as SKProduct
            
            // Get its price from iTunes Connect
            numberFormatter.locale = fourthProd.priceLocale
            _ = numberFormatter.string(from: fourthProd.price)
    
            //set the var
            available = true
        }
        else {
            available = false
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
            
            let alert = UIAlertController(title: "Uh-Oh!", message: "Purchases are disabled in your device!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                // perhaps use action.title here
            })
            present(alert, animated: true)
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
                        incrementDiamonds(newDiamonds: 11)
                        save()
                    }
                    else if productID == SMALL_PRODUCT_ID {
                        incrementDiamonds(newDiamonds: 55)
                        save()
                    }
                    else if productID == MEDIUM_PRODUCT_ID {
                        incrementDiamonds(newDiamonds: 200)
                        save()
                    }
                    else if productID == LARGE_PRODUCT_ID {
                        incrementDiamonds(newDiamonds: 1200)
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
    
    //MARK: - BACKGROUND MUSIC
    
    
    func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            if inventory.muteMusic == false {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
                backgroundMusicPlayer.numberOfLoops = -1
                backgroundMusicPlayer.prepareToPlay()
                backgroundMusicPlayer.play()
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    // MARK: - RATE APP
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: completion)
    }
}

// MARK: - DETECT DEVICE SIZE
//detect device and screen sizes to adjust UI elements as needed
public extension UIDevice {
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    var iPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    
    enum ScreenType: String {
        case iPad
        case iPhone4
        case iPhone5
        case iPhone8
        case iPhone8Plus
        case iPhoneX
        case Unknown
    }
    var screenType: ScreenType {
        if iPhone {
            print("iphone")
            switch UIScreen.main.nativeBounds.height {
            case 960:
                print("4")
                return .iPhone4
            case 1136:
                print("5, SE")
                return .iPhone5
            case 1334:
                print("6,7,8")
                return .iPhone8
            case 2208:
                print("6+,7+,8+")
                return .iPhone8Plus
            case 2436:
                print("X")
                return .iPhoneX
            default:
                return .Unknown
            }
        }
        else {
            print("uipad")
            return .iPad
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
