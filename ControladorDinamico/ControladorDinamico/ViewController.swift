//
//  ViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 23/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var previewView:UIButton!

    var selectedProject:Project?
    var projects:NSMutableArray = NSMutableArray()
    let documentsPath : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as NSString

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(documentsPath, error: &error)
        if contents != nil {
            let filenames = contents as [String]
            for name in filenames {
                let filePath:NSString = documentsPath.stringByAppendingPathComponent(name)
                let project:Project =  NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as Project
                projects.addObject(project)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableCell:UITableViewCell = UITableViewCell()
        tableCell.textLabel.text = (projects.objectAtIndex(indexPath.row) as Project).projectName
        return tableCell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var currentPreview:UIImage = (projects[indexPath.row] as Project).preview;
        self.previewView.setImage(currentPreview, forState: .Normal)
        self.selectedProject = projects[indexPath.row] as Project
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "openProject" {
            let editViewController = segue.destinationViewController as EditViewController
            editViewController.project = self.selectedProject
        }
    }
}

