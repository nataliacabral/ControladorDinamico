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

    init(objects:NSArray, position:CGPoint, size:CGSize) {
        self.objects = objects
        super.init(texture: nil, color: UIColor.yellowColor(), size:size)

        self.position = position
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
            soundObject.position.x = 1.75 * soundObject.size.width * CGFloat(i);
            soundObject.position.y = self.size.height / 2 - (soundObject.size.height / 2)
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
        
            if (distanceToLeftEdge) < 100.0 {
                soundObject.alpha = distanceToLeftEdge / 100.0
            }
            else if (distanceToRightEdge) < 100.0 {
                soundObject.alpha = distanceToRightEdge / 100.0
            }
            else {
                soundObject.alpha = 1.0

            }
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
        var firstVisibleChild:SoundObjectTemplate? = nil;
        for object in objects {
            var template = object as SoundObjectTemplate
            if (template.position.x > 0)
            {
                if (firstVisibleChild == nil ||
                    firstVisibleChild!.position.x  + firstVisibleChild!.size.width > template.position.x) {
                    firstVisibleChild = template
                }
            }
        }
        let dislocation = -firstVisibleChild!.position.x
        self.moveObjectsX(dislocation)
        totalScroll = 0;
        self.checkObjectsOpacity()


    }
 
}