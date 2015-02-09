//
//  HorizontalSliderHandle.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 1/11/15.
//  Copyright (c) 2015 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class HorizontalSliderHandle : SKSpriteNode, Touchable
{
    let distanceToSnap:CGFloat = 5.0
    let handlerHeightBorder:CGFloat = 12
    
    let sliderHandleTexture:SKTexture = SKTexture(imageNamed: "slider_horizontal_handle.png")
    
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
        self .updatePosition(position)
    }
    
    func touchMoved(position:CGPoint)
    {
        self .updatePosition(position)
    }
    
    func updatePosition(position:CGPoint)
    {
        let parent = self.parent as SKSpriteNode
        let rightLimit = (parent.size.width / 2) - handlerHeightBorder + self.size.width / 2
        let leftLimit = (-parent.size.width / 2) + handlerHeightBorder + self.size.width / 2
        
        var relativePosition:CGPoint = self.scene!.convertPoint(position, toNode: self.parent!)
        self.position.x = relativePosition.x
        
        if (self.position.x < leftLimit) {
            self.position.x = leftLimit
        }
        
        if (self.position.x + self.size.width > rightLimit) {
            self.position.x = rightLimit - self.size.width
        }
        
        if (fabs(self.position.x) < distanceToSnap) {
            self.position.x = 0
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
        
        let rightLimit = (parent.size.width / 2) - handlerHeightBorder + self.size.width / 2
        let leftLimit = (-parent.size.width / 2) + handlerHeightBorder + self.size.width / 2
        
        var ratio:CGFloat = (self.position.x  - leftLimit) / (rightLimit - leftLimit)
        
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