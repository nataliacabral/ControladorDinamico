//
//  RouletteButton.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 11/26/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class RouletteButton : SKSpriteNode, Touchable
{
    var toggled:Bool = false

    let toggledColor:UIColor = UIColor.lightGrayColor()
    let untoggledColor:UIColor = UIColor.whiteColor()

    
    let rouletteButtonTexture:SKTexture = SKTexture(imageNamed: "roullete_button.png")

    override init()
    {
        super.init()
        self.texture = rouletteButtonTexture
        self.color = untoggledColor
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    func touchStarted(position:CGPoint)
    {
    }
    
    func setToggle(toggled:Bool) {
        self.toggled = toggled
        if (toggled) {
            self.color = self.toggledColor
        }
        else {
            self.color = self.untoggledColor
        }
    }
    
    func touchEnded(position:CGPoint)
    {
        self.setToggle(!self.toggled)
        let rouletteObj:RouletteSoundObject = self.parent! as RouletteSoundObject
        rouletteObj.toggleFriction(self.toggled)
    }
    
    func touchCancelled(position: CGPoint) {
        self.touchEnded(position)
    }
    
    func touchMoved(position:CGPoint)
    {
    
    }
}