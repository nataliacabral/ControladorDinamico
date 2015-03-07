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
    var border:CGFloat
    let bgColor = UIColor(red:0.5 , green:0.51, blue:0.52, alpha: 1)

    var buttonList:Array<MenuButton>?
    var buttonSize:CGSize?
    
//    init(buttons:Array<MenuButton>, position:CGPoint, size:CGSize, buttonSize:CGSize, border:CGFloat) {
//        self.border = border
//        let texture:SKTexture = SKTexture(imageNamed: "menu_background.png")
//        super.init(texture: texture, color: nil, size: size)
//        self.initializeProperties(buttons, position: position, size: size, buttonSize: buttonSize)
//    }
    
    init(buttons:Array<MenuButton>, position:CGPoint, size:CGSize, buttonSize:CGSize, background:SKTexture, border:CGFloat) {
        self.border = border
        super.init(texture: background, color: nil, size:size)
        self.initializeProperties(buttons, position: position, size: size, buttonSize: buttonSize)
    }
    
    func initializeProperties(buttons:Array<MenuButton>, position:CGPoint, size:CGSize, buttonSize:CGSize)
    {
        self.buttonList = buttons
        self.buttonSize = buttonSize
        self.name = "VerticalMenuBar"
        self.position = position
        self.zPosition = 2
        
        reloadObjs()

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadObjs()
    {
        var borderDistance = self.border
        var yPos = (self.size.height / 2) - self.buttonSize!.height / 2 - borderDistance / 2
        for button in self.buttonList! {
            button.position.y = yPos
            button.position.x = 0
            button.size.width = self.buttonSize!.width
            button.size.height = self.buttonSize!.height
            yPos -= self.buttonSize!.height + self.border
            borderDistance += self.border
            self.addChild(button)
        }
    }
}