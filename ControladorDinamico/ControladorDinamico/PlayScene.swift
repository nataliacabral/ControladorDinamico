//
//  PlayScene.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class PlayScene : SKScene
{
    let gridSize:CGFloat = 100
    let distanceToCreateObject:CGFloat = 30
    
    var selectedNode:SKSpriteNode?
    var objects:NSMutableArray = NSMutableArray()
    
    override init(size: CGSize)
    {
        super.init(size: size)
        self.scene?.backgroundColor = UIColor.whiteColor()
        
        var sprite1:SoundObject = SoundObject(imageName:"sprite.jpeg", size:CGSize(width:gridSize * 2, height:gridSize * 2))
        var sprite2:SoundObject = SoundObject(imageName:"Brazil.png", size:CGSize(width:gridSize * 2, height:gridSize * 2))
        var sprite3:SoundObject = SoundObject(imageName:"UK.png", size:CGSize(width:gridSize * 2, height:gridSize * 1))
        var sprite4:SoundObject = SoundObject(imageName:"Argentina.png", size:CGSize(width:gridSize * 1, height:gridSize * 2))
        
        for (var y:CGFloat = 0 ; y < self.size.height ; y += gridSize) {
            var gridVerticalLine:SKShapeNode = SKShapeNode()
            var gridVerticalLinePath:CGMutablePathRef = CGPathCreateMutable()
            CGPathMoveToPoint(gridVerticalLinePath, nil, self.size.width, y)
            CGPathAddLineToPoint(gridVerticalLinePath, nil, 0, y)
            gridVerticalLine.path = gridVerticalLinePath
            gridVerticalLine.strokeColor = UIColor.lightGrayColor()
            self.addChild(gridVerticalLine)
        }
        
        for (var x:CGFloat = 0 ; x < self.size.width ; x += gridSize) {
            var gridHorizontalLine:SKShapeNode = SKShapeNode()
            var gridHorizontalLinePath:CGMutablePathRef = CGPathCreateMutable()
            CGPathMoveToPoint(gridHorizontalLinePath, nil, x, self.size.width)
            CGPathAddLineToPoint(gridHorizontalLinePath, nil, x, 0)
            gridHorizontalLine.path = gridHorizontalLinePath
            gridHorizontalLine.strokeColor = UIColor.lightGrayColor()
            self.addChild(gridHorizontalLine)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
