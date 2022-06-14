//
//  GameUpgradesPage.swift
//  Dragon Dragon Dash
//
//  Created by Visv Shah on 5/1/22.
//


import Foundation
import UIKit
import SpriteKit
import GameplayKit

import Foundation
import SpriteKit


class GameUpgradesPage: SKScene{
    
    let homeButton = SKSpriteNode(imageNamed: "homeButton")
    let newGameButton = SKSpriteNode(imageNamed: "playButton")
    let returnButton = SKSpriteNode(imageNamed: "returnButton")
    let upgradeSound = SKAction.playSoundFileNamed("upgradeSound.wav", waitForCompletion: false)
    
    var upgradingLivesAlready = true
    var upgradingPUAlready = true
    var upgradingSWAlready = true
    var upgradingCoinsAlready = true
    let coinsLabel2 = SKLabelNode(fontNamed: mainFont)
    
    let livesLevelLabel = SKLabelNode(fontNamed: mainFont)
    let speedLevelLabel = SKLabelNode(fontNamed: mainFont)
    let fireBallsLevelLabel = SKLabelNode(fontNamed: mainFont)
    let coinsLevelLabel = SKLabelNode(fontNamed: mainFont)
    
    let upgradeButtonLives = SKSpriteNode(imageNamed: "coinLabel")
    let upgradeButtonPU = SKSpriteNode(imageNamed: "coinLabel")
    let upgradeButtonSW = SKSpriteNode(imageNamed: "coinLabel")
    let upgradeButtonCoins = SKSpriteNode(imageNamed: "coinLabel")
    
    let upgradeLivesLabel = SKLabelNode(fontNamed: mainFont)
    let upgradePULabel = SKLabelNode(fontNamed: mainFont)
    let upgradeWeaponsLabel = SKLabelNode(fontNamed: mainFont)
    let upgradeCoinsLabel = SKLabelNode(fontNamed: mainFont)
    
    //let testGameButton = SKSpriteNode(imageNamed: "stoneBlock")
    
    override func didMove(to view: SKView) {
        /*
        livesLevel = 4
        powerUpLevel = 4
        sWeaponsLevel = 4
        */
        
        let upgradePanel = SKSpriteNode(imageNamed: "upgradesPage4")
        upgradePanel.setScale(1.7)
        upgradePanel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.54)
        upgradePanel.zPosition = 2
        self.addChild(upgradePanel)
        
        let background = SKSpriteNode(imageNamed: backgrounds[endLevel])
        background.size = CGSize(width: self.size.width, height: self.size.height*1.3)
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        background.zPosition = 0
        self.addChild(background)
        
