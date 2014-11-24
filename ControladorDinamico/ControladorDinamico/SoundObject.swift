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
    var templateImageName:String { get { return "" } }
    var gridHeight:CGFloat { get { return 0 } }
    var gridWidth:CGFloat { get { return 0 } }
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        var texture:SKTexture = SKTexture(imageNamed: self.templateImageName)
        self.texture = texture
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    init(size:CGSize) {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.position.x = CGFloat(aDecoder.decodeObjectForKey("x")!.integerValue)
        self.position.y = CGFloat(aDecoder.decodeObjectForKey("y")!.integerValue)
    }
    
    init(gridSize:CGFloat) {
        super.init()
        self.updateGridSize(gridSize)
    }
    
    func startPhysicalBody() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size, center:CGPoint(x:self.size.width / 2 , y:self.size.height / 2))
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = false
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.position.x, forKey: "x")
        aCoder.encodeObject(self.position.y, forKey: "y")
    }
    
    func updateGridSize(gridSize:CGFloat)
    {
        self.size = CGSize(width: gridWidth * gridSize, height: gridHeight * gridSize)
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
}

