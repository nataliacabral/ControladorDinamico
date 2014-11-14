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
    var gridSize:CGFloat
    let distanceToCreateObject:CGFloat = 30
    
    var selectedNode:SKSpriteNode?
    var objects:NSMutableArray = NSMutableArray()
    
    override init(size: CGSize)
    {
        self.gridSize = size.width / 8
        super.init(size: size)
        self.scene?.backgroundColor = UIColor.blackColor()
        
        //Grid
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
    
    override func didMoveToView(view: SKView) {
        
        for obj in objects
        {
            self.addChild((obj.copy() as SoundObject))
        }
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
