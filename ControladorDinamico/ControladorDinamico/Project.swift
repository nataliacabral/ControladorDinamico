//
//  Project.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 03/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

class Project : NSObject
{
    var projectName:NSString
    var objects:NSArray
    
    init(projectName:NSString, objects:NSArray) {
        self.projectName = projectName
        self.objects = objects
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var name:NSString = aDecoder.decodeObjectForKey("projectName") as String
        var objectList:NSArray = aDecoder.decodeObjectForKey("objects") as NSArray
        self.init(projectName:name, objects:objectList)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.projectName, forKey: "projectName")
        aCoder.encodeObject(self.objects, forKey: "objects")
    }
}
