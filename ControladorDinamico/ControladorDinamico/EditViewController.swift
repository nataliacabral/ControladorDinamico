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
        self.scene!.objects = NSMutableArray(array:self.project.objects)
        skView.presentScene(scene)
    }
    
    @IBAction func saveProjectAction(AnyObject) {
         if (self.project.projectName == nil) {
            let alert = UIAlertView(title: "Save", message: "Insert the project name", delegate:self, cancelButtonTitle: "OK")
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput;
            alert.show()
        } else {
            self.saveProject()
        }
    }
    
    @IBAction func backAction(AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveProject() -> Bool {
        if (self.project.projectName != nil) {
            
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.mainScreen().scale);
            self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            self.project.preview = image
            self.project.objects = self.scene!.objects
            return ProjectManager.sharedInstance.saveProject(self.project)
        }
        return false
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0) {
            let projectName = alertView.textFieldAtIndex(0)!.text!
            self.project = Project(projectName:projectName)
            self.saveProject()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "play" {
            let playViewController = segue.destinationViewController as PlayViewController
            self.project.objects = self.scene!.objects
            playViewController.project = self.project
        }
    }
}
