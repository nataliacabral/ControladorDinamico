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
    var gridSize:CGFloat = 100
    let distanceToCreateObject:CGFloat = 30

    var selectedNodeOriginalPos:CGPoint?
    var selectedNode:SKSpriteNode?
    var objects:NSMutableArray = NSMutableArray()
    var palette:ObjectsPalette?
    var creatingObject:Bool = false
    
    override init(size: CGSize)
    {
        super.init(size: size)
        self.scene?.backgroundColor = UIColor.whiteColor()
        gridSize = size.width / 8
        
        var sprite1:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize)
        var sprite2:SpringSoundObject = SpringSoundObject(gridSize:gridSize)
        var sprite3:SliderSoundObject = SliderSoundObject(gridSize:gridSize)
        var sprite4:RouletteSoundObject = RouletteSoundObject(gridSize:gridSize)
        var sprite5:ThermalSoundObject = ThermalSoundObject(gridSize:gridSize)

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
        
        var template:SoundObjectTemplate = SoundObjectTemplate(object: sprite1)
        var template2:SoundObjectTemplate = SoundObjectTemplate(object: sprite2)
        var template3:SoundObjectTemplate = SoundObjectTemplate(object: sprite3)
        var template4:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
        var template5:SoundObjectTemplate = SoundObjectTemplate(object: sprite5)
//        var template6:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
//        var template7:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
//        var template8:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
//        var template9:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
//        var template10:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
//        var template11:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)

        var width:CGFloat = self.size.width * 0.7
        var x:CGFloat = (self.size.width / 2) - width/2

        self.palette = ObjectsPalette(
            objects: [template, template2, template3, template4, template5],
            position:CGPoint(x: x, y: self.size.height - 100), size:CGSize(width: width, height: 100)
        )
        self.addChild(self.palette!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func selectNode(node: SKSpriteNode)
    {
        self.selectedNode = node
        self.selectedNodeOriginalPos = CGPoint(x: node.position.x, y: node.position.y)
    }
    
    func deselectNode()
    {
        self.selectedNode = nil
        self.selectedNodeOriginalPos = nil
    }
    
    override func didMoveToView(view: SKView) {
        var gestureRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFromRecognizer:"))
        self.view?.addGestureRecognizer(gestureRecognizer)
        
        for obj in objects
        {
            self.addChild((obj as SoundObject))
        }
    }
    
    func handlePanFromRecognizer(recognizer:UIPanGestureRecognizer) {
        switch(recognizer.state) {
        case UIGestureRecognizerState.Began:
            self.creatingObject = false
            var touchLocation:CGPoint = recognizer.locationInView(recognizer.view)
            touchLocation = self.convertPointFromView(touchLocation)
            var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)

            if (selectedNode == nil ||
                !self.selectedNode!.isEqual(touchedNode)) {
            
                if (selectedNode != nil) {
                    self.selectedNode!.removeAllActions()
                }
                if (touchedNode is SoundObjectTemplate) {
                    self.selectNode(touchedNode! as SoundObjectTemplate)
                    self.creatingObject = true
                }
                else if (touchedNode is ObjectsPalette) {
                    self.selectNode(touchedNode! as ObjectsPalette)
                }
                else if (touchedNode is SoundObject) {
                    self.selectNode(touchedNode! as SoundObject)
                }
            }

            break;
            
        case UIGestureRecognizerState.Changed:
            var translation:CGPoint = recognizer.translationInView(recognizer.view!)
            translation = CGPointMake(translation.x, -translation.y)
            if (self.selectedNode is TouchListener) {
                (selectedNode as TouchListener).touchMoved(recognizer)
            }
            if (self.selectedNode is SoundObjectTemplate) {
                if (translation.y < -self.distanceToCreateObject) {
                    var newObject:SoundObject = (self.selectedNode as SoundObjectTemplate).createSoundObject()!
                    self.selectNode(newObject)
                    self.addChild(newObject)
                    self.objects.addObject(newObject)
                }
                else
                {
                    self.palette!.scroll(translation.x)
                }
            }
            else if (self.selectedNode is SoundObject)
            {
                self.selectedNode!.position = CGPointMake(self.selectedNode!.position.x + translation.x, self.selectedNode!.position.y + translation.y)
                recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            }
            else if (self.selectedNode is ObjectsPalette) {
                self.palette!.scroll(translation.x)
            }

            break;

        case UIGestureRecognizerState.Ended:
            if (self.selectedNode != nil) {
                if (self.selectedNode is TouchListener) {
                    (selectedNode as TouchListener).touchEnded()
                }
                if (self.selectedNode is GridBound) {
                    var position:CGPoint = self.selectedNode!.position
                    position.x = gridSize * round((position.x / gridSize))
                    position.y = gridSize * round((position.y / gridSize))
                    self.selectedNode!.position = position
                    
                }
                if (self.selectedNode is Collidable)
                {
                    if (self.checkCollisionForCollidable(selectedNode as Collidable))
                    {
                        if (self.creatingObject) {
                            self.selectedNode?.removeFromParent();
                        }
                        else
                        {
                            self.selectedNode!.position = self.selectedNodeOriginalPos!
                        }
                    }
                }
                if (self.selectedNode is SoundObjectTemplate) {
                    self.palette!.stopScroll()
                }
                if (self.selectedNode is ObjectsPalette) {
                    self.palette!.stopScroll()
                }
            }
            self.deselectNode()
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            break;
        default:
            break;
        }
    }

    func checkCollisionForCollidable(node:Collidable) -> Bool
    {
        for otherNode:AnyObject in self.children {
            if (otherNode is Collidable)
            {
                if (otherNode as Collidable).collidesWith(node)
                {
                    return true
                }
            }
        }
        return false;
    }
}