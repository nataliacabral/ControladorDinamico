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
    var lastUpdateTime:NSTimeInterval
    var lastRotationPoint:CGPoint?
    var secondLastRotationPoint:CGPoint?
    let rouletteSpinTexture:SKTexture = SKTexture(imageNamed: "roulette_spinningpart.png")
    
    override init()
    {
        lastUpdateTime = 0
        super.init()
        self.texture = rouletteSpinTexture
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        lastUpdateTime = 0
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        lastUpdateTime = 0
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
        let date = NSDate()
        let timestamp = date.timeIntervalSince1970
        var timeElapsed:NSTimeInterval = 0
        if (lastUpdateTime > 0) {
            timeElapsed = timestamp - lastUpdateTime
            if (timeElapsed > 0.1) {
                secondLastRotationPoint = lastRotationPoint;
                lastRotationPoint = position;
                lastUpdateTime = timestamp
            }
        }
        else {
            lastUpdateTime = timestamp
        }
        let convertedPoint = self.scene!.convertPoint(position, toNode:self.parent!)

        self.moveToPosition(convertedPoint)
    }
    
    func touchEnded(position: CGPoint) {
        let rouletteObj:RouletteSoundObject = self.parent! as RouletteSoundObject
        
        if (!rouletteObj.touchedSpin) {
            
            var point1:CGPoint? = secondLastRotationPoint
            var point2:CGPoint? = lastRotationPoint
            if (point1 == nil) {
                point1 = lastRotationPoint
                point2 = position
            }
            
            var difference = CGPoint(x:point2!.x - point1!.x, y:point2!.y - point1!.y)
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
            
            // Normalize time
            
            let date = NSDate()
            let timestamp = date.timeIntervalSince1970
            var timeElapsed:NSTimeInterval = 0
            if (lastUpdateTime > 0) {
                timeElapsed = timestamp - lastUpdateTime
            }
            
            let normalizedImpulse = Double(impulse) / 30
            self.physicsBody?.applyAngularImpulse(CGFloat(normalizedImpulse))
            NSLog("impulse %f", Float(impulse));
            NSLog("Time Elapsed %f", Float(timeElapsed));
            NSLog("normalized %f", Float(normalizedImpulse));
            
            
            
            let maxVelocity:CGFloat = 50
            if (self.physicsBody?.angularVelocity > maxVelocity) {
                self.physicsBody?.angularVelocity = maxVelocity
            } else if (self.physicsBody?.angularVelocity < -maxVelocity) {
                self.physicsBody?.angularVelocity = -maxVelocity
            }
            
            lastRotationPoint = nil
            secondLastRotationPoint = nil
            lastUpdateTime = 0
            
        }
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