//
//  SavedStateMenuButton.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/27/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

//class SavedStateMenuButton
class SavedStateMenuButton : MenuButton

{
    var slot:Int
    var touchingTime:NSTimeInterval = 0
    var touching:Bool = false
    var objList:Array<SoundObject>
    var lastUpdateTime:NSTimeInterval = 0
    var saved:Bool = false
    var selected:Bool = false
    
    let timeToSave:NSTimeInterval = 0.8
    let timeToStartSaving:NSTimeInterval = 0.2
    
    let selectedColor:UIColor = UIColor.greenColor()
    let savingColor:UIColor = UIColor.blueColor()
    let deselectedColor:UIColor = UIColor.whiteColor()

    
    init(texture: SKTexture!, pressedTexture: SKTexture?, color: UIColor!, size: CGSize, slot:Int, objList:Array<SoundObject>) {
        self.slot = slot
        self.objList = objList
        super.init(texture: texture, pressedTexture:pressedTexture, color: color, size: size)
        self.colorBlendFactor = 1.0
        self.color = self.deselectedColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchStarted(position: CGPoint) {
        super.touchStarted(position)
        touching = true
        touchingTime = 0
        saved = false
    }
    override func touchMoved(position: CGPoint) {
        
    }
    override func touchEnded(position: CGPoint) {
        super.touchEnded(position)
        touching = false
        if (!saved && touchingTime < timeToSave) {
            NSLog("Loading state from slot %d", self.slot)
            self.touchingTime = 0
            for obj in objList {
                obj.loadStatus(slot)
            }
            SavedStateManager.sharedInstance.selectSlot(self.slot)
        }
    }
    
    func updateDraw() {
        if (touching && !saved && touchingTime < timeToSave && touchingTime > timeToStartSaving)
        {
            self.color = self.savingColor
            self.texture = self.pressedTexture
        }
        else if (self.selected) {
            self.color = self.selectedColor
            self.texture = self.pressedTexture
        }
        else {
            self.color = self.deselectedColor
            if (self.touching) {
                self.texture = self.pressedTexture
            }
            else {
                self.texture = self.stillTexture
            }
        }
    }

    override func touchCancelled(position: CGPoint) {
        self.touching = false
        self.touchingTime = 0
        self.updateDraw()
        self.texture = self.stillTexture
    }
    
    func update(time:NSTimeInterval)
    {
        touchingTime += time - lastUpdateTime
        lastUpdateTime = time
        if (touching && !saved) {
            if (touchingTime >= timeToSave) {
                saved = true
                NSLog("Saving state to slot %d", self.slot)
                for obj in objList {
                    obj.saveStatus(slot)
                }
                // Uncomment to load state after save
                //SavedStateManager.sharedInstance.selectSlot(self.slot)
            }
            self.updateDraw()
        }
    }
    
    func selectSlot()
    {
        self.selected = true
        self.updateDraw()
    }
    
    func deselectSlot()
    {
        self.selected = false
        self.updateDraw()
    }

}
