//
//  SavedStateManager.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 12/1/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

class SavedStateManager

{
    var stateButtons:Array<SavedStateMenuButton> = Array<SavedStateMenuButton>()
    var selectedSlot = 0
    
    class var sharedInstance: SavedStateManager {
        struct Static {
            static var instance: SavedStateManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SavedStateManager()
        }
        
        return Static.instance!
    }
    
    func selectSlot(slot:Int)
    {
        stateButtons[selectedSlot].deselectSlot()
        stateButtons[slot].selectSlot()
        selectedSlot = slot
    }
}