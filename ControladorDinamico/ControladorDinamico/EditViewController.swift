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
        self.saveProject()
        skView.presentScene(scene)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let project : Project? = ProjectManager.sharedInstance.projectWithName(self.project.projectName!)
        if (project != nil) {
            self.project = project!
        }
    }
    
    func saveProject()
    {
        if (self.project.projectName != nil) {
            
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.mainScreen().scale);
            self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.project.preview = image
            self.project.objects = self.scene!.objects
            ProjectManager.sharedInstance.saveProject(self.project)
        }
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
    
    override func viewWillDisappear(animated: Bool) {
        self.saveProject()
    }
}
