//
//  SoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SoundObject: SKSpriteNode, NSCoding, TouchListener, Collidable, GridBound
{
    var imageName:String = ""
    var moving:Bool = false
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(imageName:String, size:CGSize) {
        self.imageName = imageName
        var texture:SKTexture = SKTexture(imageNamed: imageName)
        super.init(texture:texture, color: UIColor(), size:size)
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        var imgName:NSString = aDecoder.decodeObjectForKey("imageName") as String
        self.init(imageName:imgName, size:CGSize(width:10,height:10))
        self.position.x = CGFloat(aDecoder.decodeObjectForKey("x")!.integerValue)
        self.position.y = CGFloat(aDecoder.decodeObjectForKey("y")!.integerValue)
        self.position.y = CGFloat(aDecoder.decodeObjectForKey("y")!.integerValue)

    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.imageName, forKey: "imageName")
        aCoder.encodeObject(self.position.x, forKey: "x")
        aCoder.encodeObject(self.position.y, forKey: "y")
    }
    
    func touchBegan()
    {
        // TODO play
    }
    func touchMoved(recognizer:UIPanGestureRecognizer)
    {
        // TODO changePos
    }
    func touchEnded()
    {
        // TODO stop playing
    }
    
    func collidesWith(otherObj: AnyObject) -> Bool
    {
        if (otherObj is SoundObject && otherObj !== self) {
            let otherSoundObj = otherObj as SoundObject
            let collides:Bool = CGPointEqualToPoint(self.position, otherObj.position)
                || (self.position.x < otherObj.position.x + otherObj.size.width &&
                self.position.x + self.size.width > otherObj.position.x &&
                self.position.y < otherObj.position.y + otherObj.size.height &&
                self.size.height + self.position.y > otherObj.position.y)
            return collides
        }
        return false
    }
}

