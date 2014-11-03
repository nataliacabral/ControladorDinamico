//
//  ObjectsPalette.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class ObjectsPalette
{
    var objects:NSArray
    var paletteNode:SKSpriteNode

    init(objects:NSArray, position:CGPoint, size:CGSize) {
        self.objects = objects
        self.paletteNode = SKSpriteNode(color: UIColor.yellowColor(), size:size)
        self.paletteNode.position = position
        
        var i:CGFloat = 0;
        for object in objects {
            var soundObject:SoundObjectTemplate = (object as SoundObjectTemplate)
            soundObject.anchorPoint = CGPoint(x:0, y:0)
            soundObject.position.x = 1.75 * soundObject.size.width * i;
            soundObject.position.y = self.paletteNode.size.height / 2 - (soundObject.size.height / 2)
            self.paletteNode.addChild(object as SKNode)
            i++;
        }
    }
}