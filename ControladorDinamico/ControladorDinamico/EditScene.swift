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
    var gridSize:CGFloat
    let distanceToCreateObject:CGFloat = 30

    var selectedNodeOriginalPos:CGPoint?
    var selectedNode:SKSpriteNode?
    var objects:Array<SoundObject> = Array<SoundObject>()
    var palette:ObjectsPalette?
    var creatingObject:Bool = false
    
    override init(size: CGSize)
    {
        self.gridSize = size.width / 16
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
        
        // Palette
        var buttonSprite:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize)
        var springSprite:SpringSoundObject = SpringSoundObject(gridSize:gridSize)
        var sliderSprite:SliderSoundObject = SliderSoundObject(gridSize:gridSize)
        var rouletteSprite:RouletteSoundObject = RouletteSoundObject(gridSize:gridSize)
        var thermalSprite:ThermalSoundObject = ThermalSoundObject(gridSize:gridSize)
        
        var buttonTemplate:SoundObjectTemplate = SoundObjectTemplate(object: buttonSprite)
        var springTemplate:SoundObjectTemplate = SoundObjectTemplate(object: springSprite)
        var sliderTemplate:SoundObjectTemplate = SoundObjectTemplate(object: sliderSprite)
        var rouletteTemplate:SoundObjectTemplate = SoundObjectTemplate(object: rouletteSprite)
        var thermalTemplate:SoundObjectTemplate = SoundObjectTemplate(object: thermalSprite)

        var width:CGFloat = self.size.width * 0.7
        var x:CGFloat = (self.size.width / 2) - width/2

        self.palette = ObjectsPalette(
            objects: [buttonTemplate, springTemplate, sliderTemplate, rouletteTemplate, thermalTemplate],
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
            (obj as SoundObject).updateGridSize(self.gridSize)
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

            if (self.selectedNode is SoundObjectTemplate) {
                if (translation.y < -self.distanceToCreateObject) {
                    var newObject:SoundObject = (self.selectedNode as SoundObjectTemplate).createSoundObject()
                    self.selectNode(newObject)
                    self.addChild(newObject)
                    self.objects.append(newObject)
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
                        self.cancelPlacement(selectedNode!);
                    }
                    else if self.isOutOfScreen(selectedNode!) {
                            self.cancelPlacement(selectedNode!);
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
    
    func isOutOfScreen(node:SKSpriteNode) -> Bool
    {
        return (node.position.x < self.position.x ||
            node.position.x + node.size.width > self.position.x + self.size.width ||
            node.position.y < self.position.y ||
            node.position.y + node.size.height > self.position.y + self.size.height);
    }
    
    func cancelPlacement(node:SKSpriteNode) {
        if (self.creatingObject) {
            self.selectedNode?.removeFromParent();
        }
        else
        {
            self.selectedNode!.position = self.selectedNodeOriginalPos!
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