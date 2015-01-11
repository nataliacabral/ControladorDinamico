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
    var lastRotationPoint:CGPoint?
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
    
    func moveToPosition(position:CGPoint)
    {
        // Valor obtido atraves de calculos aleatorios
        self.zRotation = atan2(position.y, position.x) - CGFloat(M_PI_2)
    }
    
    func touchStarted(position:CGPoint)
    {
        lastRotationPoint = position
        let convertedPoint = self.scene!.convertPoint(position, toNode:self.parent!)
        self.moveToPosition(convertedPoint)
        self.physicsBody?.angularVelocity = 0
    }
    
    func touchMoved(position: CGPoint) {
        lastRotationPoint = position;
        let convertedPoint = self.scene!.convertPoint(position, toNode:self.parent!)
        self.moveToPosition(convertedPoint)
     }
    
    func touchEnded(position: CGPoint) {
        var difference = CGPoint(x:position.x - lastRotationPoint!.x, y:position.y - lastRotationPoint!.y)
        var convertedPoint = self.scene!.convertPoint(position, toNode:self.parent!)
        
        var impulse = CGFloat(0)
        
        /*
        |
        |
        Q1     |      Q4
        |
        -------------------------
        |
        Q2     |      Q3
        |
        |
        
        */
        
        // Magic calculations below, that may or may not have something to do with the quadrants above
        
        if (convertedPoint.x < 0 && convertedPoint.y >= 0) {
            // Q1
            impulse += -difference.x
            impulse += -difference.y
        }
        else if (convertedPoint.x < 0 && convertedPoint.y < 0) {
            // Q2
            impulse += difference.x
            impulse += -difference.y
        }
        else if (convertedPoint.x >= 0 && convertedPoint.y < 0) {
            // Q3
            impulse += difference.x
            impulse += difference.y
        }
        else if (convertedPoint.x >= 0 && convertedPoint.y >= 0) {
            // Q4
            impulse += -difference.x
            impulse += difference.y
        }
        
        impulse = impulse / 5
        self.physicsBody?.applyAngularImpulse(impulse)
        
        let maxVelocity:CGFloat = 50
        if (self.physicsBody?.angularVelocity > maxVelocity) {
            self.physicsBody?.angularVelocity = maxVelocity
        } else if (self.physicsBody?.angularVelocity < -maxVelocity) {
            self.physicsBody?.angularVelocity = -maxVelocity
        }

        lastRotationPoint = nil
    }
    
    func touchCancelled(position: CGPoint) {
        self.touchEnded(position)
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