//
//  SliderSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class SliderSoundObject : SoundObject, Touchable, Modulator
{
    override var gridHeight:CGFloat { get { return 3 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var imageName:String { get { return "slider.png" } }
    
    var sliderHandleImageName:String { get { return "sliderHandle.png" } }
    var sliderTrackImageName:String { get { return "sliderTrack.png" } }

    var sliderHandle:SliderHandle?
    var sliderHandleTexture:SKTexture?
    var sliderTrackTexture:SKTexture?
    
    let handlerWidthBorder:CGFloat = 5
    
    var volumeMixer:AVAudioMixerNode?
    var pitchMixer:AVAudioUnitTimePitch?
    var distortionMixer:AVAudioUnitDistortion?
    var reverbMixer:AVAudioUnitReverb?



    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        self.loadTextures()
        self.loadHandle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.texture = self.sliderTrackTexture
        self.loadHandle()
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
        self.texture = self.sliderTrackTexture
        //self.loadHandle()
    }
    
    override func startPhysicalBody() {
//        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:CGPoint(x:0,y:0), size:self.size))
//        self.physicsBody?.affectedByGravity = false
//        self.physicsBody?.categoryBitMask = 1
//        self.physicsBody?.contactTestBitMask = 1
//        self.physicsBody?.collisionBitMask = 1
//        self.physicsBody?.dynamic = false
//        self.physicsBody?.mass = 5000
//        self.physicsBody?.usesPreciseCollisionDetection = true
//        self.physicsBody?.restitution = 0
//
        for obj in self.children {
            let sliderObj:SliderHandle = obj as SliderHandle
//            sliderObj.physicsBody = SKPhysicsBody(rectangleOfSize: sliderObj.size,
//                center:CGPoint(x:sliderObj.size.width / 2 + handlerWidthBorder, y:sliderObj.size.height / 2))
//            sliderObj.physicsBody?.categoryBitMask = 1
//            sliderObj.physicsBody?.contactTestBitMask = 1
//            sliderObj.physicsBody?.collisionBitMask = 1
//            sliderObj.physicsBody?.dynamic = true
//            sliderObj.physicsBody?.mass = 1
//            sliderObj.physicsBody?.allowsRotation = false
//            sliderObj.physicsBody?.usesPreciseCollisionDetection = true
//            sliderObj.physicsBody?.friction = 0.9
//            sliderObj.physicsBody?.restitution = 0
//            sliderObj.physicsBody?.linearDamping = 0.9
            self.sliderHandle = sliderObj
       }
    }
        
    func loadHandle()
    {
        self.sliderHandle = nil
        self.removeAllChildren()
        if (self.sliderHandle == nil) {
            self.sliderHandle = SliderHandle(texture: self.sliderHandleTexture)
            self.sliderHandle!.anchorPoint = CGPoint(x: 0, y: 0)

            self.sliderHandle!.size.width = 0
            self.sliderHandle!.size.height = 0
            self.sliderHandle!.position.x = 0;
            self.sliderHandle!.position.y = 0;

            self.addChild(self.sliderHandle!);
        }
    }
    
    func loadTextures() {
        self.sliderHandleTexture = SKTexture(imageNamed: self.sliderHandleImageName);
        self.sliderTrackTexture = SKTexture(imageNamed: self.sliderTrackImageName);
    }
    
    override func updateGridSize(gridSize:CGFloat)
    {
        super.updateGridSize(gridSize)
        self.sliderHandle!.size.width = self.size.width - (self.handlerWidthBorder * 2)
        let ratio:CGFloat = self.sliderHandleTexture!.size().width / self.sliderHandle!.size.width
        self.sliderHandle!.size.height = self.sliderHandleTexture!.size().height / ratio
        self.sliderHandle!.position.x = self.handlerWidthBorder
        self.sliderHandle!.position.y = self.size.height / 2
    }

    override func currentSoundIntensity() -> Float
    {
        return self.sliderHandle!.currentSoundIntensity()
    }
    
    func startModulator() {
        self.startPitch()
        self.startVolume()
        self.startDistortion()
        self.startReverb()

    }
    
    func startPitch()
    {
        self.pitchMixer = AVAudioUnitTimePitch()
        self.pitchMixer!.pitch = 0 // In cents. The default value is 1.0. The range of values is -2400 to 2400
        self.pitchMixer!.rate = 2 //The default value is 1.0. The range of supported values is 1/32 to 32.0.
    }

    func startVolume()
    {
        self.volumeMixer = AVAudioMixerNode()
        self.volumeMixer!.outputVolume = 0.5
    }
    
    func startDistortion()
    {
        self.distortionMixer = AVAudioUnitDistortion()
        self.distortionMixer!.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)
        self.distortionMixer!.wetDryMix = 50
        self.distortionMixer!.preGain = 0
    }
    
    func startReverb()
    {
        self.reverbMixer = AVAudioUnitReverb()
        self.reverbMixer!.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        self.reverbMixer!.wetDryMix = 50
    }
    
    func touchStarted(position:CGPoint)
    {
    }
    
    func touchMoved(position:CGPoint)
    {
        self.sliderHandle!.touchMoved(position)
    }
    
    func touchEnded(position:CGPoint)
    {
    }
    
    func topModulator() -> AVAudioNode
    {
        return self.volumeMixer!
    }

    func bottomModulator() -> AVAudioNode
    {
        return self.pitchMixer!
    }
    
    func leftModulator() -> AVAudioNode
    {
        return self.distortionMixer!
    }
    
    func rightModulator() -> AVAudioNode
    {
        return self.reverbMixer!
    }
    
    func setModule(module:Float)
    {
        self.pitchMixer!.pitch = (module - 0.3) * 2800
        self.volumeMixer!.outputVolume = module
        //self.distortionMixer!.preGain = (module - 0.8) * 100
        self.distortionMixer!.wetDryMix = module * 100
        self.reverbMixer!.wetDryMix = module * 100
    }
}