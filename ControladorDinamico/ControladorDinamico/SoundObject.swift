//
//  SoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class SoundObject: SKSpriteNode, NSCoding, NSCopying, Touchable
{
    var iconImageName:String?
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
    
    init(size:CGSize) {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.position.x = CGFloat(aDecoder.decodeObjectForKey("x")!.floatValue)
        self.position.y = CGFloat(aDecoder.decodeObjectForKey("y")!.floatValue)
        self.size.width = CGFloat(aDecoder.decodeObjectForKey("width")!.floatValue)
        self.size.height = CGFloat(aDecoder.decodeObjectForKey("height")!.floatValue)
    }
    
    init(gridSize:CGFloat) {
        super.init()
        self.updateGridSize(gridSize)
    }
    
    func startPhysicalBody() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = false
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.position.x, forKey: "x")
        aCoder.encodeObject(self.position.y, forKey: "y")
        aCoder.encodeObject(self.size.width, forKey: "width")
        aCoder.encodeObject(self.size.height, forKey: "height")
    }
    
    func updateGridSize(gridSize:CGFloat)
    {
        self.size = CGSize(width: gridWidth * gridSize - 1, height: gridHeight * gridSize - 1)
    }
    
    func currentSoundIntensity() -> Float
    {
        return 0;
    }
    
    func touchStarted(position:CGPoint)
    {
    }
    
    func touchEnded(position:CGPoint)
    {
    }
    
    func touchMoved(position:CGPoint)
    {
    }
    
    func touchCancelled(position: CGPoint) {
        self.touchEnded(position)
    }
    
    func update(currentTime: NSTimeInterval)
    {
    }
    
    func playObject() -> SoundObject
    {
        return SoundObject()
    }
    func saveStatus(slot:Int)
    {
        
    }
    func loadStatus(slot:Int)
    {
        
    }
}

