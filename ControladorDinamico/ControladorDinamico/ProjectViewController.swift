//
//  ViewController.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 23/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import UIKit

protocol NewProjectDelegate {
    func addNewProject(name:String, note:Project.Note, mode:Project.Mode)
}

class ProjectViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, NewProjectDelegate {
    
    let grayColor = UIColor(red: 230 / 255, green: 231 / 255, blue: 232 / 255, alpha: 1)
    @IBOutlet var projectsCarouselView:iCarousel!
    @IBOutlet var projectNameLabel:UILabel!
    @IBOutlet var projectNoteLabel:UILabel!

    var addingProject:Bool = false
    var selectedProject:Project?
    var projects:Array<Project> = Array()
    let newProjectViewController:NewProjectViewController = NewProjectViewController()

    override func viewDidLoad() {
        projectsCarouselView.type = .CoverFlow2
        projectsCarouselView.centerItemWhenSelected = true
        self.newProjectViewController.delegate = self
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        if (addingProject) {
            return projects.count + 1
        } else {
            return projects.count
        }
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView!
    {
        if (index < self.projects.count) {
            var imageView: UIImageView! = nil
            if (view == nil) {
                view = UIView(frame: CGRectMake(0, 0, 400, 300))
                
                imageView = UIImageView(frame:CGRectMake(0, 0, 400, 300))
                imageView.tag = 1
                view.addSubview(imageView)
            }
            else {
                imageView = view.viewWithTag(1) as UIImageView!
            }
            
            let project:Project = projects[index]
            if (project.preview != nil) {
                imageView.image = projects[index].preview!
            } else {
                imageView.image = UIImage(named: "tocada_background")
            }
        
        } else {
            view =  NSBundle.mainBundle().loadNibNamed("NewProjectView", owner: newProjectViewController, options: nil)[0] as UIView
        }
        
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 4
            
        } else if (option == .)
        {
            return value * 4
        }
        return value
    }
    
    func deleteProject(alert: UIAlertAction!){
        if (self.selectedProject != nil) {
            var index = find(self.projects, self.selectedProject!)
            self.projects.removeAtIndex(index!)
            
            var error: NSError? = nil
            if(ProjectManager.sharedInstance.removeProject(self.selectedProject!, error: &error)) {
                self.projectsCarouselView.removeItemAtIndex(index!, animated: true)
                self.updateProjectDetails()
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.projects = ProjectManager.sharedInstance.allProjects()
        self.selectedProject = nil
        self.addingProject = false
        self.reloadCarousel()
        self.projectsCarouselView.scrollToItemAtIndex(self.projectsCarouselView.currentItemIndex, animated: false)
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        if (self.selectedProject != nil) {
            self.performSegueWithIdentifier("openProject", sender: self)
        }
    }
    
    func updateProjectDetails()
    {
        let index = self.projectsCarouselView.currentItemIndex
        
        if (index >= 0 && index < self.projects.count) {
            self.selectedProject = self.projects[index]
            self.projectNameLabel.text = self.selectedProject?.projectName
            
            self.projectNoteLabel.text = self.selectedProject!.note!.simpleDescription()
            
            if (self.selectedProject!.mode! == Project.Mode.m) {
                self.projectNoteLabel.text = self.projectNoteLabel.text! + String(self.selectedProject!.mode!.rawValue)
            }
        } else {
            self.selectedProject = nil
            self.projectNoteLabel.text = ""
            self.projectNoteLabel.text = ""
        }
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!)
    {
        self.updateProjectDetails()
    }

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
    
    @IBAction func addProject(AnyObject) {
        if (!addingProject) {
            self.addingProject = true
            self.reloadCarousel()
            self.projectsCarouselView.scrollToItemAtIndex(self.projects.count, animated: true)
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
    
    func addNewProject(name:String, note:Project.Note, mode:Project.Mode) {

        var project:Project = Project(projectName: name, note: note, mode: mode)
        ProjectManager.sharedInstance.saveProject(project)
        self.projects.append(project)
        self.addingProject = false
        self.reloadCarousel()
    }
    
    func reloadCarousel()
    {
        self.projectsCarouselView.reloadData()
        self.updateProjectDetails()
    }
}

