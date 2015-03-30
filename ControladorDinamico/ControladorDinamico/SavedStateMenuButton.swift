//
//  SavedStateMenuButton.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/27/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SavedStateMenuButton : MenuButton
{
    var stillTexture:SKTexture
    var pressedTexture:SKTexture
    var slot:Int
    var touchingTime:NSTimeInterval = 0
    var touching:Bool = false
    var objList:Array<SoundObject>
    var lastUpdateTime:NSTimeInterval = 0
    var saved:Bool = false
    var selected:Bool = false
    
    let timeToSave:NSTimeInterval = 0.8
    let timeToStartSaving:NSTimeInterval = 0.2
    
    init(slot:Int, size: CGSize, objList:Array<SoundObject>) {
        self.slot = slot
        self.objList = objList
        self.stillTexture = SKTexture(imageNamed: SavedStateMenuButton.imageMap()[slot])
        self.pressedTexture = SKTexture(imageNamed: SavedStateMenuButton.selectedImageMap()[slot])
        super.init(texture: self.stillTexture, color: nil, size: size)
    }
    
    
    class func selectedImageMap()->Array<String>
    {
        return [
            "savestate_button1_selected",
            "savestate_button2_selected",
            "savestate_button3_selected",
            "savestate_button4_selected"
        ]
    }
    
    class func imageMap()->Array<String>
    {
        return [
            "savestate_button1",
            "savestate_button2",
            "savestate_button3",
            "savestate_button4"
        ]
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
            if (self.texture == self.pressedTexture) {
                self.texture = self.stillTexture
            } else {
                self.texture = self.pressedTexture
            }
        }
        else {
            if (self.selected) {
                self.texture = self.pressedTexture
            } else {
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