        upgradeButtonLives.setScale(0.8)
        upgradeButtonLives.position = CGPoint(x: self.size.width * 0.61, y: self.size.height * 0.73)
        upgradeButtonLives.zPosition = 5
        self.addChild(upgradeButtonLives)
        if livesLevel < 9 {
            upgradeLivesLabel.text = "\(livesUpgrade.upgradeCosts[livesLevel])"
        }
        else{
            upgradeLivesLabel.text = "MAX"
        }
        upgradeLivesLabel.fontSize = 75
        upgradeLivesLabel.fontColor = UIColor.black
        upgradeLivesLabel.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.71)
        upgradeLivesLabel.zPosition = 6
        self.addChild(upgradeLivesLabel)
        
        upgradeButtonPU.setScale(0.8)
        upgradeButtonPU.position = CGPoint(x: self.size.width * 0.61, y: self.size.height * 0.555)
        upgradeButtonPU.zPosition = 5
        self.addChild(upgradeButtonPU)
        if powerUpLevel < 4 {
            upgradePULabel.text = "\(PUChanceUpgrade.upgradeCosts[powerUpLevel])"
        }
        else{
            upgradePULabel.text = "MAX"
        }
        upgradePULabel.fontSize = 75
        upgradePULabel.fontColor = UIColor.black
        upgradePULabel.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.53)
        upgradePULabel.zPosition = 6
        self.addChild(upgradePULabel)
        
        upgradeButtonSW.setScale(0.8)
        upgradeButtonSW.position = CGPoint(x: self.size.width * 0.61, y: self.size.height * 0.395)
        upgradeButtonSW.zPosition = 5
        self.addChild(upgradeButtonSW)
        if sWeaponsLevel < 9 {
            upgradeWeaponsLabel.text = "\(sWeaponsUpgrade.upgradeCosts[sWeaponsLevel])"
        }
        else{
            upgradeWeaponsLabel.text = "MAX"
        }
        upgradeWeaponsLabel.fontSize = 75
        upgradeWeaponsLabel.fontColor = UIColor.black
        upgradeWeaponsLabel.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.375)
        upgradeWeaponsLabel.zPosition = 6
        self.addChild(upgradeWeaponsLabel)
        
        
        
        upgradeButtonCoins.setScale(0.8)
        upgradeButtonCoins.position = CGPoint(x: self.size.width * 0.61, y: self.size.height * 0.22)
        upgradeButtonCoins.zPosition = 5
        self.addChild(upgradeButtonCoins)
        if coinsUpgradeLevel < 4 {
            upgradeCoinsLabel.text = "\(coinsUpgrade.upgradeCosts[coinsUpgradeLevel])"
        }
        else{
            upgradeCoinsLabel.text = "MAX"
        }
        upgradeCoinsLabel.fontSize = 75
        upgradeCoinsLabel.fontColor = UIColor.black
        upgradeCoinsLabel.position = CGPoint(x: self.size.width * 0.63, y: self.size.height * 0.2)
        upgradeCoinsLabel.zPosition = 6
        self.addChild(upgradeCoinsLabel)
        
        /*
        for n in 0...livesLevel{
            let upgradeLevelDot = SKSpriteNode(imageNamed: "upgradeLevel")
            upgradeLevelDot.setScale(2.3)
            upgradeLevelDot.position = CGPoint(x: 615 + 77 * n, y: 847)
            upgradeLevelDot.zPosition = 4
            self.addChild(upgradeLevelDot)
        }
        for n in 0...powerUpLevel{
            let upgradeLevelDot = SKSpriteNode(imageNamed: "upgradeLevel")
            upgradeLevelDot.setScale(2.3)
            upgradeLevelDot.position = CGPoint(x: 615 + 77 * n, y: 630)
            upgradeLevelDot.zPosition = 4
            self.addChild(upgradeLevelDot)
        }
        for n in 0...sWeaponsLevel{
            let upgradeLevelDot = SKSpriteNode(imageNamed: "upgradeLevel")
            upgradeLevelDot.setScale(2.3)
            upgradeLevelDot.position = CGPoint(x: 615 + 77 * n, y: 401)
            upgradeLevelDot.zPosition = 4
            self.addChild(upgradeLevelDot)
        }
        */
        livesLevelLabel.text = "Level: \(livesLevel + 1)"
        livesLevelLabel.fontSize = 60
        livesLevelLabel.fontColor = SKColor.black
        livesLevelLabel.position = CGPoint(x: self.size.width * 0.44, y:self.size.height * 0.71)
        livesLevelLabel.zPosition = 4
        self.addChild(livesLevelLabel)
        
        speedLevelLabel.text = "Level: \(powerUpLevel + 1)"
        speedLevelLabel.fontSize = 60
        speedLevelLabel.fontColor = SKColor.black
        speedLevelLabel.position = CGPoint(x: self.size.width * 0.44, y:self.size.height * 0.542)
        speedLevelLabel.zPosition = 4
        self.addChild(speedLevelLabel)
        
        fireBallsLevelLabel.text = "Level: \(sWeaponsLevel + 1)"
        fireBallsLevelLabel.fontSize = 60
        fireBallsLevelLabel.fontColor = SKColor.black
        fireBallsLevelLabel.position = CGPoint(x: self.size.width * 0.44, y:self.size.height * 0.376)
        fireBallsLevelLabel.zPosition = 4
        self.addChild(fireBallsLevelLabel)
        
        coinsLevelLabel.text = "Level: \(coinsUpgradeLevel + 1)"
        coinsLevelLabel.fontSize = 60
        coinsLevelLabel.fontColor = SKColor.black
        coinsLevelLabel.position = CGPoint(x: self.size.width * 0.44, y:self.size.height * 0.21)
        coinsLevelLabel.zPosition = 4
        self.addChild(coinsLevelLabel)
        
        let coinLabel1 = SKSpriteNode(imageNamed: "coinLabel")
        coinLabel1.setScale(0.8)
        coinLabel1.position = CGPoint(x: self.size.width * 0.88, y:self.size.height * 0.885)
        coinLabel1.zPosition = 9
        self.addChild(coinLabel1)
        
        coinsLabel2.text = "\(coins)"
        coinsLabel2.fontSize = 50
        coinsLabel2.fontColor = SKColor.black
        coinsLabel2.position = CGPoint(x: self.size.width * 0.95, y:self.size.height * 0.868)
        coinsLabel2.zPosition = 10
        coinsLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.addChild(coinsLabel2)
        
        /*
        testGameButton.setScale(1.6)
        testGameButton.position = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.10)
        testGameButton.zPosition = 11
        self.addChild(testGameButton)
        */
        homeButton.setScale(1)
        homeButton.position = CGPoint(x: self.size.width*2/3, y: self.size.height/10)
        homeButton.zPosition = 5
        self.addChild(homeButton)
        
        newGameButton.setScale(0.8)
        newGameButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.10)
        newGameButton.zPosition = 5
        self.addChild(newGameButton)
        
        returnButton.setScale(1)
        returnButton.position = CGPoint(x: self.size.width/3, y: self.size.height/10)
        returnButton.zPosition = 5
        self.addChild(returnButton)
    }
    
    func upgradeLives(){
        if(coins >= livesUpgrade.upgradeCosts[livesLevel] && upgradingLivesAlready){
            self.run(upgradeSound)
            upgradingLivesAlready = false
            
            coins -= livesUpgrade.upgradeCosts[livesLevel]
            coinsLabel2.text = "\(coins)"
            defaults.set(coins, forKey: "coinsValue")
            
            livesLevel += 1
            if livesLevel < 9 {
                upgradeLivesLabel.text = "\(livesUpgrade.upgradeCosts[livesLevel])"
            }
            else{
                upgradeLivesLabel.text = "MAX"
            }
            defaults.set(livesLevel, forKey: "livesUpgrade")
            livesLevelLabel.text = "Level: \(livesLevel + 1)"
            
            let livesUpgradeShakeStart = SKAction.scale(to: 1.2, duration: 0.3)
            let livesUpgradeShakeEnd = SKAction.scale(to: 0.8, duration: 0.3)
            
            let UpgradeShakeStart2 = SKAction.scale(to: 1.3, duration: 0.3)
            let UpgradeShakeEnd2 = SKAction.scale(to: 1.0, duration: 0.3)
            upgradeLivesLabel.run(SKAction.sequence([UpgradeShakeStart2, UpgradeShakeEnd2]))
            upgradeButtonLives.run(SKAction.sequence([livesUpgradeShakeStart, livesUpgradeShakeEnd]))
            upgradingLivesAlready = true
        }
    }
    func upgradePU(){
        if(coins >= PUChanceUpgrade.upgradeCosts[powerUpLevel] && upgradingPUAlready){
            self.run(upgradeSound)
            upgradingPUAlready = false
            
            coins -= PUChanceUpgrade.upgradeCosts[powerUpLevel]
            coinsLabel2.text = "\(coins)"
            defaults.set(coins, forKey: "coinsValue")
            
            powerUpLevel += 1
            if powerUpLevel < 4 {
                upgradePULabel.text = "\(PUChanceUpgrade.upgradeCosts[powerUpLevel])"
            }
            else{
                upgradePULabel.text = "MAX"
            }
            defaults.set(powerUpLevel, forKey: "PUUpgrade")
            speedLevelLabel.text = "Level: \(powerUpLevel + 1)"
            
            let UpgradeShakeStart = SKAction.scale(to: 1.2, duration: 0.3)
            let UpgradeShakeEnd = SKAction.scale(to: 0.8, duration: 0.3)
            
            let UpgradeShakeStart2 = SKAction.scale(to: 1.3, duration: 0.3)
            let UpgradeShakeEnd2 = SKAction.scale(to: 1.0, duration: 0.3)
            upgradePULabel.run(SKAction.sequence([UpgradeShakeStart2, UpgradeShakeEnd2]))
            upgradeButtonPU.run(SKAction.sequence([UpgradeShakeStart, UpgradeShakeEnd]))
            upgradingPUAlready = true
        }
    }
    func upgradeSW(){
        if(coins >= sWeaponsUpgrade.upgradeCosts[sWeaponsLevel] && upgradingSWAlready){
            self.run(upgradeSound)
            upgradingSWAlready = false
       
            coins -= sWeaponsUpgrade.upgradeCosts[sWeaponsLevel]
            coinsLabel2.text = "\(coins)"
            defaults.set(coins, forKey: "coinsValue")
            
            sWeaponsLevel += 1
            if sWeaponsLevel < 9 {
                upgradeWeaponsLabel.text = "\(sWeaponsUpgrade.upgradeCosts[sWeaponsLevel])"
            }
            else{
                upgradeWeaponsLabel.text = "MAX"
            }
            defaults.set(sWeaponsLevel, forKey: "SWUpgrade")
            fireBallsLevelLabel.text = "Level: \(sWeaponsLevel + 1)"
            
            let UpgradeShakeStart = SKAction.scale(to: 1.2, duration: 0.3)
            let UpgradeShakeEnd = SKAction.scale(to: 0.8, duration: 0.3)
            
            let UpgradeShakeStart2 = SKAction.scale(to: 1.3, duration: 0.3)
            let UpgradeShakeEnd2 = SKAction.scale(to: 1.0, duration: 0.3)
            upgradeWeaponsLabel.run(SKAction.sequence([UpgradeShakeStart2, UpgradeShakeEnd2]))
            upgradeButtonSW.run(SKAction.sequence([UpgradeShakeStart, UpgradeShakeEnd]))
            upgradingSWAlready = true
        }
    }
    func upgradeCoins(){
        if(coins >= coinsUpgrade.upgradeCosts[coinsUpgradeLevel] && upgradingCoinsAlready){
            self.run(upgradeSound)
            upgradingCoinsAlready = false
            
            coins -= coinsUpgrade.upgradeCosts[coinsUpgradeLevel]
            coinsLabel2.text = "\(coins)"
            defaults.set(coins, forKey: "coinsValue")
            
            coinsUpgradeLevel += 1
            if coinsUpgradeLevel < 4 {
                upgradeCoinsLabel.text = "\(coinsUpgrade.upgradeCosts[coinsUpgradeLevel])"
            }
            else{
                upgradeCoinsLabel.text = "MAX"
            }
            defaults.set(coinsUpgradeLevel, forKey: "coinsUpgradeLevel")
            coinsLevelLabel.text = "Level: \(coinsUpgradeLevel + 1)"
            
            let UpgradeShakeStart = SKAction.scale(to: 1.2, duration: 0.3)
            let UpgradeShakeEnd = SKAction.scale(to: 0.8, duration: 0.3)
            
            let UpgradeShakeStart2 = SKAction.scale(to: 1.3, duration: 0.3)
            let UpgradeShakeEnd2 = SKAction.scale(to: 1.0, duration: 0.3)
            upgradeCoinsLabel.run(SKAction.sequence([UpgradeShakeStart2, UpgradeShakeEnd2]))
            upgradeButtonCoins.run(SKAction.sequence([UpgradeShakeStart, UpgradeShakeEnd]))
            upgradingCoinsAlready = true
        }
    }
    /*
    func testGame(){
        livesLevel = 0
        defaults.set(livesLevel, forKey: "livesUpgrade")
        powerUpLevel = 4
        defaults.set(powerUpLevel, forKey: "PUUpgrade")
        sWeaponsLevel = 0
        defaults.set(sWeaponsLevel, forKey: "SWUpgrade")
        coins = 0
        defaults.set(coins, forKey: "coinsValue")
        highScore = 1
        defaults.set(highScore, forKey: "highScoreValue")
        coinsUpgradeLevel = 0
        defaults.set(coinsUpgradeLevel, forKey: "coinsUpgradeLevel")
        let nextScene = GameUpgradesPage(size:CGSize(width: 2532, height: 1170))
        nextScene.scaleMode = .aspectFill
        self.view!.presentScene(nextScene)
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if homeButton.contains(pointOfTouch){
                self.run(clickSound)
                let nextScene = GameStart(size: CGSize(width: 2532, height: 1170))
                nextScene.scaleMode = .aspectFit
                self.view!.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.6))
            }
            else if returnButton.contains(pointOfTouch){
                self.run(clickSound)
                let nextScene = GameOver(size: CGSize(width: 2532, height: 1170))
                nextScene.scaleMode = .aspectFit
                self.view!.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.6))
            }
            else if newGameButton.contains(pointOfTouch){
                self.run(clickSound)
                fromGameStart = false
                let nextScene = GameScene(size: CGSize(width: 2532, height: 1170))
                nextScene.scaleMode = .aspectFit
                self.view!.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.6))
            }
            /*else if testGameButton.contains(pointOfTouch){
                testGame()
            }
            */
            else if upgradeButtonLives.contains(pointOfTouch) && livesLevel < 9{
                upgradeLives()
            }
            else if upgradeButtonPU.contains(pointOfTouch) && powerUpLevel < 4{
                upgradePU()
            }
            else if upgradeButtonSW.contains(pointOfTouch) && sWeaponsLevel < 9{
                upgradeSW()
            }
            else if upgradeButtonCoins.contains(pointOfTouch) && coinsUpgradeLevel < 4{
                upgradeCoins()
            }
        }
    }
}


