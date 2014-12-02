//
//  MenuButton.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/23/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class MenuButton : SKSpriteNode, Touchable
{
    var pressedTexture:SKTexture?
    var stillTexture:SKTexture?
    
    init(texture: SKTexture!, pressedTexture: SKTexture?, color: UIColor!, size: CGSize) {
        self.pressedTexture = pressedTexture
        self.stillTexture = texture
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchEnded(position: CGPoint) {
        self.stopPress()
    }
    
    func touchCancelled(position: CGPoint) {
        self.touchEnded(position)
    }
    
    func touchMoved(position: CGPoint) {
        
    }
    
    func touchStarted(position: CGPoint) {
        self.press()
    }
    
    func press()
    {
        if (self.pressedTexture != nil) {
            self.texture = pressedTexture
        }
    }
    func stopPress()
    {
        self.texture = self.stillTexture
    }
}