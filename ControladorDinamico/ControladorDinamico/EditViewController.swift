//
//  EditViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 27/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import UIKit
import SpriteKit

class EditViewController : UIViewController, UIAlertViewDelegate {
    var scene:EditScene?
    var project:Project

    required init(coder aDecoder: NSCoder) {
        self.project = Project()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None;
      
        var skView:SKView = self.view as SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        
        self.scene = EditScene(size: skView.bounds.size);
        self.scene!.objects = self.project.objects
        skView.presentScene(scene)
    }

    
    @IBAction func backAction(AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "play" {
            let playViewController = segue.destinationViewController as PlayViewController
            self.project.objects = self.scene!.objects
            playViewController.project = self.project
        }
    }
}
