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
    let documentsPath : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as NSString
    var scene:EditScene?
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
        
        self.scene = EditScene(size: skView.bounds.size);
        if self.project != nil {
            self.scene!.objects = NSMutableArray(array:self.project!.objects)
        }
        skView.presentScene(scene)
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveProjectAction(AnyObject) {
        if (self.project == nil) {
            let alert = UIAlertView(title: "Save", message: "Insert the project name", delegate:self, cancelButtonTitle: "OK")
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput;
            alert.show()
        } else {
            self.saveProject()
        }
    }
    
    func saveProject() -> Bool {
        if (self.project != nil) {
            
            let fullName:NSString = self.project!.projectName.stringByAppendingPathExtension("txt")!
            let destinationPath:NSString = documentsPath.stringByAppendingPathComponent(fullName)
            
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.mainScreen().scale);
            self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            self.project!.preview = image;
            self.project!.objects = self.scene!.objects;

            let filemanager = NSFileManager.defaultManager()
            if(!filemanager.fileExistsAtPath(destinationPath)){
                return NSKeyedArchiver.archiveRootObject(self.project!, toFile:destinationPath)
            }
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

}
