//
//  SavedStateMenuButton.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/27/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SavedStateMenuButton : MenuButton, Touchable

{
    var slot:Int
    var touchingTime:NSTimeInterval = 0
    var touching:Bool = false
    var objList:Array<SoundObject>
    var lastUpdateTime:NSTimeInterval = 0
    var saved:Bool = false
    let timeToSave:NSTimeInterval = 2
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize, slot:Int, objList:Array<SoundObject>) {
        self.slot = slot
        self.objList = objList
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchStarted(position: CGPoint) {
        touching = true
        touchingTime = 0
        saved = false
    }
    func touchMoved(position: CGPoint) {
        
    }
    func touchEnded(position: CGPoint) {
        touching = false
        if (!saved && touchingTime < timeToSave) {
            NSLog("Loading state from slot %d", self.slot)
            self.touchingTime = 0
            for obj in objList {
                obj.loadStatus(slot)
            }
        }
    }
    
    func update(time:NSTimeInterval)
    {
        touchingTime += time - lastUpdateTime
        lastUpdateTime = time
        if (touching && !saved && touchingTime >= timeToSave) {
            saved = true
            NSLog("Saving state to slot %d", self.slot)
            for obj in objList {
                obj.saveStatus(slot)
            }
        }
    }
}
