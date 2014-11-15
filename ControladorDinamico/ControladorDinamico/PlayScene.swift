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
        var panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFromRecognizer:"))
        var touchRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleTouchFromRecognizer:"))
        touchRecognizer.minimumPressDuration = 0.1;
        
        self.view?.addGestureRecognizer(panRecognizer)
        self.view?.addGestureRecognizer(touchRecognizer)

        for obj in objects
        {
            self.addChild((obj.copy() as SoundObject))
        }
    }
    
    func handleTouchFromRecognizer(recognizer:UIPanGestureRecognizer) {
        var touchLocation:CGPoint = recognizer.locationInView(recognizer.view)
        touchLocation = self.convertPointFromView(touchLocation)
        var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)
        if (touchedNode != nil && touchedNode is Touchable) {
            var touchableNode = touchedNode as Touchable
            switch(recognizer.state) {
            case UIGestureRecognizerState.Began:
                touchableNode.touchStarted()
                break;
            case UIGestureRecognizerState.Ended:
                touchableNode.touchEnded()
                break;
            default:
                break;
            }
        }
    }


    func handlePanFromRecognizer(recognizer:UIPanGestureRecognizer) {
        switch(recognizer.state) {
        case UIGestureRecognizerState.Began:
            var touchLocation:CGPoint = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)
            
            if (selectedNode == nil ||
                !self.selectedNode!.isEqual(touchedNode)) {
                    
                    if (selectedNode != nil) {
                        self.selectedNode!.removeAllActions()
                    }
                    if (selectedNode is Pannable) {
                        self.selectedNode = touchedNode as SKSpriteNode?
                        let pannableObject:Pannable = selectedNode as Pannable;
                        pannableObject.panStarted();
                    }
            }
            
            break;
            
        case UIGestureRecognizerState.Changed:
            var translation:CGPoint = recognizer.translationInView(recognizer.view!)
            translation = CGPointMake(translation.x, -translation.y)
            if (selectedNode != nil) {
                if (selectedNode is Pannable) {
                    let pannableObject:Pannable = selectedNode as Pannable;
                    pannableObject.panMoved(translation);
                }
            }
            break;
            
        case UIGestureRecognizerState.Ended:
            if (self.selectedNode != nil) {
                if (selectedNode is Pannable) {
                    let pannableObject:Pannable = selectedNode as Pannable;
                    pannableObject.panEnded();
                }
                self.selectedNode = nil
            }
            break;
        default:
            break;
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
