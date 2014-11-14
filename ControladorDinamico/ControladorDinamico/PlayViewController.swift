//
//  PlayViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 14/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//


import UIKit
import SpriteKit

class PlayViewController : UIViewController {
    var scene:PlayScene?
    var project:Project?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None;
        
        var skView:SKView = self.view as SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        
        self.scene = PlayScene(size: skView.bounds.size);
        self.scene!.objects = NSMutableArray(array:self.project!.objects)
        skView.presentScene(scene)
    }
    
    @IBAction func backAction(AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}