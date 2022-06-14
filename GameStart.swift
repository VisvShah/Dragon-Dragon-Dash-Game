//
//  GameViewController.swift
//  NND LandScape
//
//  Created by Visv Shah on 3/7/22.
//

import UIKit
import SpriteKit
import GameplayKit
import Foundation
var fromGameStart : Bool = true

class GameStart: SKScene{
    let startGameLabel = SKLabelNode(fontNamed: mainFont)
    let startGameButton = SKSpriteNode(imageNamed: "playButton")
    override func didMove(to view: SKView) {
        //print("gameStart")
        let background = SKSpriteNode(imageNamed: "Background1")
        background.size = CGSize(width: self.size.width, height: self.size.height*1.3)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        let header1 = SKLabelNode(fontNamed: mainFont)
        header1.text = "Dragon Dragon"
        header1.fontSize = 290
        header1.fontColor = UIColor.black
        header1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.60)
        header1.zPosition = 1
        self.addChild(header1)
        
        let header2 = SKLabelNode(fontNamed: mainFont)
        header2.text = "Dash"
        header2.fontSize = 340
        header2.fontColor = UIColor.black
        header2.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.38)
        header2.zPosition = 1
        self.addChild(header2)
        
        startGameButton.setScale(1.2)
        startGameButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.18)
        startGameButton.zPosition = 2
        self.addChild(startGameButton)
        
        /*
        startGameLabel.text = "Start Game"
        startGameLabel.fontSize = 130
        startGameLabel.fontColor = UIColor.black
        startGameLabel.position = CGPoint(x: 900, y: 300)
        startGameLabel.zPosition = 3
        self.addChild(startGameLabel)
        */
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if startGameButton.contains(pointOfTouch){
                self.run(clickSound)
                fromGameStart = true
                let nextScene = GameScene(size: CGSize(width: 2532, height: 1170))
                nextScene.scaleMode = .aspectFit
                self.view!.presentScene(nextScene, transition: SKTransition.fade(withDuration: 0.6))
            }
        }
    }
}



