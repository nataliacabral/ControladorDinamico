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
    var selectedNode:SKSpriteNode?
    var gridSize:CGFloat?
    var project:NSMutableArray = NSMutableArray()
    
    override init(size: CGSize)
    {
        super.init(size: size)
        self.scene?.backgroundColor = UIColor.whiteColor()
        
        var sprite1:SoundObject = SoundObject(imageName:"sprite.jpeg", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))
        var sprite2:SoundObject = SoundObject(imageName:"Brazil.png", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))
        var sprite3:SoundObject = SoundObject(imageName:"UK.png", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))
        var sprite4:SoundObject = SoundObject(imageName:"Argentina.png", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))

        self.gridSize = 100;
        
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
        
        var template:SoundObjectTemplate = SoundObjectTemplate(object: sprite1)
        var template2:SoundObjectTemplate = SoundObjectTemplate(object: sprite2)
        var template3:SoundObjectTemplate = SoundObjectTemplate(object: sprite3)
        var template4:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)

        var width:CGFloat = self.size.width * 0.7
        var x:CGFloat = (self.size.width / 2) - width/2
        var palette:ObjectsPalette = ObjectsPalette(objects: [template, template2, template3, template4], position:CGPoint(x: x, y: self.size.height - 100), size:CGSize(width: width, height: 100))
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
                    var newObject:SoundObject = (touchedNode as SoundObjectTemplate).createSoundObject()!
                    self.selectedNode = newObject
                    self.project.addObject(newObject)
                    self.addChild(newObject)
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
    
    func openProject(project:NSArray) {
        self.project = NSMutableArray(array:project)
        for object in self.project {
            self.addChild(object as SKNode)
        }
    }
}