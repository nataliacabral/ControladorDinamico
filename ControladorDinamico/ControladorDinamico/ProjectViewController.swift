//
//  ViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 23/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    let grayColor = UIColor(red: 230 / 255, green: 231 / 255, blue: 232 / 255, alpha: 1)
    @IBOutlet var projectsCarouselView:iCarousel!
    
   /* var notePicker: UIPickerView?
    var modePicker: UIPickerView?
    var nameTextfield: UITextField?
    
    var addingProject:Bool = false
    */
    let projectCellViewIdentifier:String = "projectView"
    let newProjectCellViewIdentifier:String = "newProjectView"

    let projectNameLabelTag:Int = 10
    let projectBackgroundViewTag:Int = 20
    let projectNoteModeLabelTag:Int = 30

    let newProjectNameTextfieldTag:Int = 10
    let newProjectNotePickerTag:Int = 20
    let newProjectModePickerTag:Int = 30
    
    var selectedProject:Project?
    var projects:Array<Project> = Array()
    
    override func viewDidLoad() {

        projectsCarouselView.type = .CoverFlow2

       /* var projectCell:UINib = UINib(nibName:"ProjectView", bundle: nil)
        self.collectionView.registerNib(projectCell, forCellWithReuseIdentifier:projectCellViewIdentifier)
        
        var newProjectCell:UINib = UINib(nibName:"NewProjectViewCell", bundle: nil)
        self.collectionView.registerNib(newProjectCell, forCellWithReuseIdentifier:newProjectCellViewIdentifier)

        self.addingProject = false*/
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        return projects.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView!
    {
        var label: UILabel! = nil
        var imageView: UIImageView! = nil

        if (view == nil)
        {
        
            view = UIView(frame: CGRectMake(0, 0, 100, 100))
            imageView = UIImageView(frame:CGRectMake(0, 0, 40, 40))
            imageView.contentMode = .Center
            imageView.tag = 0
            view.addSubview(imageView)
            
            label = UILabel(frame:view.bounds)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.font = label.font.fontWithSize(50)
            label.tag = 1
            label.textColor = UIColor.whiteColor()
            view.addSubview(label)
        }
        else
        {
            label = view.viewWithTag(1) as UILabel!
            view = view.viewWithTag(0) as UIImageView!
        }
        
        label.text = projects[index].projectName
        imageView.image = projects[index].preview

        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 5
        }
        return value
    }
    
   /* func addNewProject(){
        let projectName:String = self.nameTextfield!.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        var error:String? = nil
        if (countElements(projectName) == 0) {
            error = "Invalid name"
            
        } else if (ProjectManager.sharedInstance.projectExists(projectName)) {
            error = "Project already exists"
            
        } else {
            let mode:Project.Mode = Project.Mode.allValues[self.modePicker!.selectedRowInComponent(0)]
            let note:Project.Note = Project.Note(rawValue: self.notePicker!.selectedRowInComponent(0))!

            var project = Project(projectName:projectName, note:note, mode:mode)
            if (ProjectManager.sharedInstance.saveProject(project)) {
                self.projects.append(project)
                self.selectedProject = project
                addingProject = false
                self.collectionView.reloadData()
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
    */
    func deleteProject(alert: UIAlertAction!){
        var index = find(self.projects, self.selectedProject!)
        self.projects.removeAtIndex(index!)
        
        var error: NSError? = nil
        if(ProjectManager.sharedInstance.removeProject(self.selectedProject!, error: &error)) {
            self.projectsCarouselView.reloadData()
        }
        self.selectedProject = nil
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.projects = ProjectManager.sharedInstance.allProjects()
        self.projectsCarouselView.reloadData()
        //addingProject = false
        self.selectedProject = nil
    }
    
