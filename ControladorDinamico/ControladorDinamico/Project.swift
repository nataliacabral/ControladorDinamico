//
//  Project.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 03/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import UIKit

class Project : NSObject
{
    var projectName:NSString?
    var objects:Array<SoundObject>
    var preview:UIImage

    override init () {
        self.objects = Array<SoundObject>()
        self.preview = UIImage()
        super.init()
    }
    
    init(projectName:NSString) {
        self.projectName = projectName
        self.objects = Array<SoundObject>()
        self.preview = UIImage()
        super.init()
    }
    
    init(projectName:NSString, objects:Array<SoundObject>, image:UIImage) {
        self.projectName = projectName
        self.objects = objects
        self.preview = image
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var name:NSString = aDecoder.decodeObjectForKey("projectName") as String
        var image:UIImage = aDecoder.decodeObjectForKey("image") as UIImage
        var objectList:Array<SoundObject> = aDecoder.decodeObjectForKey("objects") as Array<SoundObject>
        self.init(projectName:name, objects:objectList, image:image)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.projectName, forKey: "projectName")
        aCoder.encodeObject(self.objects, forKey: "objects")
        aCoder.encodeObject(self.preview, forKey: "image")
    }
}
