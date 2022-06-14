//
//  GameOver.swift
//  NND LandScape
//
//  Created by Visv Shah on 3/7/22.
//

import UIKit
import SpriteKit
import GameplayKit
import Foundation
import SpriteKit
import CoreImage


var highScore = defaults.integer(forKey: "highScoreValue")
var coins = defaults.integer(forKey: "coinsValue")
let clickSound = SKAction.playSoundFileNamed("buttonClick.wav", waitForCompletion: false)
class GameOver: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: mainFont)
    let coinsLabel2 = SKLabelNode(fontNamed: mainFont)
    
    let upgradePageButton = SKSpriteNode(imageNamed: "upgradePageButton")
    let newGameButton = SKSpriteNode(imageNamed: "playButton")
    let homeButton = SKSpriteNode(imageNamed: "homeButton")
   
    override func didMove(to view: SKView) {
        
        /*
        if interstitial != nil {
            self.present(interstitial)
          } else {
            print("Ad wasn't ready")
          }
        */
        
        let background = SKSpriteNode(imageNamed: backgrounds[endLevel])
        background.size = CGSize(width: self.size.width, height: self.size.height*1.3)
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverPanel = SKSpriteNode(imageNamed: "gameOverPage")
        gameOverPanel.setScale(2)
        gameOverPanel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        gameOverPanel.zPosition = 2
        self.addChild(gameOverPanel)
        
        /*
        let gameOverTitle = SKLabelNode(fontNamed: mainFont)
        gameOverTitle.text = "Game Over"
        gameOverTitle.fontSize = 250
        gameOverTitle.fontColor = UIColor.black
        gameOverTitle.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameOverTitle.zPosition = 2
        self.addChild(gameOverTitle)
        */
        let scoreLabel = SKLabelNode(fontNamed: mainFont)
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = UIColor.black
        scoreLabel.position = CGPoint(x: self.size.width * 0.62, y:self.size.height * 0.635)
        scoreLabel.zPosition = 4
        self.addChild(scoreLabel)
        
        if (score > highScore){
            highScore = score
            defaults.set(highScore, forKey: "highScoreValue")
        }
        let highScoreLabel = SKLabelNode(fontNamed: mainFont)
        highScoreLabel.text = "\(highScore)"
        highScoreLabel.fontSize = 130
        highScoreLabel.fontColor = UIColor.black
        highScoreLabel.position = CGPoint(x: self.size.width * 0.62, y:self.size.height * 0.497)
        highScoreLabel.zPosition = 4
        self.addChild(highScoreLabel)
        
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
        let coinImage = SKSpriteNode(imageNamed: "coin1")
        coinImage.setScale(1.2)
        coinImage.zPosition = 10
        coinImage.position = CGPoint(x: self.size.width * 0.925, y:self.size.height * 0.885)
        self.addChild(coinImage)
        
        coinsLabel2.text = "Coins: \(coins)"
        coinsLabel2.fontSize = 50
        coinsLabel2.fontColor = SKColor.black
        coinsLabel2.position = CGPoint(x: self.size.width/7, y:self.size.height * 0.8)
        coinsLabel2.zPosition = 10
        coinsLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        self.addChild(coinsLabel2)
        */
        
        newGameButton.setScale(1)
        newGameButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.3)
        newGameButton.zPosition = 5
        self.addChild(newGameButton)
        
        homeButton.setScale(1)
        homeButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.3)
        homeButton.zPosition = 5
        self.addChild(homeButton)
        
        upgradePageButton.setScale(1)
        upgradePageButton.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.3)
        upgradePageButton.zPosition = 5
        self.addChild(upgradePageButton)
        
        
        
      }
    /*
    @objc func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }
    @objc private func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
      }

    @objc func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
      }
 */
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if newGameButton.contains(pointOfTouch){
                self.run(clickSound)
                fromGameStart = false
                //let nextScene = GameScene(size: CGSize(width: 1800, height: 1350))
                let nextScene = GameScene(size: CGSize(width: 2532, height: 1170))
                nextScene.scaleMode = .aspectFit
                self.view!.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.6))
            }
            if homeButton.contains(pointOfTouch){
                self.run(clickSound)
                let nextScene = GameStart(size: CGSize(width: 2532, height: 1170))
                nextScene.scaleMode = .aspectFit
                self.view!.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.6))
            }
            if upgradePageButton.contains(pointOfTouch){
                self.run(clickSound)
                let nextScene = GameUpgradesPage(size: CGSize(width: 2532, height: 1170))
                nextScene.scaleMode = .aspectFit
                self.view!.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.6))
            }
        }
    }
}


