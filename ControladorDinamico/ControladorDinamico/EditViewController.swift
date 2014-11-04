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
    var alert:UIAlertView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None;
      
        // Configure the view.
        var skView:SKView = self.view as SKView;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        
        // Create and configure the scene.
        self.scene = EditScene(size: skView.bounds.size);

        // Present the scene.
        skView.presentScene(scene)
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveProject(AnyObject) {
        alert = UIAlertView(title: "Save", message: "Insert the project name", delegate:self, cancelButtonTitle: "OK")
        alert!.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        alert!.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0) {
            var projectName = alert!.textFieldAtIndex(0)!.text!

            let fullName:NSString = projectName.stringByAppendingPathExtension("txt")!
            let destinationPath:NSString = documentsPath.stringByAppendingPathComponent(fullName)
            
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
            let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let project:Project = Project(projectName:projectName, objects:self.scene!.project, image:image)

            let filemanager = NSFileManager.defaultManager()
            if(!filemanager.fileExistsAtPath(destinationPath)){
                var saved:Bool = NSKeyedArchiver.archiveRootObject(project, toFile:destinationPath)
            }
        }
    }
}
