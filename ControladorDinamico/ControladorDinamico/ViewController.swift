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

    var deleteProjectAlert:UIAlertView?
    var newProjectAlert:UIAlertView?
    
    var selectedProject:Project?
    var projects:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        
        newProjectAlert = UIAlertView(title: "New project", message: "Insert the project name:", delegate:self, cancelButtonTitle: "Cancel", otherButtonTitles:"Save")
        newProjectAlert!.alertViewStyle = UIAlertViewStyle.PlainTextInput;

        deleteProjectAlert = UIAlertView(title: "Delete?", message: "Are you sure you want to delete this project?", delegate:self, cancelButtonTitle: "No", otherButtonTitles:"Yes")

        var projectCell:UINib = UINib(nibName:"ProjectView", bundle: nil)
        self.collectionView.registerNib(projectCell, forCellWithReuseIdentifier:projectCellViewIdentifier)
        
        var longPresGestureRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPresGestureRecognizer.minimumPressDuration = 0.5
        longPresGestureRecognizer.delegate = self
        longPresGestureRecognizer.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPresGestureRecognizer)

    }
    
    func handleLongPress(gestureRecognizer:UILongPressGestureRecognizer)
    {
        var cell:UICollectionViewCell?
        var touchedProject:Project?

        let point:CGPoint = gestureRecognizer.locationInView(self.collectionView)
        let indexPath:NSIndexPath? = self.collectionView.indexPathForItemAtPoint(point)
        
        if (indexPath != nil) {
            cell = self.collectionView.cellForItemAtIndexPath(indexPath!)
        
            if (indexPath!.row < self.projects.count) {
                touchedProject = self.projects[indexPath!.row] as? Project
            }
        }
        
        switch gestureRecognizer.state {
        case .Began:
            if (cell != nil) {
                cell!.backgroundColor = UIColor.grayColor()
                if (touchedProject != nil) {
                    self.selectedProject = touchedProject
                }
            }
            
            break
        case .Changed, .Ended:
            if (cell != nil) {
                cell!.backgroundColor = UIColor.blackColor()
                if (self.selectedProject != nil) {
                    deleteProjectAlert!.show()
                }
            }
            break
        
        default:
            break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.projects = NSMutableArray(array: ProjectManager.sharedInstance.allProjects())
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count + 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var collectionViewCell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(projectCellViewIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        collectionViewCell.backgroundColor = UIColor.blackColor()
       
        if (indexPath.row < projects.count) {
            let project:Project = (projects.objectAtIndex(indexPath.row) as Project)
            let projectNameLabel:UILabel = collectionViewCell.viewWithTag(projectNameLabelTag) as UILabel
            projectNameLabel.text = project.projectName
            
            let previewView:UIImageView = collectionViewCell.viewWithTag(projectBackgroundViewTag) as UIImageView
            previewView.image = project.preview
            return collectionViewCell
        
        } else {
            
            let projectNameLabel:UILabel = collectionViewCell.viewWithTag(projectNameLabelTag) as UILabel
            projectNameLabel.text = "+"
            let previewView:UIImageView = collectionViewCell.viewWithTag(projectBackgroundViewTag) as UIImageView
            previewView.image = nil
            return collectionViewCell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (projects.count > indexPath.row) {
            self.selectedProject = self.projects.objectAtIndex(indexPath.row) as? Project
            self.performSegueWithIdentifier("openProject", sender: self)
        } else {
           let operation =  NSOperation()
                self.newProjectAlert!.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView == deleteProjectAlert) {

            if (buttonIndex == 1) {
                self.projects.removeObject(self.selectedProject!)
                var error: NSError? = nil
                if(ProjectManager.sharedInstance.removeProject(self.selectedProject!, error: &error)) {
                    self.collectionView.reloadData()
                }
             }
        } else if (alertView == newProjectAlert) {
        
            let textField : UITextField? = alertView.textFieldAtIndex(0)
            if (buttonIndex == 1) {
                let projectName:String = textField!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
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
            
            textField!.text = ""
        }
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

