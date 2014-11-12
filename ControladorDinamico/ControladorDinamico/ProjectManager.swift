//
//  ProjectManager.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 10/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

class ProjectManager {
    let documentsPath : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as NSString
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
        
        let fullName:NSString = project.projectName.stringByAppendingPathExtension("txt")!
        let destinationPath:NSString = documentsPath.stringByAppendingPathComponent(fullName)
        
        return NSKeyedArchiver.archiveRootObject(project, toFile:destinationPath)
    }
    
    func allProjects() -> NSArray {
        
        var projects:NSMutableArray = NSMutableArray()
        var error: NSError? = nil
        let contents = fileManager.contentsOfDirectoryAtPath(documentsPath, error: &error)
        
        if contents != nil {
            let filenames = contents as [String]
            for name in filenames {
                let filePath:NSString = documentsPath.stringByAppendingPathComponent(name)
                let project:Project =  NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as Project
                projects.addObject(project)
            }
        }
        
        return projects
    }
    
    func removeProject(project : Project, error:NSErrorPointer) -> Bool {
        let projectName:NSString = project.projectName.stringByAppendingPathExtension("txt")!
        let projectPath:NSString = documentsPath.stringByAppendingPathComponent(projectName)
        
        if(fileManager.fileExistsAtPath(projectPath)){
            return fileManager.removeItemAtPath(projectPath, error: error)
        }

    return false
    }
}