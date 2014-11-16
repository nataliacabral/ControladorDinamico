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

class SliderHandle : SKSpriteNode, Pannable
{
    let handlerWidthBorder:CGFloat = 5
    let handlerHeightBorder:CGFloat = 10
    
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

    }
    func panMoved(translation:CGPoint) {
        var convertedPoint = self.convertPoint(translation, toNode:self.parent!)
        if (self.parent != nil && self.parent is SKSpriteNode) {
            let parentSprite = self.parent as SKSpriteNode
            let maximumPos = parentSprite.size.height - handlerHeightBorder
            let minimumPos = handlerHeightBorder
            var dislocation = translation.y
            if (self.position.y + dislocation < minimumPos) {
                dislocation = minimumPos - self.position.y
            }
            if (self.position.y + dislocation + self.size.height > maximumPos){
                dislocation = maximumPos - (self.position.y + self.size.height)
            }
            let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: dislocation), duration: 0.0)
            self.runAction(moveAction)
        }
    }
    func panEnded() {
        
    }
}