//
//  RouletteSpin.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 11/17/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class RouletteSpin : SKSpriteNode, Pannable
{
    var startRotationPoint:CGPoint?
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    func panStarted(position:CGPoint) {
        startRotationPoint = self.parent!.parent!.convertPoint(position, toNode:self.parent!)

    }
 
    func panMoved(translation:CGPoint) {
        var convertedPoint = self.convertPoint(translation, toNode:self.parent!)
//        // Valida se a direcao mudou. Se mudou, paramos o objeto (mudando velocidade vertical para 0)
//        if (self.physicsBody?.velocity.dy > 0 && translation.y < 0 ||
//            self.physicsBody?.velocity.dy < 0 && translation.y > 0) {
//                self.physicsBody?.velocity.dy = 0
//        }
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
        self.physicsBody?.applyAngularImpulse(higherValue / 20)

        //self.physicsBody?.angularVelocity = 80
    }
    func panEnded() {
        startRotationPoint = nil
    }
}