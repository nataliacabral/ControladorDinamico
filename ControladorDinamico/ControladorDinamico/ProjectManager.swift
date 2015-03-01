//
//  ProjectManager.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 10/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

class ProjectManager {
    let documentsPath : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as String
    let fileManager : NSFileManager = NSFileManager.defaultManager()

    class var sharedInstance: ProjectManager {
        struct Static {
            static var instance: ProjectManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ProjectManager()
        }
        
        return Static.instance!
    }
    
    func saveProject(project: Project) -> Bool {
        if (project.projectName != nil) {
            NSLog("Saving project %@", project.projectName!)
            let fullName:String = project.projectName!.stringByAppendingPathExtension("txt")!
            let destinationPath:String = documentsPath.stringByAppendingPathComponent(fullName)
            
            return NSKeyedArchiver.archiveRootObject(project, toFile:destinationPath)
        }
        return false;
    }
    
    func projectWithName(name: NSString) -> Project?
    {
        var allProjects:NSArray = self.allProjects()
        for project in allProjects {
            if (project.projectName != nil) {
                let projectName:NSString = project.projectName!!
                if (projectName.isEqualToString(name)) {
                    NSLog("Loading project %@", projectName)
                    return project as? Project
                }
            }
        }
        return nil
    }
    
    func allProjects() -> Array<Project> {
        
        var projects:Array<Project> = Array()
        var error: NSError? = nil
        let contents = fileManager.contentsOfDirectoryAtPath(documentsPath, error: &error)
        
        if contents != nil {
            let filenames = contents as [String]
            for name in filenames {
                let filePath:String = documentsPath.stringByAppendingPathComponent(name)
                let project:Project =  NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as Project
                projects.append(project)
            }
        }
        
        return projects
    }
    
    func projectExists(name : String) -> Bool
    {
        var projectName:String = name.stringByAppendingPathExtension("txt")!
        let projectPath:String = documentsPath.stringByAppendingPathComponent(projectName)
        return fileManager.fileExistsAtPath(projectPath)
    }
    
    func removeProject(project : Project, error:NSErrorPointer) -> Bool {
        if (project.projectName != nil) {
            let projectName:String = project.projectName!.stringByAppendingPathExtension("txt")!
            let projectPath:String = documentsPath.stringByAppendingPathComponent(projectName)
            
            if(fileManager.fileExistsAtPath(projectPath)){
                return fileManager.removeItemAtPath(projectPath, error: error)
            }
        }
    return false
    }
}