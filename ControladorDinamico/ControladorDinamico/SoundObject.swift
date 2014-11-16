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
    var gridHeight:CGFloat { get { return 0 } }
    var gridWidth:CGFloat { get { return 0 } }
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    func initializeProperties()
    {
        var texture:SKTexture = SKTexture(imageNamed: self.imageName)
        self.texture = texture
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    init(size:CGSize) {
        super.init()
        self.initializeProperties()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.initializeProperties()
        self.position.x = CGFloat(aDecoder.decodeObjectForKey("x")!.integerValue)
        self.position.y = CGFloat(aDecoder.decodeObjectForKey("y")!.integerValue)
    }
    
    init(gridSize:CGFloat) {
        super.init()
        self.initializeProperties()
        self.updateGridSize(gridSize)
    }
    
    func startPhysicalBody() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.position.x, forKey: "x")
        aCoder.encodeObject(self.position.y, forKey: "y")
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
    
    func updateGridSize(gridSize:CGFloat)
    {
        self.size = CGSize(width: gridWidth * gridSize, height: gridHeight * gridSize)
    }
}

