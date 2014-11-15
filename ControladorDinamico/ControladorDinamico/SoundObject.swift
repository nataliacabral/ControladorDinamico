//
//  SoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SoundObject: SKSpriteNode, NSCoding, NSCopying, Collidable, GridBound
{
    var imageName:String { get { return "" } }
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(size:CGSize) {
        super.init()
        var texture:SKTexture = SKTexture(imageNamed: self.imageName)
        self.texture = texture
        self.size = size
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        var texture:SKTexture = SKTexture(imageNamed: self.imageName)
        self.texture = texture
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position.x = CGFloat(aDecoder.decodeObjectForKey("x")!.integerValue)
        self.position.y = CGFloat(aDecoder.decodeObjectForKey("y")!.integerValue)
        self.size.width = CGFloat(aDecoder.decodeObjectForKey("width")!.floatValue)
        self.size.height = CGFloat(aDecoder.decodeObjectForKey("height")!.floatValue)

    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.position.x, forKey: "x")
        aCoder.encodeObject(self.position.y, forKey: "y")
        aCoder.encodeObject(self.size.width, forKey: "width")
        aCoder.encodeObject(self.size.height, forKey: "height")
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

