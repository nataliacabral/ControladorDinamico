//
//  ObjectsPalette.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 29/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class ObjectsPalette : SKSpriteNode
{
    var objects:Array<SoundObjectTemplate>
    var totalScroll:CGFloat = 0
    let originalTemplateSize:CGFloat = 40;

    init(objects:Array<SoundObjectTemplate>, position:CGPoint, size:CGSize) {
        self.objects = objects
        super.init(texture: nil, color: UIColor.yellowColor(), size:size)
        self.position = position
        reloadObjs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.objects = Array()
        super.init(coder: aDecoder)
    }
    
    func reloadObjs()
    {
        var i = 0
        for soundObject in objects {
            soundObject.position.y = 1.75 * self.originalTemplateSize * CGFloat(i);
            soundObject.position.x = self.size.width / 2 - (self.originalTemplateSize / 2)
            soundObject.size.width = originalTemplateSize
            soundObject.size.height = originalTemplateSize

            self.addChild(soundObject as SKNode)
            i++;
        }
    }
}