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
    var buttonList:Array<MenuButton>
    var buttonSize:CGSize
    
    init(buttons:Array<MenuButton>, position:CGPoint, size:CGSize, buttonSize:CGSize) {
        self.buttonList = buttons
        self.buttonSize = buttonSize
        super.init(texture: nil, color: UIColor.yellowColor(), size:size)
        self.name = "VerticalMenuBar"
        self.position = position
//        self.anchorPoint = CGPoint(x:0,y:0)
        self.zPosition = -1
        reloadObjs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadObjs()
    {
        var i = 0
        var yPos = self.size.height - self.buttonSize.height
        for button in self.buttonList {
//            button.anchorPoint = CGPoint(x:0, y:0)
            button.position.y = yPos
            button.position.x = 0
            button.size.width = self.buttonSize.width
            button.size.height = self.buttonSize.height
            yPos -= self.buttonSize.height
            
            self.addChild(button)
        }
    }
}