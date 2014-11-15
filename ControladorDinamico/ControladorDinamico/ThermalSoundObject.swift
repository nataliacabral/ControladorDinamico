//
//  ThermalSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class ThermalSoundObject : SoundObject
{
    let gridHeight:CGFloat = 2
    let gridWidth:CGFloat = 2
    override var imageName:String { get { return "thermal.png" } }
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    init(gridSize:CGFloat) {
        super.init(size:CGSize(width: gridWidth * gridSize, height: gridHeight * gridSize))
    }
}