//
//  GameViewController.swift
//  SnakeAndLaddersSpriteKit
//
//  Created by Iason Michailidis on 15/12/15.
//  Copyright (c) 2015 Archetypon. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene:GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
//        skView.showsPhysics = true
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.backgroundColor = UIColor(red: 0, green: 0.0078, blue: 0.5373, alpha: 1.0)
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
