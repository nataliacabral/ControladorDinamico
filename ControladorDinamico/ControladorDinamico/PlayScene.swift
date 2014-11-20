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
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.categoryBitMask = 1
    }
    
    override func didMoveToView(view: SKView) {
        var panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFromRecognizer:"))
        var tapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapFromRecognizer:"))
        var longPressRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleTouchFromRecognizer:"))
        longPressRecognizer.minimumPressDuration = 0.15
        longPressRecognizer.allowableMovement = 1

        self.view?.addGestureRecognizer(panRecognizer)
        self.view?.addGestureRecognizer(tapRecognizer)
        self.view?.addGestureRecognizer(longPressRecognizer)

        for obj in objects
        {
            let soundObj:SoundObject = obj as SoundObject
            var objCopy = soundObj.copy() as SoundObject
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
        
        SoundManager.sharedInstance.startEngine()
    }
    
    func handleTapFromRecognizer(recognizer:UITapGestureRecognizer) {
        var touchLocation:CGPoint = recognizer.locationInView(recognizer.view)
        touchLocation = self.convertPointFromView(touchLocation)
        var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)
        if (touchedNode != nil && touchedNode is Tappable) {
            var tappableNode = touchedNode as Tappable
            switch(recognizer.state) {
            case UIGestureRecognizerState.Ended:
                tappableNode.tapStarted()
                break;
            default:
                break;
            }
        }
    }
    
    func handleTouchFromRecognizer(recognizer:UILongPressGestureRecognizer) {
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
                    if (touchedNode is Pannable) {
                        self.selectedNode = touchedNode as SKSpriteNode?
                        let pannableObject:Pannable = selectedNode as Pannable;
                        //var convertedPoint = self.convertPoint(touchLocation, toNode:selectedNode!)
                        pannableObject.panStarted(touchLocation);
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
                    recognizer.setTranslation(CGPointZero, inView: recognizer.view)
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
