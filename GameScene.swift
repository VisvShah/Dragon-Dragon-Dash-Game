//
//  GameScene.swift
//  NND LandScape
//
//  Created by Visv Shah on 3/7/22.
//


import GameplayKit
import Foundation
import SpriteKit

var score = 0
let defaults = UserDefaults()
struct Upgrade{
    var name = "", upgradeValues:[Int] = [0], upgradeCosts:[Int] = [0]
}

var livesLevel = defaults.integer(forKey: "livesUpgrade")
var powerUpLevel = defaults.integer(forKey: "PUUpgrade")
var sWeaponsLevel = defaults.integer(forKey: "SWUpgrade")
var coinsUpgradeLevel = defaults.integer(forKey: "coinsUpgradeLevel")

let livesUpgrade = Upgrade(name : "lives", upgradeValues : [1, 2, 3, 4, 5 ,6 ,7, 8, 9, 10], upgradeCosts : [20, 500, 2000, 10000, 50000, 200000, 500000, 1500000, 5000000])
let sWeaponsUpgrade = Upgrade(name : "sWeapons", upgradeValues : [10,12,14,16,18,20,22,24,26,30], upgradeCosts : [10, 150, 1250, 8500, 25000, 100000, 300000, 1000000, 3000000])
let PUChanceUpgrade = Upgrade(name : "PUChance", upgradeValues : [0], upgradeCosts : [100, 5000, 100000, 2500000])
let coinsUpgrade = Upgrade(name : "coinsUpgrade", upgradeValues : [1,2,3,4,5], upgradeCosts : [1000, 50000, 2000000, 10000000])

let backgrounds = ["Background1","Background1","Background2","Background2","Background3","Background3","Background4","Background4","Background5","Background5",]
var endLevel = 0

class GameScene: SKScene, SKPhysicsContactDelegate{
    //Initializes key variables and constants
    var player = SKSpriteNode(imageNamed: "BlueFly0")
    
    let projectileSound = SKAction.playSoundFileNamed("fireball.wav", waitForCompletion: false)
    let impactSound = SKAction.playSoundFileNamed("Poof.wav", waitForCompletion: false)
    let powerUpSound = SKAction.playSoundFileNamed("powerUpSound.wav", waitForCompletion: false)
    let feverSound = SKAction.playSoundFileNamed("feverSound.wav", waitForCompletion: false)
    let speedBoostSound = SKAction.playSoundFileNamed("speedBoostLong.mp3", waitForCompletion: false)
    