/*
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var collectionViewCell:UICollectionViewCell
        let borderWidth:CGFloat = 2.5;

        if (indexPath.row >= projects.count) {
            
            collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(newProjectCellViewIdentifier, forIndexPath: indexPath) as UICollectionViewCell
            collectionView.backgroundColor = grayColor
            nameTextfield = collectionViewCell.viewWithTag(newProjectNameTextfieldTag) as? UITextField

            notePicker = collectionViewCell.viewWithTag(newProjectNotePickerTag) as? UIPickerView
            notePicker!.delegate = self
            notePicker!.dataSource = self
            
            modePicker = collectionViewCell.viewWithTag(newProjectModePickerTag) as? UIPickerView
            modePicker!.delegate = self
            modePicker!.dataSource = self

        } else {
            collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(projectCellViewIdentifier, forIndexPath: indexPath) as UICollectionViewCell

            if (collectionViewCell.selected) {
                collectionViewCell.backgroundColor = UIColor.orangeColor()
            } else {
                collectionViewCell.backgroundColor = grayColor
            }
            
            let project:Project = projects[indexPath.row]
            let projectNameLabel:UILabel = collectionViewCell.viewWithTag(projectNameLabelTag) as UILabel
            projectNameLabel.text = project.projectName
            
            let projectNoteLabel:UILabel = collectionViewCell.viewWithTag(projectNoteModeLabelTag) as UILabel
            projectNoteLabel.text = project.note!.simpleDescription()
                
            if (project.mode! == Project.Mode.m) {
                projectNoteLabel.text = projectNoteLabel.text! + String(project.mode!.rawValue)
            }
            
            let previewView:UIImageView = collectionViewCell.viewWithTag(projectBackgroundViewTag) as UIImageView
            previewView.image = project.preview
        }
        
        
        
        return collectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (projects.count > indexPath.row) {
            let datasetCell = collectionView.cellForItemAtIndexPath(indexPath)
            if (addingProject) {
                if (countElements(self.nameTextfield!.text!) == 0) {
                    self.addingProject = false
                    self.collectionView.reloadData()
                    self.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredVertically)
                }
            } else {
            datasetCell?.backgroundColor = UIColor.orangeColor()
            self.selectedProject = self.projects[indexPath.row]
            }
            
            
        } else if (projects.count == indexPath.row) {
            self.addNewProject()
        
        } else {
            self.selectedProject = nil
        }
        
        self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if (self.projects.count > indexPath.row) {
            let datasetCell = collectionView.cellForItemAtIndexPath(indexPath)
            datasetCell?.backgroundColor = grayColor
        }
    }
    */
    @IBAction func removeProject(AnyObject) {
        if (self.selectedProject != nil) {
            
            var deleteAlertController = UIAlertController(title: "Delete?", message:"Are you sure you want to delete this project?", preferredStyle: UIAlertControllerStyle.Alert)
            deleteAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            deleteAlertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: deleteProject))
            self.presentViewController(deleteAlertController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func openProject(AnyObject) {
        if (self.selectedProject != nil) {
            self.performSegueWithIdentifier("openProject", sender: self)
        }
    }
    
   /* @IBAction func addProject(AnyObject) {
        addingProject = true
        self.projectsCarouselView.reloadData()
        self.projectsCarouselView.scrollToItemAtIndexPath(NSIndexPath(forRow: self.projects.count, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
        
        if (nameTextfield != nil && notePicker != nil && modePicker != nil) {
            nameTextfield!.text = ""
            notePicker!.selectRow(0, inComponent:0, animated:false)
            modePicker!.selectRow(0, inComponent:0, animated:false)
        }
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "openProject" {
            if (self.selectedProject != nil) {
                let editViewController = segue.destinationViewController as EditViewController
                editViewController.project = self.selectedProject!
            }
        }
    }
    
   /* func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == newProjectNotePickerTag) {
            return Project.Note.count
        } else if (pickerView.tag == newProjectModePickerTag) {
            return Project.Mode.allValues.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var result:String = ""
        
        if (pickerView.tag == newProjectNotePickerTag) {
            result = Project.Note(rawValue:row)!.simpleDescription()
        } else if (pickerView.tag == newProjectModePickerTag) {
            result =  String(Project.Mode.allValues[row].rawValue)
        }
        
        return result
    }*/
    
    
}

