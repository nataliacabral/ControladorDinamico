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
    var selectedNodeOriginalPos:CGPoint?
    var selectedNode:SKSpriteNode?
    var gridSize:CGFloat = 100
    var project:NSMutableArray = NSMutableArray()
    var palette:ObjectsPalette?
    var creatingObject:Bool = false
    
    override init(size: CGSize)
    {
        super.init(size: size)
        self.scene?.backgroundColor = UIColor.whiteColor()
        
        var sprite1:SoundObject = SoundObject(imageName:"sprite.jpeg", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))
        var sprite2:SoundObject = SoundObject(imageName:"Brazil.png", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))
        var sprite3:SoundObject = SoundObject(imageName:"UK.png", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))
        var sprite4:SoundObject = SoundObject(imageName:"Argentina.png", horizontalGridSlots: 0,verticalGridSlots: 0, initialGridPosition: CGPoint(x:0, y:0))

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
        var template5:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
        var template6:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
        var template7:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
        var template8:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
        var template9:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
        var template10:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)
        var template11:SoundObjectTemplate = SoundObjectTemplate(object: sprite4)

        var width:CGFloat = self.size.width * 0.7
        var x:CGFloat = (self.size.width / 2) - width/2
       // var palette:ObjectsPalette = ObjectsPalette(objects: [template, template2, template3, template4], position:CGPoint(x: x, y: self.size.height - 100), size:CGSize(width: width, height: 100))

        self.palette = ObjectsPalette(
            objects: [template, template2, template3, template4, template5, template6, template7, template8, template9, template10, template11],
            position:CGPoint(x: x, y: self.size.height - 100), size:CGSize(width: width, height: 100)
        )
        self.palette!.anchorPoint = CGPoint(x:0,y:0)
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
                if (translation.y < -50) {
                    var newNode:SoundObject = (self.selectedNode as SoundObjectTemplate).createSoundObject()!
                    self.selectNode(newNode)
                    self.addChild(newNode)
                }
                else
                {
                    self.palette!.scroll(translation.x)
                }
            }
            else if (self.selectedNode is ObjectsPalette) {
                self.palette!.scroll(translation.x)
            }
            else if (self.selectedNode is SoundObject) {
                self.panForTranslation(translation)
                recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            }

            break;

        case UIGestureRecognizerState.Ended:
            if (self.selectedNode != nil) {
                if (self.selectedNode is SoundObject) {
                    var position:CGPoint = self.selectedNode!.position
                    position.x = gridSize * round((position.x / gridSize))
                    position.y = gridSize * round((position.y / gridSize))
                    self.selectedNode!.position = position
                    if (self.isSoundObjectColliding(selectedNode as SoundObject))
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
                else if (self.selectedNode is SoundObjectTemplate) {
                    self.palette!.stopScroll()
                }
                else if (self.selectedNode is ObjectsPalette) {
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
    
    func gridPositionForObjectPosition(objectPosition:CGPoint) -> CGPoint
    {
        var xPos:CGFloat = objectPosition.x / self.gridSize
        var yPos:CGFloat = objectPosition.y / self.gridSize
        return CGPoint(x:xPos, y:yPos)
    }
    
    func gridBoxForSoundObject(soundObject:SoundObject) -> CGRect
    {
        var gridPos = self.gridPositionForObjectPosition(soundObject.position)
        var gridSize = CGSize(width:gridPos.x + CGFloat(soundObject.horizontalGridSlots),
            height:(gridPos.y + CGFloat(soundObject.verticalGridSlots)))
        return CGRect(origin:gridPos, size:gridSize)
    }
    
    func isSoundObjectColliding(obj:SoundObject) -> Bool
    {
        for otherObj:AnyObject in self.children {
            if (otherObj is SoundObject && (otherObj as SoundObject) !== obj)
            {
                let otherSoundObj = otherObj as SoundObject
                var objGridBox = self.gridBoxForSoundObject(obj)
                var otherObjGridBox = self.gridBoxForSoundObject(otherSoundObj)
                let collides:Bool = CGPointEqualToPoint(obj.position, otherObj.position)
                    || (obj.position.x < otherObj.position.x + otherObj.size.width &&
                    obj.position.x + obj.size.width > otherObj.position.x &&
                    obj.position.y < otherObj.position.y + otherObj.size.height &&
                    obj.size.height + obj.position.y > otherObj.position.y)
                
                if (collides)
                {
                    return collides;
                }
            }
        }
        return false;
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