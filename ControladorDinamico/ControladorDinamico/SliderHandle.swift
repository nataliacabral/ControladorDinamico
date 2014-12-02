//
//  SliderHandle.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/16/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SliderHandle : SKSpriteNode, Touchable
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
        NSLog("Slider intensity: %f", self.currentSoundIntensity())
    }
    
    func touchEnded(position:CGPoint)
    {
    }
    
    func touchCancelled(position: CGPoint) {
        self.touchEnded(position)
    }
    
    func currentSoundIntensity() -> Float
    {
        let parent = self.parent as SKSpriteNode
        let topLimit = (parent.size.height / 2) - handlerHeightBorder - (self.size.height / 2)
        let bottomLimit = -(parent.size.height / 2) + handlerHeightBorder + (self.size.height / 2)
        var ratio:CGFloat = (self.position.y  - bottomLimit) / (topLimit - bottomLimit)
        
        if (ratio < 0) {
            ratio = 0.0;
        }
        if (ratio > 1.0){
            ratio = 1.0;
        }
        let currentSoundIntensity = Float(ratio)
        
        return currentSoundIntensity
    }

}