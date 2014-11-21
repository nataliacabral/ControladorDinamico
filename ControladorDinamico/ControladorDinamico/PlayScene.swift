//
//  PlayScene.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class PlayScene : SKScene, SKPhysicsContactDelegate
{
    var gridSize:CGFloat
    var selectedNode:SKSpriteNode?
    var objects:Array<SoundObject> = Array<SoundObject>()
    var touchMapping = Dictionary<UITouch , Touchable>()
    
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
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.categoryBitMask = 1
        
        self.view?.multipleTouchEnabled = true
    }
    
    override func didMoveToView(view: SKView) {

        for obj in objects
        {
            var objCopy = obj.copy() as SoundObject
            self.addChild(objCopy)
            objCopy.startPhysicalBody()
            objCopy.startSoundEngine()
        }
        
        for obj in self.children
        {
            if (obj is SliderSoundObject) {
                let sliderObj = obj as SliderSoundObject
                for otherObj in self.children {
                    if (otherObj is ButtonSoundObject) {
                        let buttonObj = otherObj as ButtonSoundObject
                        SoundManager.sharedInstance.audioEngine.connect(buttonObj.playerNode, to: sliderObj.auTimePitch, format: SoundManager.sharedInstance.audioEngine.mainMixerNode.outputFormatForBus(0))
                        SoundManager.sharedInstance.audioEngine.connect(sliderObj.auTimePitch, to: SoundManager.sharedInstance.audioEngine.mainMixerNode, format: SoundManager.sharedInstance.audioEngine.mainMixerNode.outputFormatForBus(0))
                    }
                }
            }
        }
        SoundManager.sharedInstance.audioEngine.mainMixerNode.outputVolume = 1.0
        SoundManager.sharedInstance.startEngine()
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
            var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)
            
            if (touchedNode! is Touchable) {
                let touchableObj = touchedNode as Touchable
                touchMapping[uiTouch] = touchableObj
                touchableObj.touchStarted(uiTouch.locationInView(uiTouch.view))
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
       
        for touch in touches
        {
            let uiTouch = touch as UITouch
            let touchedNode:Touchable? = touchMapping[uiTouch]
            
            if (touchedNode != nil) {
                touchedNode!.touchEnded(uiTouch.locationInView(uiTouch.view))
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

            let touchBoundNode:Touchable? = touchMapping[uiTouch]
            
            if (touchBoundNode != nil) {
                touchBoundNode!.touchMoved(touchLocation)
                
                var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)
                if (touchedNode !== touchBoundNode) {
                    touchBoundNode!.touchEnded(touchLocation)
                    touchMapping.removeValueForKey(uiTouch)
                }
            }
        }
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        NSLog("Contact Begin Velocity: %f", contact.bodyA.velocity.dy)
    }
    func didEndContact(contact: SKPhysicsContact!) {
        NSLog("Contact End")
    }
    
    override func update(currentTime: NSTimeInterval)
    {
        for obj in self.children {
            if (obj is SoundObject) {
                let soundObj:SoundObject = obj as SoundObject
                let currentSoundIntensity : UInt32 = soundObj.currentSoundIntensity()
                if (obj is SliderSoundObject) {
                    let sliderObj:SliderSoundObject = obj as SliderSoundObject
                    sliderObj.auTimePitch!.pitch =  Float(currentSoundIntensity * 5) // In cents. The default value is 1.0. The range of values is -2400 to 2400
                    sliderObj.auTimePitch!.rate = 2 //The default value is 1.0. The range of supported values is 1/32 to 32.0.
                }
                else if (obj is ButtonSoundObject) {
                    let buttonObj:ButtonSoundObject = obj as ButtonSoundObject
                    if (currentSoundIntensity > 0) {
                        soundObj.playSound()
                    }
                    else {
                        soundObj.stopSound()
                    }
                }
            }
        }
    }
}
