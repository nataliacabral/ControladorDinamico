//
//  RouletteFrame.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 11/26/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit

class RouletteFrame : SKSpriteNode, Touchable
{
    let rouletteFrameTexture:SKTexture = SKTexture(imageNamed: "roulette_frame.png")
    
    override init()
    {
        super.init()
        self.texture = rouletteFrameTexture
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
        
        (self.parent as RouletteSoundObject).touchStarted(position)
    }
    
    func touchEnded(position:CGPoint)
    {
        (self.parent as RouletteSoundObject).touchEnded(position)
    }
    
    func touchCancelled(position: CGPoint) {
        self.touchEnded(position)
    }
    
    func touchMoved(position:CGPoint)
    {
        (self.parent as Touchable).touchMoved(position)
    }
}