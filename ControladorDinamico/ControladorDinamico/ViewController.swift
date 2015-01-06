//
//  ViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 23/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIAlertViewDelegate  {
    
    @IBOutlet var collectionView:UICollectionView!

    let projectCellViewIdentifier:String = "projectView"
    let projectNameLabelTag:Int = 10
    let projectBackgroundViewTag:Int = 20

    var newProjectTextfield:UITextField?
    
    var selectedProject:Project?
    var projects:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {

        var projectCell:UINib = UINib(nibName:"ProjectView", bundle: nil)
        self.collectionView.registerNib(projectCell, forCellWithReuseIdentifier:projectCellViewIdentifier)
    }
    
    func addTextField(textField: UITextField!){
        self.newProjectTextfield = textField
    }
    
    func newProjectEntered(alert: UIAlertAction!){
        let projectName:String = self.newProjectTextfield!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        var error:String? = nil
        if (countElements(projectName) == 0) {
            error = "Invalid name"
            
        } else if (ProjectManager.sharedInstance.projectExists(projectName)) {
            error = "Project already exists"
            
        } else {
            var project = Project(projectName:projectName)
            if (ProjectManager.sharedInstance.saveProject(project)) {
                self.selectedProject = project
                self.performSegueWithIdentifier("openProject", sender: self)
            } else {
                error = "Invalid name"
            }
        }
        if (error != nil) {
            var alert = UIAlertController(title: "Project", message:error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func deleteProject(alert: UIAlertAction!){
        self.projects.removeObject(self.selectedProject!)
        var error: NSError? = nil
        if(ProjectManager.sharedInstance.removeProject(self.selectedProject!, error: &error)) {
            self.collectionView.reloadData()
        }
        self.selectedProject = nil
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.projects = NSMutableArray(array: ProjectManager.sharedInstance.allProjects())
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var collectionViewCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(projectCellViewIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        if (collectionViewCell.selected) {
            collectionViewCell.backgroundColor = UIColor.orangeColor()
        } else {
            collectionViewCell.backgroundColor = UIColor.grayColor()
        }
        
        let project:Project = (projects.objectAtIndex(indexPath.row) as Project)
        let projectNameLabel:UILabel = collectionViewCell.viewWithTag(projectNameLabelTag) as UILabel
        projectNameLabel.text = project.projectName
        
        let previewView:UIImageView = collectionViewCell.viewWithTag(projectBackgroundViewTag) as UIImageView
        previewView.image = project.preview
    
        return collectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let datasetCell = collectionView.cellForItemAtIndexPath(indexPath)
        datasetCell?.backgroundColor = UIColor.orangeColor()
        
        if (projects.count > indexPath.row) {
            self.selectedProject = self.projects.objectAtIndex(indexPath.row) as? Project
        } else {
            self.selectedProject = nil
        }

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let datasetCell = collectionView.cellForItemAtIndexPath(indexPath)
        datasetCell?.backgroundColor = UIColor.grayColor()
    }
    
    @IBAction func removeProject(AnyObject) {
        if (self.selectedProject != nil) {
            
            var deleteAlertController = UIAlertController(title: "Delete?", message:"Are you sure you want to delete this project?", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            deleteAlertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: deleteProject))
            self.presentViewController(deleteAlertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func addProject(AnyObject) {
        let newProjectAlertController = UIAlertController(title: "New Project", message: "Insert the project name:", preferredStyle: UIAlertControllerStyle.Alert)
        newProjectAlertController.addTextFieldWithConfigurationHandler(addTextField)
        newProjectAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        newProjectAlertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: newProjectEntered))
        presentViewController(newProjectAlertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "openProject" {
            if (self.selectedProject != nil) {
                let editViewController = segue.destinationViewController as EditViewController
                editViewController.project = self.selectedProject!
            }
        }
    }
}

