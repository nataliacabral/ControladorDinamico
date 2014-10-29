//
//  SoundObjectTemplate.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SoundObjectTemplate: SKSpriteNode
{
    var object:SoundObject?
    
    init(object:SoundObject, size:CGSize) {
        super.init(texture: object.texture, color: UIColor(), size:size)
        self.object = object
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createSoundObject() -> SoundObject? {
        var newObject:SoundObject? = nil
        if (object != nil) {
            newObject = SoundObject(imageName:object!.imageName, horizontalGridSlots: object!.horizontalGridSlots, verticalGridSlots: object!.verticalGridSlots, initialGridPosition: object!.gridPosition)
            newObject!.position.x = self.position.x + self.parent!.position.x
            newObject!.position.y = self.position.y + self.parent!.position.y
            newObject!.anchorPoint = CGPoint(x:0, y:0)
        }
        return newObject
    }
}