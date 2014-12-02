//
//  ThermalFrame.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 11/28/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class ThermalFrame : SKSpriteNode, Touchable, ModulatorNode
{
    let thermalFrameTexture:SKTexture = SKTexture(imageNamed: "thermal_frame.png")
    var touching:Bool = false
    var lastUpdateTimestamp:NSTimeInterval?;
    let alphaRatio:CGFloat = 0.008

    var modulators:Array<Modulator> = Array<Modulator>()

    
    override init()
    {
        super.init()
        self.texture = thermalFrameTexture
        self.alpha = 0
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
    func touchCancelled(position: CGPoint) {
        self.touchEnded(position)
    }
    
    func currentSoundIntensity() -> Float
    {
        return Float(self.alpha);
    }
    
    func update(currentTime: NSTimeInterval)
    {
        if (self.lastUpdateTimestamp != nil) {
            let interval:NSTimeInterval = currentTime - self.lastUpdateTimestamp!

            if (touching && self.alpha < 1) {
                self.alpha = self.alpha + CGFloat(interval)
            } else if (self.alpha > 0) {
                self.alpha = self.alpha - CGFloat(interval/2)
            }
            if (self.alpha < 0) {
                self.alpha = 0
            }
            else if (self.alpha > 1.0) {
                self.alpha = 1.0
            }
            
            for modulator in self.modulators {
                modulator.modulate(self.currentSoundIntensity())
            }
        }
        self.lastUpdateTimestamp = currentTime
    }
    
    func setModule(module:Float)
    {
        for modulator in self.modulators {
            modulator.modulate(module)
        }
    }
    
    func addModulator(modulator:Modulator) {
        self.modulators.append(modulator)
    }

}