//
//  SoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SoundObject: SKSpriteNode
{
    var horizontalGridSlots:UInt = 0
    var verticalGridSlots:UInt = 0
    var gridPosition:CGPoint = CGPoint()
    var imageName:String = ""
    
    init(imageName:String, horizontalGridSlots:UInt, verticalGridSlots:UInt, initialGridPosition:CGPoint) {
        self.horizontalGridSlots = horizontalGridSlots
        self.verticalGridSlots = verticalGridSlots
        self.gridPosition = initialGridPosition
        self.imageName = imageName
        var texture:SKTexture = SKTexture(imageNamed: imageName)
        super.init(texture:texture, color: UIColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
