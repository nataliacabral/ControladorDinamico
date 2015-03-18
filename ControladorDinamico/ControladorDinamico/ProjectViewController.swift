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
    @IBOutlet var projectNameLabel:UILabel!
    @IBOutlet var projectNoteLabel:UILabel!

    
    var selectedProject:Project?
    var projects:Array<Project> = Array()
    
    override func viewDidLoad() {

        projectsCarouselView.type = .CoverFlow2
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        return projects.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView!
    {
        var imageView: UIImageView! = nil

        if (view == nil)
        {
            view = UIView(frame: CGRectMake(0, 0, 400, 300))
            
            imageView = UIImageView(frame:CGRectMake(0, 0, 400, 300))
            imageView.tag = 1
            view.addSubview(imageView)
            view.backgroundColor = UIColor.redColor()
        }
        else
        {
            imageView = view.viewWithTag(1) as UIImageView!
        }
        
        imageView.image = projects[index].preview
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 4
        }
        return value
    }
    
    func deleteProject(alert: UIAlertAction!){
        var index = find(self.projects, self.selectedProject!)
        self.projects.removeAtIndex(index!)
        
        var error: NSError? = nil
        if(ProjectManager.sharedInstance.removeProject(self.selectedProject!, error: &error)) {
            self.projectsCarouselView.removeItemAtIndex(index!, animated: true)
            self.updateProjectDetails()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.projects = ProjectManager.sharedInstance.allProjects()
        self.projectsCarouselView.reloadData()
        self.selectedProject = nil
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
        let projectnumber = self.projects.count +  1
        let projectName:String = String(format: "teste %i", projectnumber)
        var project:Project = Project(projectName: projectName, note: Project.Note.A, mode: Project.Mode.M)
        ProjectManager.sharedInstance.saveProject(project)
        self.projects.append(project)
        self.projectsCarouselView.reloadData()
        self.projectsCarouselView.scrollToItemAtIndex(self.projects.count - 1, animated: true)
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

