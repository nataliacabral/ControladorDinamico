//
//  RouletteSpin.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 11/17/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class RouletteSpin : SKSpriteNode, Touchable, ModulatorNode
{
    var startRotationPoint:CGPoint?
    let rouletteSpinTexture:SKTexture = SKTexture(imageNamed: "roulette_spinningpart.png")

    override init()
    {
        super.init()
        self.texture = rouletteSpinTexture
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    func touchStarted(position:CGPoint)
    {
        startRotationPoint = self.scene!.convertPoint(position, toNode:self.parent!)
        self.physicsBody?.angularVelocity = 0

    }

     func touchMoved(position: CGPoint) {
        let translation:CGPoint = position;
                var convertedPoint = self.convertPoint(translation, toNode:self.parent!)
        var x:CGFloat = 0
        var y:CGFloat = 0
        // Rotacao em cima, x é positivo para direita
        if (self.startRotationPoint?.y > self.size.height / 2) {
            x = -translation.x
        }
        else {
            x = translation.x
        }
        if (self.startRotationPoint?.x > self.size.width / 2) {
            y = translation.y
        }
        else {
            y = -translation.y
        }
        var higherValue:CGFloat = 0
        if (abs(x) > abs(y)) {
            higherValue = x
        }
        else {
            higherValue = y
        }
        self.physicsBody?.applyAngularImpulse(higherValue / 800)
        
        let maxVelocity:CGFloat = 40
        if (self.physicsBody?.angularVelocity > maxVelocity) {
            self.physicsBody?.angularVelocity = maxVelocity
        } else if (self.physicsBody?.angularVelocity < -maxVelocity) {
            self.physicsBody?.angularVelocity = -maxVelocity
        }
    }
    
    func touchEnded(position: CGPoint) {
        startRotationPoint = nil
    }
    
    func setModule(module:Float)
    {
        let modulatorParent:ModulatorNode = self.parent as ModulatorNode
        modulatorParent.setModule(module)
    }
    
    func addModulator(modulator:Modulator) {
        let modulatorParent:ModulatorNode = self.parent as ModulatorNode
        modulatorParent.addModulator(modulator)
    }
}