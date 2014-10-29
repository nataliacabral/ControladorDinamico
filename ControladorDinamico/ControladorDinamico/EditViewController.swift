//
//  EditViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 27/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import UIKit
import SpriteKit

class EditViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None;
      
        // Configure the view.
        var skView:SKView = self.view as SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        
        // Create and configure the scene.
        var scene:SKScene = EditScene(size: skView.bounds.size);
        scene.scaleMode = SKSceneScaleMode.AspectFill;
    
        // Present the scene.
        skView.presentScene(scene)
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
