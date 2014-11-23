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
        self.drawer.position.x = size.width
        //self.drawer.alpha = 0
        self.drawer.size.width = size.width
        //self.addChild(drawer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDrawer()
    {
        if (!showingDrawer) {
            showingDrawer = true
            self.addChild(self.drawer)
            var showDrawerAction:SKAction = SKAction.moveByX(-(drawer.size.width * 2), y: 0, duration: 0.3)
            //var showDrawerAction:SKAction = SKAction.fadeInWithDuration(0.3)
            self.drawer.runAction(showDrawerAction)
        }
    }
    func hideDrawer()
    {
        var hideDrawerAction:SKAction = SKAction.moveByX(drawer.size.width * 2, y: 0, duration: 0.3)
        //var hideDrawerAction:SKAction = SKAction.fadeOutWithDuration(0.3)
        self.drawer.runAction(hideDrawerAction, completion: removeDrawer)
    }
    func removeDrawer()
    {
        self.drawer.removeFromParent()
        showingDrawer = false
    }
}