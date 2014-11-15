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
    var objects:NSArray
    var totalScroll:CGFloat = 0
    let originalTemplateSize:CGFloat = 40;

    init(objects:NSArray, position:CGPoint, size:CGSize) {
        self.objects = objects
        super.init(texture: nil, color: UIColor.yellowColor(), size:size)

        self.position = position
        self.anchorPoint = CGPoint(x:0,y:0)
        reloadObjs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.objects = NSArray()
        super.init(coder: aDecoder)
    }
    
    func reloadObjs()
    {
        var i = 0
        for object in objects {
            var soundObject:SoundObjectTemplate = (object as SoundObjectTemplate)
            soundObject.anchorPoint = CGPoint(x:0, y:0)
            soundObject.position.x = 1.75 * self.originalTemplateSize * CGFloat(i);
            soundObject.position.y = self.size.height / 2 - (self.originalTemplateSize / 2)
            soundObject.size.width = originalTemplateSize
            soundObject.size.height = originalTemplateSize

            self.addChild(object as SKNode)
            i++;
        }
        self.checkObjectsOpacity()
    }
    
    func checkObjectsOpacity()
    {
        for object in objects {
            var soundObject:SoundObjectTemplate = (object as SoundObjectTemplate)
            let distanceToLeftEdge:CGFloat = soundObject.position.x
            let objectRightEdge = soundObject.position.x + soundObject.size.width
            let distanceToRightEdge:CGFloat = self.size.width - objectRightEdge
        
            var factor:CGFloat = 1.0
            if (distanceToLeftEdge) < 100.0 {
                factor = distanceToLeftEdge / 100.0
                soundObject.alpha = distanceToLeftEdge / 100.0
            }
            else if (distanceToRightEdge) < 100.0 {
                factor = distanceToRightEdge / 100.0
            }
            else {
                factor = 1.0
            }
            soundObject.alpha = factor
            soundObject.size.width = self.originalTemplateSize * factor
            soundObject.size.height = self.originalTemplateSize * factor
        }

    }
    
    func scroll(x:CGFloat)
    {
        var dislocation = (x - totalScroll)
        totalScroll += dislocation
        self.moveObjectsX(dislocation)
    }
    
    func moveObjectsX(x:CGFloat)
    {
        for object in objects {
            var soundObject:SoundObjectTemplate = (object as SoundObjectTemplate)
            soundObject.position.x += x;
        }
        self.checkObjectsOpacity()
    }
    
    func stopScroll()
    {
        let firstChild:SoundObjectTemplate = (self.objects.firstObject as SoundObjectTemplate);
        let lastChild:SoundObjectTemplate = (self.objects.lastObject as SoundObjectTemplate);
        var dislocation:CGFloat = 0;
        if (firstChild.position.x + firstChild.size.width / 2 > self.size.width / 2)
        {
            dislocation = self.size.width / 2 - (firstChild.position.x + firstChild.size.width / 2);
        }
        if (lastChild.position.x + firstChild.size.width / 2 < self.size.width / 2)
        {
            dislocation = self.size.width / 2 - (lastChild.position.x + firstChild.size.width / 2);
        }
        
        self.moveObjectsX(dislocation)
        totalScroll = 0;
        self.checkObjectsOpacity()
    }
 
}