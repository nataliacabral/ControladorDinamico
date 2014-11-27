//
//  DrawerMenuButton.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/23/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class DrawerMenuButton : MenuButton
{
    var showingDrawer:Bool = false
    var drawer:VerticalMenuBar
    
    init(texture: SKTexture!, color: UIColor!, size: CGSize, drawer:VerticalMenuBar) {
        self.drawer = drawer
        super.init(texture:texture, color:color, size:size)
        self.name = "DrawerMenuButton"
        self.drawer.zPosition = -1
        self.drawer.hidden = true
        self.drawer.size.width = size.width
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDrawer()
    {
        if (!showingDrawer) {
            self.drawer.hidden = false
            self.drawer.zPosition = -1
            self.showingDrawer = true
            var showDrawerAction:SKAction = SKAction.moveByX(-drawer.size.width, y: 0, duration: 0.3)
            self.drawer.runAction(showDrawerAction)
        }
    }
    func hideDrawer()
    {
        if (showingDrawer) {
            self.showingDrawer = false
            self.drawer.zPosition = -2
            var hideDrawerAction:SKAction = SKAction.moveByX(drawer.size.width, y: 0, duration: 0.3)
            self.drawer.runAction(hideDrawerAction, completion: completedHide)
        }
    }
    func completedHide()
    {
        self.drawer.hidden = true
    }
}