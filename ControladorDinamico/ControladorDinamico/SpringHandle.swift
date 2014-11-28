//
//  SpringHandle.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 11/26/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SpringHandle : SKSpriteNode, Touchable
{
    let handlerHeightBorder:CGFloat = 12
    let sliderHandleTexture:SKTexture = SKTexture(imageNamed: "sliderHandle.png")
    
    override init()
    {
        super.init()
        self.texture = sliderHandleTexture
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init()
    }
    
    func touchStarted(position:CGPoint)
    {
    }
    
    func touchMoved(position:CGPoint)
    {
        let parent = self.parent as SKSpriteNode
        let topLimit = (parent.size.height / 2) - handlerHeightBorder + self.size.height / 2
        let bottomLimit = (-parent.size.height / 2) + handlerHeightBorder + self.size.height / 2
        
        var relativePosition:CGPoint = self.scene!.convertPoint(position, toNode: self.parent!)
        self.position.y = relativePosition.y
        
        if (self.position.y < bottomLimit) {
            self.position.y = bottomLimit
        }
        
        if (self.position.y + self.size.height > topLimit) {
            self.position.y = topLimit - self.size.height
        }
    }
    
    func touchEnded(position:CGPoint)
    {
       self.physicsBody!.applyForce(CGVector(dx: 0, dy: 100))
    }
    
    func currentSoundIntensity() -> Float
    {
        let parent = self.parent as SKSpriteNode
        let topLimit = (parent.size.height / 2) - handlerHeightBorder - (self.size.height / 2)
        let bottomLimit = -(parent.size.height / 2) + handlerHeightBorder - (self.size.height / 2)
        let ratio:CGFloat = (self.position.y  - bottomLimit) / (topLimit - bottomLimit)
        
        let currentSoundIntensity = Float(ratio)
        
        return currentSoundIntensity
    }
    

    
}