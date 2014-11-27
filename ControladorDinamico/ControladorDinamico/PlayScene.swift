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
        self.gridSize = 64
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
            var playObject = obj.playObject()
            self.addChild(playObject)
            playObject.startPhysicalBody()
        }
        
        let audioEngine:AVAudioEngine = SoundManager.sharedInstance.audioEngine
 
        for obj in self.children
        {
            if (obj is Sampler)
            {
                let sampler:Sampler = obj as Sampler
                var modulatedSampler = ModulatedSampler(sampler: sampler)

                sampler.startSampler()
                // Attach sampler node
                audioEngine.attachNode(sampler.sampler())
                
                // Attach neighbor modulators
                let skNodeObj = obj as SKNode
                let leftObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x - self.gridSize, y:obj.position.y))
                let rightObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x + self.gridSize, y:obj.position.y))
                let topObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x, y:obj.position.y + self.gridSize))
                let bottomObj:SKNode? = self.nodeAtPoint(CGPoint(x:obj.position.x, y:obj.position.y - self.gridSize))
                
                var modulatorCount = 0
                var parentNode:AVAudioNode = audioEngine.mainMixerNode
                
                if (topObj is ModulatorNode)
                {
                    let modulatorNode = topObj as ModulatorNode
                    let modulator:VolumeModulator = VolumeModulator()
                    modulatorNode.addModulator(modulator)
                    modulatedSampler.addModulator(modulator)
                }
                if (bottomObj is ModulatorNode)
                {
                    let modulatorNode = bottomObj as ModulatorNode
                    let modulator:PitchModulator = PitchModulator()
                    modulatorNode.addModulator(modulator)
                    modulatedSampler.addModulator(modulator)
                }
                if (leftObj is ModulatorNode)
                {
                    let modulatorNode = leftObj as ModulatorNode
                    let modulator:DistortionModulator = DistortionModulator()
                    modulatorNode.addModulator(modulator)
                    modulatedSampler.addModulator(modulator)
                }
                if (rightObj is ModulatorNode)
                {
                    let modulatorNode = rightObj as ModulatorNode
                    let modulator:ReverbModulator = ReverbModulator()
                    modulatorNode.addModulator(modulator)
                    modulatedSampler.addModulator(modulator)
                }
                modulatedSampler.startWithEngine(audioEngine)
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
                touchableObj.touchStarted(touchLocation)
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
                soundObj.update(currentTime)
                let currentSoundIntensity : Float = soundObj.currentSoundIntensity()
                if (obj is ModulatorNode) {
                    let modulator:ModulatorNode = obj as ModulatorNode
                    modulator.setModule(currentSoundIntensity)
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
