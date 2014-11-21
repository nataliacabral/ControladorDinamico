//
//  SliderHandle.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/16/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit

class SliderHandle : SKSpriteNode, Touchable
{
    let handlerHeightBorder:CGFloat = 20

    override init()
    {
        super.init()
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
        let topLimit = parent.size.height - handlerHeightBorder
        let bottomLimit = handlerHeightBorder

        var relativePosition:CGPoint = self.parent!.parent!.convertPoint(position, toNode: self.parent!)
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
    }
    
    func currentSoundIntensity() -> UInt32
    {
        var relativePosition:CGPoint = self.parent!.parent!.convertPoint(self.position, fromNode: self.parent!)
        let ratio:CGFloat = relativePosition.y / self.parent!.frame.size.height
        let currentSoundIntensity : UInt32 = UInt32(ratio * 127)
        
        return currentSoundIntensity
    }

}