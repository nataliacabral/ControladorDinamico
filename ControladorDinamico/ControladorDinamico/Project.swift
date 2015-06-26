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
    
    enum Note : Int {
        case C = 0, CSharp, D, DSharp, E, F, FSharp, G, GSharp, A, ASharp, B
        
        static let count:Int = B.rawValue + 1

        func simpleDescription() -> String {
            switch self {
            case .C:
                return "C"
            case .CSharp:
                return "C#"
            case .D:
                return "D"
            case .DSharp:
                return "D#"
            case .E:
                return "E"
            case .F:
                return "F"
            case .FSharp:
                return "F#"
            case .G:
                return "G"
            case .GSharp:
                return "G#"
            case .A:
                return "A"
            case .ASharp:
                return "A#"
            case .B:
                return "B"
            }
        }
    }
    
    var projectName:String?
    var note:Note?
    var mode:Mode?

    var objects:Array<SoundObject>
    var image:UIImage?
    
    var preview:UIImage {
        get {
            if self.image == nil { return UIImage(named: "edit_empty.jpg")! }
            return self.image!
        }
    }
    
    override init () {
        self.objects = Array<SoundObject>()
        super.init()
    }
    
    init(projectName:String, note:Note, mode:Mode) {
        self.projectName = projectName
        self.objects = Array<SoundObject>()
        self.note = note
        self.mode = mode
        super.init()
    }
    
    init(projectName:String, objects:Array<SoundObject>, image:UIImage?, note:Note, mode:Mode) {
        self.projectName = projectName
        self.objects = objects
        self.note = note
        self.mode = mode
        super.init()
        self.image = image
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var name:String = aDecoder.decodeObjectForKey("projectName") as String
        var image:UIImage?
        if (aDecoder.containsValueForKey("image")) {
            image = aDecoder.decodeObjectForKey("image") as? UIImage
        }
        var objectList:Array<SoundObject> = aDecoder.decodeObjectForKey("objects") as Array<SoundObject>
        var projectNote:Int = aDecoder.decodeIntegerForKey("note")
        var projectMode:String = aDecoder.decodeObjectForKey("mode") as String
        self.init(projectName:name, objects:objectList, image:image, note:Note(rawValue: projectNote)!, mode:Mode(rawValue:projectMode)!)
    }
    
    

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.projectName, forKey: "projectName")
        aCoder.encodeObject(self.objects, forKey: "objects")
        aCoder.encodeInteger(self.note!.rawValue, forKey: "note")
        aCoder.encodeObject(self.mode!.rawValue, forKey: "mode")
        
        if (self.image != nil) {
            aCoder.encodeObject(self.image, forKey: "image")
        }
    }
}
