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
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchEnded(position: CGPoint) {
    }
    
    func touchCancelled(position: CGPoint) {
    }
    
    func touchMoved(position: CGPoint) {
        
    }
    
    func touchStarted(position: CGPoint) {
    }
    
}