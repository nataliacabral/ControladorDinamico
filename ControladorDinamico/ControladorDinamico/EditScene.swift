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
    var objects:Array<SoundObject> = Array<SoundObject>()
    var palette:VerticalMenuBar?
    var menuBar:VerticalMenuBar?
    var creatingObject:Bool = false
    
    var touchMapping = Dictionary<UITouch , SKNode>()
    
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

        var width:CGFloat = gridSize
        var x:CGFloat = self.size.width - gridSize
        var y:CGFloat = -(self.size.height - gridSize)
        
        self.palette = VerticalMenuBar(
            buttons: [buttonTemplate, springTemplate, sliderTemplate, rouletteTemplate, thermalTemplate],
            position:CGPoint(x: x, y: y),
            size:CGSize(width: width, height: self.size.height),
            buttonSize:CGSize(width: gridSize, height: gridSize)
        )
        
        var objectsButton:MenuButton = DrawerMenuButton(texture:SKTexture(imageNamed: "button.png"),
            color:nil,
            size:CGSize(width: self.gridSize, height: self.gridSize),
            drawer:self.palette!)
        
        self.menuBar = VerticalMenuBar(
            buttons: [objectsButton],
            position:CGPoint(x: x, y: 0),
            size:CGSize(width: width, height: self.size.height),
            buttonSize:CGSize(width: gridSize, height: gridSize)
        )
        self.addChild(menuBar!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        for obj in objects
        {
            (obj as SoundObject).updateGridSize(self.gridSize)
            self.addChild((obj as SoundObject))
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        for touch in touches
        {
            let uiTouch = touch as UITouch
            var touchLocation:CGPoint = uiTouch.locationInView(uiTouch.view)
            touchLocation = self.convertPointFromView(touchLocation)
            var touchedNode:SKNode = self.nodeAtPoint(touchLocation) as SKNode
            if (touchedNode is RouletteSpin || touchedNode is SliderHandle) {
                touchedNode = touchedNode.parent!
            }
            if (touchedNode is SoundObject) {
                self.selectedNodeOriginalPos = touchedNode.position
            }
            touchMapping[uiTouch] = touchedNode
        }
    }
    
    func cancelMove(node:SKNode) {
        if (selectedNodeOriginalPos != nil) {
            node.position = selectedNodeOriginalPos!
        }
        else {
            node.removeFromParent()
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        for touch in touches
        {
            let uiTouch = touch as UITouch
            var touchLocation:CGPoint = uiTouch.locationInView(uiTouch.view)
            let boundNode:SKNode? = touchMapping[uiTouch]
            if (boundNode != nil) {
                if (boundNode is SoundObject) {
                    var moveCancelled = false
                    let soundObj = boundNode as SoundObject
                    
                    if (soundObj.position.x >= self.position.x &&
                        soundObj.position.x + soundObj.size.width <= self.menuBar?.position.x &&
                        soundObj.position.y >= self.position.y &&
                        soundObj.position.y + soundObj.size.height <= self.size.height)
                    {
                        for obj in self.objects {
                            if (obj != soundObj && obj.intersectsNode(soundObj)) {
                                cancelMove(soundObj)
                                moveCancelled = true
                                break;
                            }
                        }
                        if (!moveCancelled && !contains(self.objects, soundObj))
                        {
                            self.objects.append(soundObj)
                        }
                    }
                    else {
                        cancelMove(soundObj)
                        moveCancelled = true
                    }
                    self.selectedNodeOriginalPos = nil
                }
                else if (boundNode is DrawerMenuButton) {
                    let drawer = boundNode as DrawerMenuButton
                    if (drawer.showingDrawer) {
                        drawer.hideDrawer()
                    }
                    else {
                        drawer.showDrawer()
                    }
                }
                touchMapping .removeValueForKey(uiTouch)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        for touch in touches
        {
            let uiTouch = touch as UITouch
            
            var touchLocation:CGPoint = uiTouch.locationInView(uiTouch.view)
            touchLocation = self.convertPointFromView(touchLocation)
            
            let touchBoundNode:SKNode? = touchMapping[uiTouch]
            var touchedNode:SKNode = self.nodeAtPoint(touchLocation)
            
            if (touchBoundNode != nil) {
                if (touchBoundNode is SoundObject) {
                    let soundObj = touchBoundNode as SoundObject
                    soundObj.position.x = touchLocation.x - touchLocation.x % gridSize
                    soundObj.position.y = touchLocation.y - touchLocation.y % gridSize
                }
            }
            
            if (touchedNode !== touchBoundNode) {
                if (touchBoundNode is SoundObjectTemplate) {
                    let template = touchBoundNode as SoundObjectTemplate
                    var newSoundObj:SoundObject = template.createSoundObject()
                    newSoundObj.position.x = touchLocation.x
                    newSoundObj.position.y = touchLocation.y
                    self.addChild(newSoundObj)
                    touchMapping[uiTouch] = newSoundObj
                }
            }
        }
    }
}