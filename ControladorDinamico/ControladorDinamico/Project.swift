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
    enum Mode : String {
        case M = "M"
        case m = "m"
        
        static let allValues = [M, m]
    }
    
    enum Note : String {
        case C = "C"
        case CSharp = "C#"
        case D = "D"
        case DSharp = "D#"
        case E = "E"
        case F = "F"
        case FSharp = "F#"
        case G = "G"
        case GSharp = "G#"
        case A = "A"
        case ASharp = "A#"
        case B = "B"
        
        static let allValues = [C, CSharp, D, DSharp, E, F, FSharp, G, GSharp, A, ASharp, B]
    }
    
    var projectName:String?
    var note:Note?
    var mode:Mode?

    var objects:Array<SoundObject>
    var preview:UIImage

    override init () {
        self.objects = Array<SoundObject>()
        self.preview = UIImage()
        super.init()
    }
    
    init(projectName:String, note:Note, mode:Mode) {
        self.projectName = projectName
        self.objects = Array<SoundObject>()
        self.preview = UIImage()
        self.note = note
        self.mode = mode
        super.init()
    }
    
    init(projectName:String, objects:Array<SoundObject>, image:UIImage, note:Note, mode:Mode) {
        self.projectName = projectName
        self.objects = objects
        self.preview = image
        self.note = note
        self.mode = mode
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var name:String = aDecoder.decodeObjectForKey("projectName") as String
        var image:UIImage = aDecoder.decodeObjectForKey("image") as UIImage
        var objectList:Array<SoundObject> = aDecoder.decodeObjectForKey("objects") as Array<SoundObject>
        var projectNote:String = aDecoder.decodeObjectForKey("note") as String
        var projectMode:String = aDecoder.decodeObjectForKey("mode") as String
        
        self.init(projectName:name, objects:objectList, image:image, note:Note(rawValue: projectNote)!, mode:Mode(rawValue:projectMode)!)

    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.projectName, forKey: "projectName")
        aCoder.encodeObject(self.objects, forKey: "objects")
        aCoder.encodeObject(self.preview, forKey: "image")
        aCoder.encodeObject(self.note!.rawValue, forKey: "note")
        aCoder.encodeObject(self.mode!.rawValue, forKey: "mode")
    }
}
