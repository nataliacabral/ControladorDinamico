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
        
        for object in objects {
            (object as SoundObjectTemplate).anchorPoint = CGPoint(x:0, y:0)
            self.paletteNode.addChild(object as SKNode)
        }
    }
}