//
//  SoundObjectTemplate.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SoundObjectTemplate : MenuButton
{
    var object:SoundObject?
        
    init(object:SoundObject) {
        super.init(texture: SKTexture(imageNamed: object.iconImageName!), color: object.color, size:CGSize(width: 50, height: 50))
        self.object = object
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createSoundObject() -> SoundObject {
        var newObject:SoundObject = object!.copy() as SoundObject
        newObject.position.x = self.position.x
        newObject.position.y = self.position.y
        return newObject
    }
}