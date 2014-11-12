//
//  SpringSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SpringSoundObject : SoundObject
{
    let gridHeight:CGFloat = 3
    let gridWidth:CGFloat = 1
    
    init(gridSize:CGFloat) {
        var imageName: NSString = "spring.png"
        super.init(imageName:imageName, size:CGSize(width: gridWidth * gridSize, height: gridHeight * gridSize))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}