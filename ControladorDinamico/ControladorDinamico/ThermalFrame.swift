//
//  ThermalFrame.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 11/28/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class ThermalFrame : SKSpriteNode, Touchable
{
    let thermalFrameTexture:SKTexture = SKTexture(imageNamed: "thermal_frame.png")
    var touching:Bool = false
    
    let initialAlpha:CGFloat = 0.1
    let alphaRatio:CGFloat = 1.015
    
    override init()
    {
        super.init()
        self.texture = thermalFrameTexture
        self.alpha = initialAlpha
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
        touching = true
    }
    
    func touchMoved(position:CGPoint)
    {
    }
    
    func touchEnded(position:CGPoint)
    {
        touching = false
    }
    
    func currentSoundIntensity() -> Float
    {
        return Float(self.alpha);
    }
    
    func update(currentTime: NSTimeInterval)
    {
        if (touching && self.alpha < 1) {
            self.alpha = self.alpha * alphaRatio
        } else if (self.alpha - initialAlpha > 0.01) {
            self.alpha = self.alpha * (1/alphaRatio)
        }
    }
}