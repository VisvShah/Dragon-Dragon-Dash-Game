//
//  GameViewController.swift
//  NND LandScape
//
//  Created by Visv Shah on 3/7/22.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var mainFont = "PartyConfetti-Regular"
class GameViewController: UIViewController {
var backgroundAudio = AVAudioPlayer()

 override func viewDidLoad() {//new one
            super.viewDidLoad()
            print("Game View contoller started")
    
    let filePath = Bundle.main.path(forResource: "BackgroundMusic", ofType: "mp3")
    let audioNSURL = NSURL(fileURLWithPath: filePath!)
    
    do { backgroundAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL)}
    catch {return print("Cannot fint Audio")}
    
    backgroundAudio.numberOfLoops = -1
    backgroundAudio.volume = 0.15
    backgroundAudio.play()
    
    
    if let view = self.view as! SKView? {
        // Load the SKScene from 'GameScene.sks'
        //let screenSize = UIScreen.main.bounds
        let scene = GameStart(size: CGSize(width: 2532, height: 1170))
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            
            view.presentScene(scene)
            
        view.ignoresSiblingOrder = true
        view.showsFPS = false
        view.showsNodeCount = false
    }
}

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


