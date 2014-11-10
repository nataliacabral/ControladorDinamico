//
//  SoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SoundObject: SKSpriteNode, NSCoding
{
    var horizontalGridSlots:UInt = 0
    var verticalGridSlots:UInt = 0
    var gridPosition:CGPoint = CGPoint()
    var imageName:String = ""
    
    init(imageName:String, horizontalGridSlots:UInt, verticalGridSlots:UInt, initialGridPosition:CGPoint) {
        self.horizontalGridSlots = horizontalGridSlots
        self.verticalGridSlots = verticalGridSlots
        self.gridPosition = initialGridPosition
        self.imageName = imageName
        var texture:SKTexture = SKTexture(imageNamed: imageName)
        super.init(texture:texture, color: UIColor(), size: texture.size())
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var imgName:NSString = aDecoder.decodeObjectForKey("imageName") as String
        self.init(imageName:imgName, horizontalGridSlots:0, verticalGridSlots:0, initialGridPosition:CGPoint(x: 0, y: 0))
        self.position.x = CGFloat(aDecoder.decodeObjectForKey("x")!.integerValue)
        self.position.y = CGFloat(aDecoder.decodeObjectForKey("y")!.integerValue)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.imageName, forKey: "imageName")
        aCoder.encodeObject(self.position.x, forKey: "x")
        aCoder.encodeObject(self.position.y, forKey: "y")
    }
}
