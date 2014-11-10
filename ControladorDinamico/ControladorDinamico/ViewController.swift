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
    @IBOutlet var tableView:UITableView!

    var selectedIndex:Int = -1
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
            self.selectProject(atIndex: indexPath.row)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "openProject" {
            let editViewController = segue.destinationViewController as EditViewController
            let selectedProject = self.projects[self.selectedIndex] as Project
            editViewController.project = selectedProject
        }
    }
    
    func selectProject(atIndex index:Int)
    {
        self.selectedIndex = index
        
        if (index >= 0){
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow:index, inSection:0), animated:false, scrollPosition:UITableViewScrollPosition.None)
            let selectedProject:Project = projects[index] as Project
            var currentPreview:UIImage = selectedProject.preview;
            self.previewView.setImage(currentPreview, forState: .Normal)
        } else {
            self.previewView.setImage(nil, forState: UIControlState.Normal)
        }
    }
    
    @IBAction func removeSelectedObject(AnyObject)  {
        if (self.selectedIndex >= 0) {
            let selectedProject:Project = self.projects.objectAtIndex(self.selectedIndex) as Project
            self.projects.removeObjectAtIndex(self.selectedIndex)
            let filemanager = NSFileManager.defaultManager()
            let projectName:NSString = selectedProject.projectName.stringByAppendingPathExtension("txt")!
            let projectPath:NSString = documentsPath.stringByAppendingPathComponent(projectName)

            if(filemanager.fileExistsAtPath(projectPath)){
                var error: NSError? = nil
                if (filemanager.removeItemAtPath(projectPath, error: &error)){
                    self.tableView.reloadData()
                    
                    if (self.selectedIndex < self.projects.count) {
                        self.selectProject(atIndex: self.selectedIndex)
                    } else {
                        self.selectProject(atIndex: (self.selectedIndex-1))
                    }
                    
                } else {
                    NSLog("error %@ ", error!.localizedDescription)
                }
            }
        }
    }

}

