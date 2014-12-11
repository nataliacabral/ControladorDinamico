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
    var buttonDrawer:VerticalMenuBar?
    var modulatorDrawer:VerticalMenuBar?
    var menuBar:VerticalMenuBar?
    var creatingObject:Bool = false
    var openDrawer:DrawerMenuButton? = nil
    
    var touchMapping = Dictionary<UITouch , SKNode>()
    var backButton:MenuButton
    var playButton:MenuButton
    var trashButton:MenuButton
    var saveButton:MenuButton
    var aboutButton:MenuButton

    
    override init(size: CGSize)
    {
        self.gridSize = 128
        // Menu
        var buttonSpriteC:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize, note:60)
        var buttonSpriteD:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize, note:62)
        var buttonSpriteE:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize, note:64)
        var buttonSpriteF:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize, note:65)
        var buttonSpriteG:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize, note:67)
        var buttonSpriteA:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize, note:69)
        var buttonSpriteB:ButtonSoundObject = ButtonSoundObject(gridSize:gridSize, note:71)
        
        var springSprite:SpringSoundObject = SpringSoundObject(gridSize:gridSize)
        var sliderSprite:SliderSoundObject = SliderSoundObject(gridSize:gridSize)
        var horizontalSliderSprite:SliderSoundObject = SliderSoundObject(gridSize:gridSize)
        horizontalSliderSprite.zRotation = -CGFloat(M_PI_2)

        var rouletteSprite:RouletteSoundObject = RouletteSoundObject(gridSize:gridSize)
        var thermalSprite:ThermalSoundObject = ThermalSoundObject(gridSize:gridSize)
        
        var buttonTemplateC:SoundObjectTemplate = SoundObjectTemplate(object: buttonSpriteC)
        var buttonTemplateD:SoundObjectTemplate = SoundObjectTemplate(object: buttonSpriteD)
        var buttonTemplateE:SoundObjectTemplate = SoundObjectTemplate(object: buttonSpriteE)
        var buttonTemplateF:SoundObjectTemplate = SoundObjectTemplate(object: buttonSpriteF)
        var buttonTemplateG:SoundObjectTemplate = SoundObjectTemplate(object: buttonSpriteG)
        var buttonTemplateA:SoundObjectTemplate = SoundObjectTemplate(object: buttonSpriteA)
        var buttonTemplateB:SoundObjectTemplate = SoundObjectTemplate(object: buttonSpriteB)
        
        var springTemplate:SoundObjectTemplate = SoundObjectTemplate(object: springSprite)
        var sliderTemplate:SoundObjectTemplate = SoundObjectTemplate(object: sliderSprite)
        var horizontalSliderTemplate:SoundObjectTemplate = SoundObjectTemplate(object: horizontalSliderSprite)
        var rouletteTemplate:SoundObjectTemplate = SoundObjectTemplate(object: rouletteSprite)
        var thermalTemplate:SoundObjectTemplate = SoundObjectTemplate(object: thermalSprite)
    
        let buttonSize = CGSize(width: 100, height: 100)
        backButton = MenuButton(
            texture:SKTexture(imageNamed: "menubutton_projects.png"),
            color:UIColor(),
            size:buttonSize)
        
        playButton = MenuButton(
            texture:SKTexture(imageNamed: "menubutton_play.png"),
            color:UIColor(),
            size:buttonSize)
        
        trashButton = MenuButton(
            texture:SKTexture(imageNamed: "bin.png"),
            color:UIColor(),
            size:buttonSize)
        
        saveButton = MenuButton(
            texture:SKTexture(imageNamed: "menubutton_save.png"),
            color:UIColor(),
            size:buttonSize)

        aboutButton = MenuButton(
            texture:SKTexture(imageNamed: "menubutton_about.png"),
            color:UIColor(),
            size:buttonSize)

        
        super.init(size: size)

        self.scene?.backgroundColor = UIColor.blackColor()
        var width:CGFloat = gridSize
        var x:CGFloat = self.size.width - gridSize / 2
        var y:CGFloat = (self.size.height / 2)
        
        //Drawer menus
        self.buttonDrawer = VerticalMenuBar(
            buttons: [
                buttonTemplateC,
                buttonTemplateD,
                buttonTemplateE,
                buttonTemplateF,
                buttonTemplateG,
                buttonTemplateA,
                buttonTemplateB
            ],
            position:CGPoint(x: x, y: -(self.size.height - gridSize)),
            size:CGSize(width: width, height: self.size.height),
            buttonSize:CGSize(width: gridSize, height: gridSize)
        )
        
        self.modulatorDrawer = VerticalMenuBar(
            buttons: [
                springTemplate,
                sliderTemplate,
                horizontalSliderTemplate,
                rouletteTemplate,
                thermalTemplate],
            position:CGPoint(x: x, y: -(self.size.height - (gridSize * 2))),
            size:CGSize(width: width, height: self.size.height),
            buttonSize:CGSize(width: gridSize, height: gridSize)
        )

        var buttonsDrawerButton:MenuButton = DrawerMenuButton(
            texture:SKTexture(imageNamed: "menubutton_button.png"),
            color:UIColor(),
            size:buttonSize,
            drawer:self.buttonDrawer!)
        
        var modulatorDrawerButton:MenuButton = DrawerMenuButton(
            texture:SKTexture(imageNamed: "menubutton_modulator.png"),
            color:UIColor(),
            size:buttonSize,
            drawer:self.modulatorDrawer!)
        
        self.modulatorDrawer!.position.x = x + gridSize;
        self.modulatorDrawer!.position.y = y;
        
        self.buttonDrawer!.position.x = x + gridSize;
        self.buttonDrawer!.position.y = y;
        
        self.addChild(self.modulatorDrawer!)
        self.addChild(self.buttonDrawer!)

        
        //Grid
        for (var y:CGFloat = 0 ; y < self.size.height ; y += gridSize) {
            var gridVerticalLine:SKShapeNode = SKShapeNode()
            var gridVerticalLinePath:CGMutablePathRef = CGPathCreateMutable()
            CGPathMoveToPoint(gridVerticalLinePath, nil, self.size.width, y)
            CGPathAddLineToPoint(gridVerticalLinePath, nil, 0, y)
            gridVerticalLine.path = gridVerticalLinePath
            gridVerticalLine.strokeColor = UIColor.lightGrayColor()
            gridVerticalLine.zPosition = -10
            self.addChild(gridVerticalLine)
        }
        
        for (var x:CGFloat = 0 ; x < self.size.width ; x += gridSize) {
            var gridHorizontalLine:SKShapeNode = SKShapeNode()
            var gridHorizontalLinePath:CGMutablePathRef = CGPathCreateMutable()
            CGPathMoveToPoint(gridHorizontalLinePath, nil, x, self.size.width)
            CGPathAddLineToPoint(gridHorizontalLinePath, nil, x, 0)
            gridHorizontalLine.path = gridHorizontalLinePath
            gridHorizontalLine.strokeColor = UIColor.lightGrayColor()
            gridHorizontalLine.zPosition = -10
            self.addChild(gridHorizontalLine)
        }
        
        self.menuBar = VerticalMenuBar(
            buttons: [buttonsDrawerButton, modulatorDrawerButton, self.playButton, self.backButton, self.saveButton, self.trashButton, self.aboutButton],
            position:CGPoint(x: x, y: y),
            size:CGSize(width: width, height: self.size.height),
            buttonSize:buttonSize
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
            if (touchedNode is RouletteSpin || touchedNode is SliderHandle || touchedNode is RouletteButton) {
                touchedNode = touchedNode.parent!
            }
            if (touchedNode is SoundObject) {
                self.selectedNodeOriginalPos = touchedNode.position
                touchedNode.zPosition = 1
            }
            touchMapping[uiTouch] = touchedNode
        }
    }
    
    func cancelMove(soundObj:SoundObject) {
        if (selectedNodeOriginalPos != nil) {
            soundObj.position = selectedNodeOriginalPos!
        }
        else {
            self.removeObj(soundObj)
        }
    }
    
    func removeObj(soundObj:SoundObject) {
        soundObj.removeFromParent()
        for i in 0...objects.count - 1 {
            let obj = objects[i]
            if (obj === soundObj) {
                objects.removeAtIndex(i)
                return
            }
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
                    soundObj.zPosition = 0
                    
                    if (self.trashButton.intersectsNode(soundObj))
                    {
                        self.removeObj(soundObj)
                    }
                    else {
                        if (!(self.menuBar!.intersectsNode(soundObj)))
                        {
                            for child in self.children {
                                if (child is SoundObject) {
                                    var soundChild = child as SoundObject
                                    if (soundChild !== soundObj && soundObj.intersectsNode(soundChild)) {
                                        cancelMove(soundObj)
                                        moveCancelled = true
                                        break;
                                    }
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
                    }
                    self.selectedNodeOriginalPos = nil
                }
                else if (boundNode is DrawerMenuButton) {
                    let drawer = boundNode as DrawerMenuButton
                    if (openDrawer != nil) {
                        openDrawer?.hideDrawer()
                    }
                    if (openDrawer !== drawer) {
                        drawer.showDrawer()
                        openDrawer = drawer
                    }
                    else {
                        openDrawer = nil
                    }
                }
                else if (boundNode === self.backButton) {
                    let navigationController = self.view!.window!.rootViewController!
                    if (navigationController is UINavigationController) {
                        (navigationController as UINavigationController).popViewControllerAnimated(true)
                    }
                }
                else if (boundNode === self.playButton) {
                    let navigationController = self.view!.window!.rootViewController!
                    if (navigationController is UINavigationController) {
                        let viewController = (navigationController as UINavigationController).topViewController
                        if (viewController is EditViewController) {
                            viewController.performSegueWithIdentifier("play", sender: navigationController)
                        }
                    }
                }

                touchMapping .removeValueForKey(uiTouch)
            }
        }
    }
    
    func containsObj(obj:SoundObject) -> Bool {
        return (obj.position.x >= obj.size.width / 2 &&
        obj.position.x <= self.size.width - obj.size.width / 2 &&
obj.position.y >= obj.size.height / 2 &&
obj.position.y <= self.size.height - obj.size.height / 2)
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
                    let oldPos = soundObj.position
                    soundObj.position.x = (touchLocation.x - touchLocation.x % gridSize) + soundObj.size.width / 2
                    soundObj.position.y = (touchLocation.y - touchLocation.y % gridSize) + soundObj.size.height / 2
                    if (!self.containsObj(soundObj)) {
                        soundObj.position = oldPos
                    }
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