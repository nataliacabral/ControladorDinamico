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
        }
//        
//        for obj in self.children
//        {
//            if (obj is Modulator) {
//                let sliderObj = obj as Modulator
//                for otherObj in self.children {
//                    if (otherObj is Sampler) {
//                        let buttonObj = otherObj as ButtonSoundObject
//                        SoundManager.sharedInstance.audioEngine.connect(buttonObj.audioSampler, to: sliderObj.modulator(), format: SoundManager.sharedInstance.audioEngine.mainMixerNode.outputFormatForBus(0))
//                        SoundManager.sharedInstance.audioEngine.connect(sliderObj.modulator(), to: SoundManager.sharedInstance.audioEngine.mainMixerNode, format: SoundManager.sharedInstance.audioEngine.mainMixerNode.outputFormatForBus(0))
//                    }
//                }
//            }
//        }
        
        let audioEngine:AVAudioEngine = SoundManager.sharedInstance.audioEngine
        
        // Start all modulators
        for obj in self.children
        {
            if (obj is Modulator)
            {
                let modulator:Modulator = obj as Modulator
                modulator.startModulator()
                // Attach modulator nodes
                audioEngine.attachNode(modulator.getPitchModulator())
                audioEngine.attachNode(modulator.getVolumeModulator())
            }
        }
        
        for obj in self.children
        {
            if (obj is Sampler)
            {
                let sampler:Sampler = obj as Sampler
                sampler.startSampler()
                // Attach sampler node
                audioEngine.attachNode(sampler.sampler())
                
                // Attach neighbor modulators
                let skNodeObj = obj as SKNode
                let leftObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x - self.gridSize, y:obj.position.y))
                let rightObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x + self.gridSize, y:obj.position.y))
                let topObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x, y:obj.position.y - self.gridSize))
                let bottomObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x, y:obj.position.y + self.gridSize))
                
                var modulatorCount = 0
                var parentNode:AVAudioNode = audioEngine.mainMixerNode
                
                if (leftObj is Modulator)
                {
                    let modulator = leftObj as Modulator
                    audioEngine.connect(modulator.getPitchModulator(), to:parentNode, format:audioEngine.mainMixerNode.outputFormatForBus(0))
                    parentNode = modulator.getPitchModulator()
                }
                if (rightObj is Modulator)
                {
                    let modulator = rightObj as Modulator
                    audioEngine.connect(modulator.getVolumeModulator(), to:parentNode, format:audioEngine.mainMixerNode.outputFormatForBus(0))
                    parentNode = modulator.getVolumeModulator()
                }
                    audioEngine.connect(sampler.sampler(), to:parentNode, format:audioEngine.mainMixerNode.outputFormatForBus(0))
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
            var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)

            if (touchBoundNode != nil) {
                touchBoundNode!.touchMoved(touchLocation)
            }
            
            if (touchedNode !== touchBoundNode) {
                if (touchBoundNode != nil) {
                    touchBoundNode!.touchEnded(touchLocation)
                    touchMapping.removeValueForKey(uiTouch)
                }
                if (touchedNode != nil && touchedNode is Touchable) {
                    let touchableObj = touchedNode as Touchable
                    touchMapping[uiTouch] = touchableObj
                    touchableObj.touchStarted(uiTouch.locationInView(uiTouch.view))
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
                let currentSoundIntensity : Float = soundObj.currentSoundIntensity()
                if (obj is SliderSoundObject) {
                    let sliderObj:SliderSoundObject = obj as SliderSoundObject
                    sliderObj.setModule(currentSoundIntensity) // In cents. The default value is 1.0. The range of values is -2400 to 2400
                    //sliderObj.auTimePitch!.rate = 2 //The default value is 1.0. The range of supported values is 1/32 to 32.0.
                }
                else if (obj is Sampler) {
                    let samplerObj:Sampler = obj as Sampler
                    if (currentSoundIntensity > 0) {
                        samplerObj.playSound()
                    }
                    else {
                        samplerObj.stopSound()
                    }
                }
            }
        }
    }
}