    var playerAnimation:SKAction = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: 0.1)
    let playerJumpAnimation:SKAction = SKAction.animate(with: [SKTexture(imageNamed: "Ninja_Jump1"),SKTexture(imageNamed: "Ninja_Jump2"),SKTexture(imageNamed: "Ninja_Jump3"),SKTexture(imageNamed: "Ninja_Jump4"),SKTexture(imageNamed: "Ninja_Jump5"),SKTexture(imageNamed: "Ninja_Jump6"),SKTexture(imageNamed: "Ninja_Jump7")], timePerFrame: 0.1357)
    let coinAnimation:SKAction = SKAction.animate(with: [SKTexture(imageNamed: "coin1"),SKTexture(imageNamed: "coin2"),SKTexture(imageNamed: "coin3"),SKTexture(imageNamed: "coin4")], timePerFrame: 0.2)
    let faintAnimation:SKAction = SKAction.animate(with: [SKTexture(imageNamed: "playerDeath0"),SKTexture(imageNamed: "playerDeath1"),SKTexture(imageNamed: "playerDeath2"),SKTexture(imageNamed: "playerDeath3"),SKTexture(imageNamed: "playerDeath4"),SKTexture(imageNamed: "playerDeath5"), SKTexture(imageNamed: "playerDeath6"),SKTexture(imageNamed: "playerDeath7"),SKTexture(imageNamed: "playerDeath8"),SKTexture(imageNamed: "playerDeath9")], timePerFrame: 0.1)
    let playerBoostAnimation = SKAction.animate(with: [SKTexture(imageNamed: "PlayerF0"),SKTexture(imageNamed: "PlayerF1"),SKTexture(imageNamed: "PlayerF2"),SKTexture(imageNamed: "PlayerF3"),SKTexture(imageNamed: "PlayerF4"),SKTexture(imageNamed: "PlayerF5"),SKTexture(imageNamed: "PlayerF6"),SKTexture(imageNamed: "PlayerF7"),SKTexture(imageNamed: "PlayerF8"),SKTexture(imageNamed: "PlayerF9")], timePerFrame: 0.1)
    let playerAnimationSpeed = [0.1, 0.09, 0.083, 0.077, 0.072, 0.068, 0.065, 0.063, 0.061]
   
    public var randomYStart : Int = 0
    public var randomYEnd : Int = 0
    public var startP : CGPoint = CGPoint(x: 0, y: 0)
    public var endP : CGPoint = CGPoint(x: 0, y: 0)
    
    var scoreLabel = SKLabelNode(fontNamed: mainFont)
    let coinLabel2 = SKSpriteNode(imageNamed: "coinLabel")
    let lifeImage = SKSpriteNode(imageNamed: "lifeImage")
    var lives = livesUpgrade.upgradeValues[livesLevel]
    var livesLabel = SKLabelNode(fontNamed: mainFont)
    var weaponCount = sWeaponsUpgrade.upgradeValues[sWeaponsLevel]
    var weaponLabel = SKLabelNode(fontNamed: mainFont)
    var coinsLabel = SKLabelNode(fontNamed: mainFont)
    let tapToStart = SKLabelNode(fontNamed: mainFont)
    let rightDirections = SKLabelNode(fontNamed: mainFont)
    let leftDirections = SKLabelNode(fontNamed: mainFont)
    let middleLine = SKSpriteNode(imageNamed: "blackLine")
    
   
    
    var didPlayerSpawn = false
    var hasFever = false
    var hasSpeedBoost = false
    var isLabelActive = false
    
    var level = 0
    var earnedCoins = 0
    var powerUpType = 0
    var backgroundSpeed:CGFloat = 0.0
    var endBackgroundSpeed = 0.0
    var boostCounter = 0
    
    enum gameStage{
        case before //before game starts
        case during //during game
        case after //after game
    }
    var currentGameStage = gameStage.before
    
    //A structure that defines every physics node with a bit number so it can be referenced later.
    struct PhysicsCats{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Projectile : UInt32 = 0b10 //2
        static let Enemy: UInt32 = 0b100 //4
        static let AmmoBoost: UInt32 = 0b1000 //8
    }
    
    struct Enemy {
        var image = "", coinAmount = 1, scale:CGFloat = 1.0,speed:Double = 1.0,startPoint = CGPoint(),endPoint = CGPoint(),animation = SKAction()
    }
    var enemyTypes:[Enemy] = []
    
    
   
    override init(size: CGSize){
        super.init(size:size)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //The code that runs from the start
    override func didMove(to view: SKView) {
        if(highScore < 1){
            livesLevel = 0
            defaults.set(livesLevel, forKey: "livesUpgrade")
            powerUpLevel = 0
            defaults.set(powerUpLevel, forKey: "PUUpgrade")
            sWeaponsLevel = 0
            defaults.set(sWeaponsLevel, forKey: "SWUpgrade")
            coins = 0
            defaults.set(coins, forKey: "coinsValue")
            //print("reached if statement")
        }
        score = 0
        self.physicsWorld.contactDelegate = self
        
        //Sets up the background
        /*
        let background = SKSpriteNode(imageNamed: "Background1")
        background.size = self.size
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 0
        self.addChild(background)
        */
        self.anchorPoint = CGPoint(x: 0.5, y:  0.5)
        createEndlessB()
        
        //Defines the player node's properties and deploys the player
        //To fix hitboxes:
        //player.physicsBody = SKPhysicsBody(rectangleOf:player.size)
        player.setScale(0.7)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/4)
        player.position = CGPoint(x: -1400, y: -470)
        player.zPosition = 2
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCats.Player
        player.physicsBody!.collisionBitMask = PhysicsCats.None
        player.physicsBody!.contactTestBitMask = PhysicsCats.Enemy
        self.addChild(player)
        //player.run(SKAction.repeatForever(playerIdleAnimation),withKey: "changeAnimation")
        
        //Defeines the lives labels's properties and deplots the lives label
        livesLabel.text = "\(lives)"
        livesLabel.fontSize = 80
        livesLabel.fontColor = SKColor.black
        livesLabel.position = CGPoint(x:-820, y:800)
        livesLabel.zPosition = 10
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(livesLabel)
        
        
        
        lifeImage.setScale(1.2)
        lifeImage.zPosition = 10
        lifeImage.position = CGPoint(x:-885, y:800)
        self.addChild(lifeImage)
        
        
        //Defines the weapon label
        weaponLabel.text = "Fire Balls: \(weaponCount)"
        weaponLabel.fontSize = 50
        weaponLabel.fontColor = SKColor.black
        weaponLabel.position = CGPoint(x:900, y:730)
        weaponLabel.zPosition = 10
        weaponLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.addChild(weaponLabel)
        
        
        //Defines the score label's properties and deploys the score label
        scoreLabel.text = "0"
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x:0, y:750)
        //scoreLabel.position = CGPoint(x: self.size.width/2, y:self.size.height * 0.9)
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
        
        
        //defines the coins labels
        coinsLabel.text = "\(coins)"
        coinsLabel.fontSize = 50
        coinsLabel.fontColor = SKColor.black
        coinsLabel.position = CGPoint(x:915, y:800)
        coinsLabel.zPosition = 10
        coinsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.addChild(coinsLabel)
       
        
        coinLabel2.setScale(0.8)
        coinLabel2.position = CGPoint(x: 780, y: 775)
        coinLabel2.zPosition = 9
        self.addChild(coinLabel2)
        /*
        let coinImage = SKSpriteNode(imageNamed: "coin1")
        coinImage.setScale(1.2)
        coinImage.zPosition = 10
        coinImage.position = CGPoint(x:850, y:600)
        self.addChild(coinImage)
        */

        
        tapToStart.text = "Tap Anywhere to Start"
        tapToStart.fontSize = 170
        tapToStart.fontColor = SKColor.black
        tapToStart.position = CGPoint(x:0,y:0)
        tapToStart.zPosition = 10
        tapToStart.alpha = 0
        self.addChild(tapToStart)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStart.run(fadeInAction)
    }
    func startGame(){
        self.currentGameStage = gameStage.during
        player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
        
        let movePlayerIn = SKAction.moveTo(x:-900, duration: 0.7)
        let playerSpawned = SKAction.run {
            self.didPlayerSpawn = true
        }
        let playerStartSequence = SKAction.sequence([movePlayerIn,playerSpawned])
        player.run(playerStartSequence)
        
        let moveLivesTS = SKAction.moveTo(y: 500, duration: 0.3)
        livesLabel.run(moveLivesTS)
        
        let moveLifeImageTS = SKAction.moveTo(y: 520, duration: 0.3)
        lifeImage.run(moveLifeImageTS)
        
        let moveWeaponTS = SKAction.moveTo(y: 400, duration: 0.3)
        weaponLabel.run(moveWeaponTS)
        
        let moveScoreTS = SKAction.moveTo(y: 450, duration: 0.3)
        scoreLabel.run(moveScoreTS)
        
        let moveCoinsTS = SKAction.moveTo(y: 495, duration: 0.3)
        coinsLabel.run(moveCoinsTS)
        
        let moveCoinImageTS = SKAction.moveTo(y: 520, duration: 0.3)
        coinLabel2.run(moveCoinImageTS)
        
        tapToStart.run(SKAction.removeFromParent())
        if(fromGameStart){
            rightDirections.text = "Touch this side to shoot!"
            rightDirections.fontSize = 80
            rightDirections.fontColor = SKColor.black
            rightDirections.position = CGPoint(x:600, y:0)
            rightDirections.zPosition = 1
            self.addChild(rightDirections)
            
            leftDirections.text = "Slide on this side to move!"
            leftDirections.fontSize = 80
            leftDirections.fontColor = SKColor.black
            leftDirections.position = CGPoint(x:-600, y:0)
            leftDirections.zPosition = 1
            self.addChild(leftDirections)
            
            middleLine.setScale(1.4)
            middleLine.position = CGPoint(x:0,y:0)
            middleLine.zPosition = 1
            self.addChild(middleLine)
        }
        let waitInstructions = SKAction.wait(forDuration: 3)
        let deleteIntructions = SKAction.removeFromParent()
        let intructionsSequence = SKAction.sequence([waitInstructions,deleteIntructions])
        rightDirections.run(intructionsSequence)
        leftDirections.run(intructionsSequence)
        middleLine.run(intructionsSequence)
        
        
        
        let startPart2Break = SKAction.wait(forDuration: 0.7)
        let startPart2 = SKAction.run {
            self.startGamePart2()
        }
        let startPart2Sequence = SKAction.sequence([startPart2Break, startPart2])
        self.run(startPart2Sequence)
    }
    func startGamePart2(){
        newLevel()
        
        let scoreIncrease = SKAction.run(updateScore)
        let scoreWait = SKAction.wait(forDuration: 0.11 - (Double(powerUpLevel) * 0.02))
        let scoreSequence = SKAction.sequence([scoreWait,scoreIncrease])
        self.run(SKAction.repeatForever(scoreSequence), withKey:"scoreCount")
        
        let ammoBoostSpawn = SKAction.run(spawnBoost)
        let ammoWait = SKAction.wait(forDuration: 5)
        let ammoSequence = SKAction.sequence([ammoWait,ammoBoostSpawn])
        self.run(SKAction.repeatForever(ammoSequence), withKey:"ammoSequence")
    }
    //When run it will increase the score and display it on the score label. If the score is a certain amount it will also run the newLevel function (defined later on)
    func updateScore(){
        score += 1
        scoreLabel.text = "\(score)"
        
        if (score == 500 || score == 1000 || score == 1500 || score == 2000 || score == 3000 || score == 5000 || score == 7500 || score == 10000){
            newLevel()
        }
    }
    
    func updateWeaponCount(number: Int){
        weaponCount += number
        weaponLabel.text = "Fire Balls: \(weaponCount)"
    }
    //When run it decreases the lives displayes it on the lives label with a animation
    func updateLives(){
        if(!hasFever){
            lives -= 1
            livesLabel.text = "\(lives)"
        
            let livesShakeStart = SKAction.scale(to: 1.4, duration: 0.3)
            let livesShakeEnd = SKAction.scale(to: 1, duration: 0.3)
            
            livesLabel.run(SKAction.sequence([livesShakeStart, livesShakeEnd]))
            if(lives == 0){
                runGameOver()
            }
        }
    }
    
    func updateCoinCount(c : Int){
        coins += c
        defaults.set(coins, forKey: "coinsValue")
        coinsLabel.text = "\(coins)"
    }
    
    func spawnCoinLabel(spawnPosition: CGPoint, cCount : Int){
        var feverCoinMultiplier = 1
        if(hasFever){
            feverCoinMultiplier = 3
        }
        var coinCount = cCount
        coinCount *= feverCoinMultiplier
        coinCount *= coinsUpgrade.upgradeValues[coinsUpgradeLevel]
        let coinsL = SKSpriteNode(imageNamed: "coin1")
        coinsL.position = spawnPosition
        coinsL.zPosition = 2
        coinsL.setScale(1)
        self.addChild(coinsL)
        coinsL.run(SKAction.repeatForever(coinAnimation),withKey: "changeCoinAnimation")
        let coinMove = SKAction.move(to: CGPoint(x: coinLabel2.position.x - 100, y: coinLabel2.position.y), duration: 1)
        let updateCoins = SKAction.run {
            self.updateCoinCount(c: coinCount)
        }
        let deleteCoinL = SKAction.removeFromParent()
        let coinsSequence = SKAction.sequence([coinMove, updateCoins, deleteCoinL])
        coinsL.run(coinsSequence)
        
        let coinNumLabel = SKLabelNode(fontNamed: mainFont)
        coinNumLabel.text = "$\(coinCount)"
        coinNumLabel.fontSize = 100
        coinNumLabel.fontColor = UIColor.black
        coinNumLabel.position = CGPoint(x: spawnPosition.x + 50, y: spawnPosition.y + 50)
        coinNumLabel.zPosition = 3
        self.addChild(coinNumLabel)
        
        let coinWait = SKAction.wait(forDuration: 0.5)
        let coinDelete = SKAction.removeFromParent()
        let coinNumLabelSequence = SKAction.sequence([coinWait,coinDelete])
        coinNumLabel.run(coinNumLabelSequence)
    }
 
    //This function runs the explosion animation when it is called
    func explode(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion1")
        explosion.position = spawnPosition
        explosion.setScale(0.7)
        explosion.zPosition = 3
        self.addChild(explosion)
        let expAnimation: SKAction = SKAction.animate(with: [SKTexture(imageNamed: "explosion1"), SKTexture(imageNamed: "explosion2"), SKTexture(imageNamed: "explosion3"), SKTexture(imageNamed: "explosion4"), SKTexture(imageNamed: "explosion5")], timePerFrame: 0.06)
        let deleteExplosion = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([expAnimation,deleteExplosion])
        explosion.run(explosionSequence)
        
    }
    //This function will spawn a shuriken node and move it through the game scene when the function is called.
    func throwShiruken(endShirukenPath : CGPoint){
        let projectile = SKSpriteNode(imageNamed: "fireBall1")
        projectile.name = "projectile"
        projectile.setScale(0.7)
        projectile.position = player.position
        projectile.zPosition = 5
        projectile.physicsBody = SKPhysicsBody(rectangleOf:projectile.size)
        projectile.physicsBody!.affectedByGravity = false
        projectile.physicsBody!.categoryBitMask = PhysicsCats.Projectile
        projectile.physicsBody!.collisionBitMask = PhysicsCats.None
        projectile.physicsBody!.contactTestBitMask = PhysicsCats.Enemy
        let fireBallAnimation = SKAction.animate(with: [SKTexture(imageNamed: "fireBall1"),SKTexture(imageNamed: "fireBall2"),SKTexture(imageNamed: "fireBall3"),SKTexture(imageNamed: "fireBall4"),SKTexture(imageNamed: "fireBall5"),SKTexture(imageNamed: "fireBall6")], timePerFrame: 0.1)
        self.addChild(projectile)
        projectile.run(SKAction.repeatForever(fireBallAnimation),withKey: "fireBallAnimation")
        
        let dx = player.position.x - endShirukenPath.x
        let dy = player.position.y - endShirukenPath.y

        let endShirukenPathReal = CGPoint(x: endShirukenPath.x - dx, y: endShirukenPath.y - dy)
        let projectileMove = SKAction.move(to: endShirukenPathReal, duration: 1.2)
        //let projectileMove = SKAction.moveTo(x: (self.size.width + projectile.size.width), duration: 1.5)
        //let projectileSpin = SKAction.rotate(byAngle: 15, duration: 1.5)
        let deleteProjectile = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([projectileSound, projectileMove, deleteProjectile])
        projectile.run(actionSequence)
        
        let amountToRotate = atan2(dy,dx) + 3.14159
        projectile.zRotation = amountToRotate
        
        //projectile.run(projectileSpin)
    }
    func feverSystem(increaseCounter: Int){
        boostCounter += increaseCounter
        if (boostCounter == 5){
            let makeBoostRunning = SKAction.run {
                let feverRushLabel = SKLabelNode(fontNamed: mainFont)
                feverRushLabel.text = "FEVER RUSH!"
                feverRushLabel.fontSize = 170
                feverRushLabel.fontColor = SKColor.black
                feverRushLabel.zPosition = 10
                feverRushLabel.alpha = 0
                self.addChild(feverRushLabel)
                let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
                feverRushLabel.run(fadeInAction)
                let feverRushLabelWait = SKAction.wait(forDuration: 2)
                let feverRushLabelDelete = SKAction.removeFromParent()
                let feverRushLabelSequence = SKAction.sequence([feverRushLabelWait, feverRushLabelDelete])
                feverRushLabel.run(feverRushLabelSequence)
                let feverRushInfoLabel = SKLabelNode(fontNamed: mainFont)
                feverRushInfoLabel.text = "X3 COINS AND IMMMUNITY"
                feverRushInfoLabel.fontSize = 80
                feverRushInfoLabel.fontColor = SKColor.black
                
                feverRushInfoLabel.zPosition = 10
                feverRushInfoLabel.alpha = 0
                self.addChild(feverRushInfoLabel)
                
                if(self.isLabelActive){
                    feverRushLabel.position = CGPoint(x:0,y:300)
                    feverRushInfoLabel.position = CGPoint(x:0,y:200)
                }
                else{
                    self.isLabelActive = true
                    feverRushLabel.position = CGPoint(x:0,y:0)
                    feverRushInfoLabel.position = CGPoint(x:0,y:-100)
                }
                
                feverRushInfoLabel.run(fadeInAction)
                let feverRushInfoLabelWait = SKAction.wait(forDuration: 2)
                let feverRushInfoLabelDelete = SKAction.removeFromParent()
                let isLabelFalse = SKAction.run {
                    self.isLabelActive = false
                }
                let feverRushInfoLabelSequence = SKAction.sequence([feverRushInfoLabelWait, feverRushInfoLabelDelete, isLabelFalse])
                feverRushInfoLabel.run(feverRushInfoLabelSequence)
                
                //self.playerAnimation = self.playerBoostAnimation
                //self.player.run(SKAction.repeatForever(self.playerAnimation),withKey: "changeAnimation")
                //self.player.setScale(0.8)
                
                self.hasFever = true
                self.filter = CIFilter(name: "CIColorInvert")
                self.shouldEnableEffects = true
                self.run(self.feverSound)
                let scoreIncrease = SKAction.run(self.updateScore)
                let scoreIncreaseTimes = [0.06, 0.05, 0.04, 0.03, 0.02]
                let scoreWait = SKAction.wait(forDuration: scoreIncreaseTimes[powerUpLevel])
                let scoreSequence = SKAction.sequence([scoreWait,scoreIncrease])
                self.run(SKAction.repeatForever(scoreSequence), withKey:"scoreCount")
            }
            let waitBoost = SKAction.wait(forDuration: 5)
            let makeBoostStop = SKAction.run {
                self.hasFever = false
                self.shouldEnableEffects = false
                let scoreIncrease = SKAction.run(self.updateScore)
                let scoreWait = SKAction.wait(forDuration: 0.13 - (Double(powerUpLevel) * 0.02))
                let scoreSequence = SKAction.sequence([scoreWait,scoreIncrease])
                self.run(SKAction.repeatForever(scoreSequence), withKey:"scoreCount")
                self.boostCounter = 0
               // self.playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: self.playerAnimationSpeed[self.level - 1])
                //self.player.run(SKAction.repeatForever(self.playerAnimation),withKey: "changeAnimation")
                //self.player.setScale(0.7)
            }
            let boostSequence = SKAction.sequence([makeBoostRunning, waitBoost, makeBoostStop])
            self.run(boostSequence)
        }
        
    }
    func spawnBoost(){
        let boostType = Int.random(in:1...4)
        var willBoostSpawn = 0
        //print("Boost Data:")
        if(boostType == 1){
            willBoostSpawn = Int.random(in:1...(10 - livesLevel/2))
            //print("Lives Level: \(livesLevel)")
            //print("Lives Chances: \(7 - livesLevel)")
        }
        else if(boostType == 2 || boostType == 3){
            willBoostSpawn = Int.random(in:1...(5 - Int(sWeaponsLevel / 3)))
            //print("sWeapons Level: \(sWeaponsLevel)")
            //print("SWeapons Chances: \(3 - Int(sWeaponsLevel / 2))")
        }
        else if(boostType == 4){
            willBoostSpawn = Int.random(in:1...(10 - powerUpLevel))
            //print("Power Up Level: \(powerUpLevel)")
            //print("Power Up Chances: \(10 - (powerUpLevel * 2))")
        }
        //print("Boost Type is: \(boostType)")
        //print("Boost Spawn Chance: \(willBoostSpawn)")
        //print("")
        if(willBoostSpawn == 1){
            switch boostType{
            case 1:
                let ammoBoost = SKSpriteNode(imageNamed: "lifeImage")
                let ammoBoostStart = CGPoint(x: 1300, y: Int.random(in: -470...470))
                ammoBoost.name = "extraLife"
                powerUpType = 1
                ammoBoost.setScale(2)
                ammoBoost.position = ammoBoostStart
                ammoBoost.zPosition = 3
                ammoBoost.physicsBody = SKPhysicsBody(rectangleOf:ammoBoost.size)
                ammoBoost.physicsBody!.affectedByGravity = false
                ammoBoost.physicsBody!.categoryBitMask = PhysicsCats.AmmoBoost
                ammoBoost.physicsBody!.collisionBitMask = PhysicsCats.None
                ammoBoost.physicsBody!.contactTestBitMask = PhysicsCats.Player
                self.addChild(ammoBoost)
                let moveAmmoBoost = SKAction.move(to: CGPoint(x: -1300, y: ammoBoostStart.y), duration: 4)
                let removeAmmoBoost = SKAction.removeFromParent()
                let ammoBoostSpawnSequence = SKAction.sequence([moveAmmoBoost, removeAmmoBoost])
                ammoBoost.run(ammoBoostSpawnSequence)
            case 2,3:
                let ammoBoost = SKSpriteNode(imageNamed: "fireBall")
                let ammoBoostStart = CGPoint(x: 1300, y: Int.random(in: -470...470))
                ammoBoost.name = "ammoBoost"
                powerUpType = 2
                ammoBoost.setScale(1)
                ammoBoost.position = ammoBoostStart
                ammoBoost.zPosition = 3
                ammoBoost.physicsBody = SKPhysicsBody(rectangleOf:ammoBoost.size)
                ammoBoost.physicsBody!.affectedByGravity = false
                ammoBoost.physicsBody!.categoryBitMask = PhysicsCats.AmmoBoost
                ammoBoost.physicsBody!.collisionBitMask = PhysicsCats.None
                ammoBoost.physicsBody!.contactTestBitMask = PhysicsCats.Player
                self.addChild(ammoBoost)
                let moveAmmoBoost = SKAction.move(to: CGPoint(x: -1300, y: ammoBoostStart.y), duration: 4)
                let removeAmmoBoost = SKAction.removeFromParent()
                let ammoBoostSpawnSequence = SKAction.sequence([moveAmmoBoost, removeAmmoBoost])
                ammoBoost.run(ammoBoostSpawnSequence)
            case 4:
                let ammoBoost = SKSpriteNode(imageNamed: "powerUp")
                let ammoBoostStart = CGPoint(x: 1300, y: Int.random(in: -470...470))
                ammoBoost.name = "speedBoost"
                powerUpType = 3
                ammoBoost.setScale(2)
                ammoBoost.position = ammoBoostStart
                ammoBoost.zPosition = 3
                ammoBoost.physicsBody = SKPhysicsBody(rectangleOf:ammoBoost.size)
                ammoBoost.physicsBody!.affectedByGravity = false
                ammoBoost.physicsBody!.categoryBitMask = PhysicsCats.AmmoBoost
                ammoBoost.physicsBody!.collisionBitMask = PhysicsCats.None
                ammoBoost.physicsBody!.contactTestBitMask = PhysicsCats.Player
                self.addChild(ammoBoost)
                let moveAmmoBoost = SKAction.move(to: CGPoint(x: -1300, y: ammoBoostStart.y), duration: 4)
                let removeAmmoBoost = SKAction.removeFromParent()
                let ammoBoostSpawnSequence = SKAction.sequence([moveAmmoBoost, removeAmmoBoost])
                ammoBoost.run(ammoBoostSpawnSequence)
            default:
                print("Error")
            }
            
        }
    }
    func speedBoost(){
            let makeBoostRunning = SKAction.run {
                self.hasSpeedBoost = true
                let scoreIncrease = SKAction.run(self.updateScore)
                let scoreWait = SKAction.wait(forDuration: 0.02)
                let scoreSequence = SKAction.sequence([scoreWait,scoreIncrease])
                self.run(SKAction.repeatForever(scoreSequence), withKey:"scoreCount")
            }
            let waitBoost = SKAction.wait(forDuration: 9)
            let makeBoostStop = SKAction.run {
                self.hasSpeedBoost = false
                let scoreIncrease = SKAction.run(self.updateScore)
                let scoreWait = SKAction.wait(forDuration: 0.11 - (Double(powerUpLevel) * 0.02))
                let scoreSequence = SKAction.sequence([scoreWait,scoreIncrease])
                self.run(SKAction.repeatForever(scoreSequence), withKey:"scoreCount")
                
            }
            let boostSequence = SKAction.sequence([makeBoostRunning, waitBoost, makeBoostStop])
            self.run(boostSequence)
    }
    
    
  //This function spawns the enemies at a random x point from the top of the screen every few seconds and sets the enemy node's properties. The time between spawns is determined by the level the player is on from the newLevel function(defined later on).
    func spawnEnemy(){
         randomYStart = Int.random(in: -570...500)
         randomYEnd = Int.random(in: -470...400)
         //randomYStart = -100
         //randomYEnd = -200
         startP = CGPoint(x: 1300, y: randomYStart)
         
         let randomEnemy = Int.random(in: 0...enemyTypes.count-1)
         let enemy = SKSpriteNode(imageNamed: enemyTypes[randomEnemy].image)
        
         enemy.name = "enemy"
         enemy.setScale(enemyTypes[randomEnemy].scale)
         enemy.position = startP
         enemy.zPosition = 5
         enemy.physicsBody = SKPhysicsBody(rectangleOf:enemy.size)
         enemy.physicsBody!.affectedByGravity = false
         enemy.physicsBody!.categoryBitMask = PhysicsCats.Enemy
         enemy.physicsBody!.collisionBitMask = PhysicsCats.None
         enemy.physicsBody!.contactTestBitMask = PhysicsCats.Player | PhysicsCats.Projectile
         
        let moveEnemy = SKAction.move(to: CGPoint(x: -1400, y: randomYEnd), duration: enemyTypes[randomEnemy].speed)
         let deleteEnemy = SKAction.removeFromParent()
        let setBoostCounter = SKAction.run {
            self.boostCounter = 0
        }
        //efficient way to run the updateLives method if the missle passes the player
         //let loseLife = SKAction.run(updateLives)
         //let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy,loseLife])
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, setBoostCounter])
        if(currentGameStage == gameStage.during){
            self.addChild(enemy)
            enemy.run(SKAction.repeat(enemyTypes[randomEnemy].animation, count: 10))
            enemy.run(enemySequence)
            
            //Angles the missle towards the player
            
            //let dx = enemyTypes[randomEnemy].endPoint.x - startP.x
            let dy = enemyTypes[randomEnemy].endPoint.y - startP.y
            let amountToRotate = acos(dy)
            enemy.zRotation = amountToRotate
            earnedCoins = enemyTypes[randomEnemy].coinAmount
        }
        
     }
    //This is the newLevel function mentioned above. When it is run, it increases the level and decreases the time between each enemy spawn
    func newLevel(){
        level += 1
        if(level != 1){
            let newLevelLabel = SKLabelNode(fontNamed: mainFont)
            newLevelLabel.text = "NEW LEVEL!"
            newLevelLabel.fontSize = 100
            newLevelLabel.fontColor = SKColor.black
            if(isLabelActive){
                newLevelLabel.position = CGPoint(x:0, y:150)
            }
            else{
                isLabelActive = true
                newLevelLabel.position = CGPoint(x:0, y:0)
            }
            
            newLevelLabel.zPosition = 1
            self.addChild(newLevelLabel)
            let waitInstructions = SKAction.wait(forDuration: 3)
            let deleteIntructions = SKAction.removeFromParent()
            let isLabelFalse = SKAction.run {
                self.isLabelActive = false
            }
            let intructionsSequence = SKAction.sequence([waitInstructions,deleteIntructions,isLabelFalse])
            newLevelLabel.run(intructionsSequence)
        }
        if self.action(forKey: "spawnEnemies") != nil{
            self.removeAction(forKey: "spawnEnemies")
        }
        let brownBird = Enemy(image: "Brown1", coinAmount : 1, scale: 0.7, speed: 1.6, startPoint: startP,endPoint: CGPoint(x:-1000, y: randomYEnd), animation: SKAction.animate(with: [SKTexture(imageNamed: "Brown1"),SKTexture(imageNamed: "Brown2"),SKTexture(imageNamed: "Brown3"),SKTexture(imageNamed: "Brown4"),SKTexture(imageNamed: "Brown5"),SKTexture(imageNamed: "Brown6"),SKTexture(imageNamed: "Brown7"),SKTexture(imageNamed: "Brown8"),SKTexture(imageNamed: "Brown9"),SKTexture(imageNamed: "Brown10")], timePerFrame: 0.1))
        let greenBird = Enemy(image: "Green1", coinAmount : 5,scale: 0.7, speed: 1.5, startPoint: startP,endPoint: CGPoint(x:-1000, y: randomYEnd), animation: SKAction.animate(with: [SKTexture(imageNamed: "Green1"),SKTexture(imageNamed: "Green2"),SKTexture(imageNamed: "Green3"),SKTexture(imageNamed: "Green4"),SKTexture(imageNamed: "Green5"),SKTexture(imageNamed: "Green6"),SKTexture(imageNamed: "Green7"),SKTexture(imageNamed: "Green8"),SKTexture(imageNamed: "Green9"),SKTexture(imageNamed: "Green10")], timePerFrame: 0.1))
        let pumpBird = Enemy(image: "Pump1", coinAmount :30,scale: 0.8, speed: 1.3, startPoint: startP,endPoint: CGPoint(x:-1000, y: randomYEnd), animation: SKAction.animate(with: [SKTexture(imageNamed: "Pump1"),SKTexture(imageNamed: "Pump2"),SKTexture(imageNamed: "Pump3"),SKTexture(imageNamed: "Pump4"),SKTexture(imageNamed: "Pump5"),SKTexture(imageNamed: "Pump6"),SKTexture(imageNamed: "Pump7"),SKTexture(imageNamed: "Pump8"),SKTexture(imageNamed: "Pump9"),SKTexture(imageNamed: "Pump10")], timePerFrame: 0.1))
        let blueBird = Enemy(image: "Blue1", coinAmount : 150,scale: 0.7, speed: 1.2, startPoint: startP,endPoint: CGPoint(x:-1000, y: randomYEnd), animation: SKAction.animate(with: [SKTexture(imageNamed: "Blue1"),SKTexture(imageNamed: "Blue2"),SKTexture(imageNamed: "Blue3"),SKTexture(imageNamed: "Blue4"),SKTexture(imageNamed: "Blue5"),SKTexture(imageNamed: "Blue6"),SKTexture(imageNamed: "Blue7"),SKTexture(imageNamed: "Blue8"),SKTexture(imageNamed: "Blue9"),SKTexture(imageNamed: "Blue10")], timePerFrame: 0.1))
        let brownFlameBird = Enemy(image: "BrownF0", coinAmount : 750,scale: 0.7, speed: 1.1, startPoint: startP,endPoint: CGPoint(x:-1000, y: randomYEnd), animation: SKAction.animate(with: [SKTexture(imageNamed: "BrownF0"),SKTexture(imageNamed: "BrownF1"),SKTexture(imageNamed: "BrownF2"),SKTexture(imageNamed: "BrownF3"),SKTexture(imageNamed: "BrownF4"),SKTexture(imageNamed: "BrownF5"),SKTexture(imageNamed: "BrownF6"),SKTexture(imageNamed: "BrownF7"),SKTexture(imageNamed: "BrownF8"),SKTexture(imageNamed: "BrownF9")], timePerFrame: 0.1))
        let pumpFlameBird = Enemy(image: "PumpF0", coinAmount : 2500,scale: 0.7, speed: 1.0, startPoint: startP,endPoint: CGPoint(x:-1000, y: randomYEnd), animation: SKAction.animate(with: [SKTexture(imageNamed: "PumpF0"),SKTexture(imageNamed: "PumpF1"),SKTexture(imageNamed: "PumpF2"),SKTexture(imageNamed: "PumpF3"),SKTexture(imageNamed: "PumpF4"),SKTexture(imageNamed: "PumpF5"),SKTexture(imageNamed: "PumpF6"),SKTexture(imageNamed: "PumpF7"),SKTexture(imageNamed: "PumpF8"),SKTexture(imageNamed: "PumpF9")], timePerFrame: 0.1))
        let blueFlameBird = Enemy(image: "BlueF0", coinAmount : 10000,scale: 0.8, speed: 1.0, startPoint: startP,endPoint: CGPoint(x:-1000, y: randomYEnd), animation: SKAction.animate(with: [SKTexture(imageNamed: "BlueF0"),SKTexture(imageNamed: "BlueF1"),SKTexture(imageNamed: "BlueF2"),SKTexture(imageNamed: "BlueF3"),SKTexture(imageNamed: "BlueF4"),SKTexture(imageNamed: "BlueF5"),SKTexture(imageNamed: "BlueF6"),SKTexture(imageNamed: "BlueF7"),SKTexture(imageNamed: "BlueF8"),SKTexture(imageNamed: "BlueF9")], timePerFrame: 0.1))
       // let normalMissle = Enemy(scale: 0.7, speed: 1.0, endPoint: CGPoint(x:-1000, y: randomYEnd))
        //let speedMissle = Enemy(scale: 0.5, speed: 0.8, endPoint: CGPoint(x:-1000, y: randomYEnd))
        //let targetingMissle = Enemy(scale: 1.0, speed: 1.3, endPoint: player.position)
        var levelDuration = TimeInterval()
        //print("New Level reached")
        switch level{
        case 1:
            //1.8
            levelDuration = 1.4
            enemyTypes = [brownBird]
        case 2:
            //1.5
            levelDuration = 1.1
            enemyTypes = [brownBird, greenBird, greenBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
        case 3:
            levelDuration = 0.9
            enemyTypes = [greenBird, pumpBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
        case 4:
            levelDuration = 0.8
            enemyTypes = [pumpBird, blueBird, blueBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
        case 5:
            levelDuration = 0.7
            enemyTypes = [blueBird, blueBird, brownFlameBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
        case 6:
            levelDuration = 0.63
            enemyTypes = [brownFlameBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
        case 7:
            levelDuration = 0.575
            enemyTypes = [brownFlameBird, pumpFlameBird, pumpFlameBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
            
        case 8:
            levelDuration = 0.5
            enemyTypes = [pumpFlameBird, pumpFlameBird, blueFlameBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
            
        case 9:
            levelDuration = 0.45
            enemyTypes = [blueFlameBird]
            playerAnimation = SKAction.animate(with: [SKTexture(imageNamed: "BlueFly0"),SKTexture(imageNamed: "BlueFly1"),SKTexture(imageNamed: "BlueFly2"),SKTexture(imageNamed: "BlueFly3"),SKTexture(imageNamed: "BlueFly4") ,SKTexture(imageNamed: "BlueFly5"),SKTexture(imageNamed: "BlueFly6"),SKTexture(imageNamed: "BlueFly7"),SKTexture(imageNamed: "BlueFly8"),SKTexture(imageNamed: "BlueFly9")], timePerFrame: playerAnimationSpeed[level - 1])
            player.run(SKAction.repeatForever(playerAnimation),withKey: "changeAnimation")
        default:
            levelDuration = 1.3
        }
        let spawn = SKAction.run(spawnEnemy)
        let waitSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitSpawn,spawn])
        self.run(SKAction.repeatForever(spawnSequence), withKey:"spawnEnemies")
        /*let waitWeaponIncrease = SKAction.wait(forDuration: moreWeapons)
        let increase = SKAction.run{
            self.updateWeaponCount(number: 1)
            }
        let weaponIncrease = SKAction.sequence([waitWeaponIncrease, increase])
        self.run(SKAction.repeatForever(weaponIncrease), withKey:"incW")
        */
    }
    
    
    func createEndlessB(){
        for n in 0...2{
            let endlessB = SKSpriteNode(texture: SKTexture(imageNamed: "Background1"))
            endlessB.name = "endlessB"
            endlessB.size = CGSize(width: self.size.width, height: self.size.height*1.3)
            endlessB.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            endlessB.position = CGPoint(x: (CGFloat(n) * endlessB.size.width), y: 0)
            endlessB.zPosition = 0
            self.addChild(endlessB)
        }
    }
    
    func moveEndlessB(){
        if(currentGameStage == gameStage.during && level != 0){
            var feverSpeed:CGFloat = 1.0
                if(hasFever || hasSpeedBoost){
                    feverSpeed = 4
                }
                self.enumerateChildNodes(withName: "endlessB", using: ({
                    (node, error) in
                    node.position.x -= ((5 + (2 * CGFloat(self.level))) * feverSpeed)
                
                    if node.position.x < -((self.scene?.size.width)!){
                        node.run(SKAction.setTexture(SKTexture(imageNamed: backgrounds[self.level])))
                        //node.texture = SKTexture(imageNamed: backgrounds[level-1])
                        node.position.x += ((self.scene?.size.width)! * 3)
                    }
            }))
        }
        else if(currentGameStage != gameStage.before && endBackgroundSpeed < 50){
            let changeV1 = (5 + (3 * CGFloat(self.level)))
            let changeV2 = (CGFloat(endBackgroundSpeed) * CGFloat((5 + (3 * CGFloat(self.level)))/50))
            let changeV =  changeV1 - changeV2
            self.enumerateChildNodes(withName: "endlessB", using: ({
            (node, error) in
                node.position.x -= changeV
            
            if node.position.x < -((self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
            endBackgroundSpeed += 1
            //print(endBackgroundSpeed)
        }
    }
    
    func runGameOver(){
        endLevel = level
        currentGameStage = gameStage.after
        self.removeAllActions()
        self.enumerateChildNodes(withName: "projectile"){
            projectile, stop in
            projectile.removeAllActions()
        }
        self.enumerateChildNodes(withName: "enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        self.enumerateChildNodes(withName: "ammoBoost"){
            ammoBoost, stop in
            ammoBoost.removeAllActions()
        }
        self.enumerateChildNodes(withName: "speedBoost"){
            ammoBoost, stop in
            ammoBoost.removeAllActions()
        }
        self.enumerateChildNodes(withName: "extraLife"){
            ammoBoost, stop in
            ammoBoost.removeAllActions()
        }
        let playerFaint = SKAction.run{
            self.player.removeAction(forKey: "changeAnimation")
            self.player.run(self.faintAnimation)
        }
        let changeScene = SKAction.sequence([playerFaint,SKAction.wait(forDuration: 2), SKAction.run(endScene)])
        self.run(changeScene)
    }
    
    
    func endScene(){
        let nextScene = GameOver(size: CGSize(width: 2532, height: 1170))
        nextScene.scaleMode = .aspectFit
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(nextScene, transition: myTransition)
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
    //if the Player and a missle colide
       if (body1.categoryBitMask == PhysicsCats.Player && body2.categoryBitMask == PhysicsCats.Enemy){
                updateLives()
                self.run(impactSound)
                if body2.node != nil{
                    if(hasFever){
                        self.spawnCoinLabel(spawnPosition: CGPoint(x: body2.node!.position.x, y: body2.node!.position.y), cCount: earnedCoins)
                    }
                    explode(spawnPosition: body2.node!.position)
                    body2.node?.removeFromParent()
            }
        }
        //if player and boost colide
        if (body1.categoryBitMask == PhysicsCats.Player && body2.categoryBitMask == PhysicsCats.AmmoBoost){
            if (powerUpType == 1) {
                lives += 1
                livesLabel.text = "\(lives)"
                self.run(powerUpSound)
            }
            else if(powerUpType == 2){
                let randomAmmoCount = Int.random(in: 6...9)
                updateWeaponCount(number:randomAmmoCount)
                self.run(powerUpSound)
            }
            else if(powerUpType == 3){
                speedBoost()
                self.run(speedBoostSound)
            }
            /*
            else{
                print("error with powerUps")
            }
            */
            if body2.node != nil{
                body2.node?.removeFromParent()
            }
         }
        //if the shuriken and Enemy collide
        if (body1.categoryBitMask == PhysicsCats.Projectile && body2.categoryBitMask == PhysicsCats.Enemy){
            if body2.node != nil{
                self.run(impactSound)
                self.spawnCoinLabel(spawnPosition: CGPoint(x: body2.node!.position.x, y: body2.node!.position.y), cCount: earnedCoins)
                feverSystem(increaseCounter: 1)
                explode(spawnPosition: body2.node!.position)
                //let spawnManyCoinSeq = SKAction.sequence(spawnManyCoins)
                //self.run(spawnManyCoinSeq)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    
    override func update(_ currentTime: CFTimeInterval){
        moveEndlessB()
    }

    
    //This function runs when a touch is detected. It will run the throwShiruken function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch: AnyObject in touches{
            let pointOfTouch2 = touch.location(in: self)
            if(currentGameStage == gameStage.before){
                startGame()
            }
            else if(currentGameStage == gameStage.during){
                if (pointOfTouch2.x > 0){
                    if(weaponCount > 0){
                        throwShiruken(endShirukenPath : pointOfTouch2)
                        updateWeaponCount(number:-1)
                    }
                }
            }
        }
    }

   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch: AnyObject in touches{
                if(currentGameStage == gameStage.during){
                    let pointOfTouch = touch.location(in: self)
                    if (pointOfTouch.x < 0){
                        let previousPontOfTouch = touch.previousLocation(in: self)
                        let amountDragged = pointOfTouch.y - previousPontOfTouch.y
                        if(amountDragged < 0){
                            
                        }
                        if(currentGameStage == gameStage.during){
                            player.position.y += amountDragged
                        }
                        if (player.position.y >= 400) {
                            player.position.y = 400
                                       }
                        if (player.position.y <= -470) {
                            player.position.y = -470
                        }
                    }
                }
            }
    }
}

