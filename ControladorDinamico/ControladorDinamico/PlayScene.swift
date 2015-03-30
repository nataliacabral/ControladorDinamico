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
    let bgColor:UIColor = UIColor(red: 34.0/255.0, green: 30.0/255.0, blue: 31.0/255.0, alpha: 1)
    var gridSize:CGFloat
    var selectedNode:SKSpriteNode?
    var objects:Array<SoundObject> = Array<SoundObject>()
    var cloneOjbects:Array<SoundObject> = Array<SoundObject>()
    var touchMapping = Dictionary<UITouch , Touchable>()
    
    var menuBar:VerticalMenuBar?
    var slot1Button:SavedStateMenuButton
    var slot2Button:SavedStateMenuButton
    var slot3Button:SavedStateMenuButton
    var slot4Button:SavedStateMenuButton
    var savedStates:Array<SavedStateMenuButton>
    var backButton:MenuButton
    var aboutButton:MenuButton
    var project:Project

    init(size: CGSize, project: Project)
    {
        self.project = project
        self.objects = project.objects
        self.gridSize = 128
        
        let barWidth:CGFloat = gridSize
        let buttonSize = CGSize(width: 96, height: 96)
        
        // MenuBar
        
        backButton = MenuButton(
            texture:SKTexture(imageNamed: "menubutton_edit.png.jpg"),
            color:UIColor(),
            size:buttonSize
        )
        
        slot1Button = SavedStateMenuButton(
            slot:0,
            size:buttonSize,
            objList:self.cloneOjbects
        )
        
        slot2Button = SavedStateMenuButton(
            slot:1,
            size:buttonSize,
            objList:self.cloneOjbects
        )
        
        slot3Button = SavedStateMenuButton(
            slot:2,
            size:buttonSize,
            objList:self.cloneOjbects
        )
        
        slot4Button = SavedStateMenuButton(
            slot:3,
            size:buttonSize,
            objList:self.cloneOjbects
        )
        
        aboutButton = MenuButton(
            texture:SKTexture(imageNamed: "menubutton_about.png"),
            color:UIColor(),
            size:buttonSize)
        
        savedStates = [slot1Button, slot2Button, slot3Button, slot4Button]

        super.init(size: size)
        self.scene?.backgroundColor = bgColor

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.categoryBitMask = 1
        
        self.view?.multipleTouchEnabled = true
        SavedStateManager.sharedInstance.stateButtons = self.savedStates
        SavedStateManager.sharedInstance.selectSlot(0)

        var x:CGFloat = self.size.width - barWidth / 2
        var y:CGFloat = (self.size.height / 2)
        
        let menuBarTexture:SKTexture = SKTexture(imageNamed: "menu_play_background.png")
        menuBar = VerticalMenuBar(
            buttons: [backButton, slot1Button, slot2Button, slot3Button, slot4Button, aboutButton],
            position:CGPoint(x: x, y: y),
            size:CGSize(width: barWidth, height: self.size.height),
            buttonSize:buttonSize, background:menuBarTexture, border:32
        )
        self.addChild(menuBar!)
    }
    
    override func didMoveToView(view: SKView) {

        for obj in objects
        {
            var playObject = obj.playObject()
            self.addChild(playObject)
            cloneOjbects.append(playObject)
            playObject.startPhysicalBody()
        }
        
        slot1Button.objList = self.cloneOjbects
        slot2Button.objList = self.cloneOjbects
        slot3Button.objList = self.cloneOjbects
        slot4Button.objList = self.cloneOjbects
        
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
                let leftObjs:Array = self.nodesAtPoint(CGPoint(x:obj.position.x - self.gridSize, y:obj.position.y))
                let rightObjs:Array = self.nodesAtPoint(CGPoint(x:obj.position.x + self.gridSize, y:obj.position.y))
                let topObjs:Array = self.nodesAtPoint(CGPoint(x:obj.position.x, y:obj.position.y + self.gridSize))
                let bottomObjs:Array = self.nodesAtPoint(CGPoint(x:obj.position.x, y:obj.position.y - self.gridSize))
                
                var modulatorCount = 0
                var parentNode:AVAudioNode = audioEngine.mainMixerNode
                
                for topObj in topObjs {
                    if (topObj is ModulatorNode)
                    {
                        let modulatorNode = topObj as ModulatorNode
                        let modulator:VolumeModulator = VolumeModulator()
                        modulatorNode.addModulator(modulator)
                        modulatedSampler.addModulator(modulator)
                        break;
                    }
                }
                for bottomObj in bottomObjs {
                    if (bottomObj is ModulatorNode)
                    {
                        let modulatorNode = bottomObj as ModulatorNode
                        let modulator:PitchMidiModulator = PitchMidiModulator()
                        modulatorNode.addModulator(modulator)
                        modulatedSampler.addModulator(modulator)
                        break;
                    }
                }
                for leftObj in leftObjs {
                    if (leftObj is ModulatorNode)
                    {
                        let modulatorNode = leftObj as ModulatorNode
                        let modulator:ReverbModulator = ReverbModulator()
                        modulatorNode.addModulator(modulator)
                        modulatedSampler.addModulator(modulator)
                        break;
                    }
                }
                for rightObj in rightObjs {
                    if (rightObj is ModulatorNode)
                    {
                        let modulatorNode = rightObj as ModulatorNode
                        let modulator:EQModulator = EQModulator()
                        modulatorNode.addModulator(modulator)
                        modulatedSampler.addModulator(modulator)
                        break;
                    }
                }
                modulatedSampler.startWithEngine(audioEngine)
            }
        }
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
            let touchBound:Touchable? = touchMapping[uiTouch]
            var touchLocation:CGPoint = uiTouch.locationInView(uiTouch.view)
            touchLocation = self.convertPointFromView(touchLocation)
            var touchedNode:SKNode? = self.nodeAtPoint(touchLocation)
            
            if (touchBound != nil) {
                touchBound!.touchEnded(touchLocation)
                touchMapping .removeValueForKey(uiTouch)
            }
            if (touchedNode == self.backButton) {
                let audioEngine:AVAudioEngine = SoundManager.sharedInstance.audioEngine
                audioEngine.stop()
                project.objects = self.cloneOjbects
                ProjectManager.sharedInstance.saveProject(project)
                let navigationController = self.view!.window!.rootViewController!
                if (navigationController is UINavigationController) {
                    (navigationController as UINavigationController).popViewControllerAnimated(true)
                }
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
                    touchBoundNode!.touchCancelled(touchLocation)
                    touchMapping.removeValueForKey(uiTouch)
                }
                if (touchedNode != nil && touchedNode is Touchable) {
                    let touchableObj = touchedNode as Touchable
                    touchMapping[uiTouch] = touchableObj
                    touchableObj.touchStarted(touchLocation)
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
        for state in self.savedStates {
            state.update(currentTime)
        }
    }
}
