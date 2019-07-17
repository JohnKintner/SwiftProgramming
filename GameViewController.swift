//
//  GameViewController.swift
//  Kintner_Final
//
//  Created by student on 4/15/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = Start(size: view.bounds.size);
        let skView = view as! SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        skView.ignoresSiblingOrder = true;
        scene.scaleMode = .resizeFill;
        skView.presentScene(scene);
    }
}
