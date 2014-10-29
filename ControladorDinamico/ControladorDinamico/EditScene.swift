//
//  EditScene.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 27/10/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class EditScene : SKScene
{
    var sprite:SoundObject?
    var selectedNode:SKSpriteNode?
    var gridSize:CGFloat?
    
    override init(size: CGSize)
    {
        super.init(size: size)
        self.scene?.backgroundColor = UIColor.whiteColor()
        
        self.sprite = SoundObject(imageName:"sprite.jpeg", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))
        self.sprite!.anchorPoint = CGPoint(x: 0, y: 0)

        var template:SoundObjectTemplate = SoundObjectTemplate(object: self.sprite!, size: CGSize(width: 50, height: 50))
        self.gridSize = self.size.width / 10;
        
        for (var y:CGFloat = 0 ; y < self.size.height ; y += gridSize!) {
            var gridVerticalLine:SKShapeNode = SKShapeNode()
            var gridVerticalLinePath:CGMutablePathRef = CGPathCreateMutable()
            CGPathMoveToPoint(gridVerticalLinePath, nil, self.size.width, y)
            CGPathAddLineToPoint(gridVerticalLinePath, nil, 0, y)
            gridVerticalLine.path = gridVerticalLinePath
            gridVerticalLine.strokeColor = UIColor.lightGrayColor()
            self.addChild(gridVerticalLine)
        }
        
        for (var x:CGFloat = 0 ; x < self.size.width ; x += gridSize!) {
            var gridHorizontalLine:SKShapeNode = SKShapeNode()
            var gridHorizontalLinePath:CGMutablePathRef = CGPathCreateMutable()
            CGPathMoveToPoint(gridHorizontalLinePath, nil, x, self.size.width)
            CGPathAddLineToPoint(gridHorizontalLinePath, nil, x, 0)
            gridHorizontalLine.path = gridHorizontalLinePath
            gridHorizontalLine.strokeColor = UIColor.lightGrayColor()
            self.addChild(gridHorizontalLine)
        }
        
        var palette:ObjectsPalette = ObjectsPalette(objects: [template], position:CGPoint(x: 0, y: self.size.height - 100), size:CGSize(width: self.size.width, height: 100))
        palette.paletteNode.anchorPoint = CGPoint(x:0,y:0)
        self.addChild(palette.paletteNode)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        var gestureRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFromRecognizer:"))
        self.view?.addGestureRecognizer(gestureRecognizer)
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
                if (touchedNode is SoundObjectTemplate) {
                    self.selectedNode = (touchedNode as SoundObjectTemplate).createSoundObject()
                    self.addChild(self.selectedNode!)
                }
                    
                if (touchedNode is SoundObject) {
                    self.selectedNode = (touchedNode as SKSpriteNode)
                }
            }

            break;
            
        case UIGestureRecognizerState.Changed:
            var translation:CGPoint = recognizer.translationInView(recognizer.view!)
            translation = CGPointMake(translation.x, -translation.y)
            self.panForTranslation(translation)
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)

            break;

        case UIGestureRecognizerState.Ended:
            if (self.selectedNode != nil) {
                var position:CGPoint = self.selectedNode!.position
                position.x = gridSize! * round((position.x / gridSize!))
                position.y = gridSize! * round((position.y / gridSize!))
                self.selectedNode!.position = position
            }
            self.selectedNode = nil
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            break;
        default:
            break;
        }
    }
    
    func panForTranslation(translation:CGPoint)
    {
        if (self.selectedNode != nil) {
            var position:CGPoint = self.selectedNode!.position
            self.selectedNode!.position = CGPointMake(position.x + translation.x, position.y + translation.y)
        }
    }
}