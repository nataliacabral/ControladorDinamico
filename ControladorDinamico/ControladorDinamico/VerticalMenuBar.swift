//
//  EditMenuBar.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/23/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class VerticalMenuBar : SKSpriteNode
{
    let border:CGFloat = 8
    let bgColor = UIColor(red:0.5 , green:0.5, blue:0.5, alpha: 1)

    var buttonList:Array<MenuButton>
    var buttonSize:CGSize
    
    init(buttons:Array<MenuButton>, position:CGPoint, size:CGSize, buttonSize:CGSize) {
        self.buttonList = buttons
        self.buttonSize = buttonSize
        super.init(texture: nil, color: bgColor, size:size)
        self.name = "VerticalMenuBar"
        self.position = position
        self.zPosition = -1
        
        reloadObjs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadObjs()
    {
        var borderDistance = border
        var yPos = (self.size.height / 2) - self.buttonSize.height / 2 - borderDistance
        for button in self.buttonList {
            button.position.y = yPos
            button.position.x = 0
            button.size.width = self.buttonSize.width
            button.size.height = self.buttonSize.height
            yPos -= self.buttonSize.height + border
            borderDistance += border
            self.addChild(button)
        }
    }
}