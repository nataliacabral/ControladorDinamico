//
//  ButtonSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

struct ButtonStatus
{
    var pressed : Bool
    var playing : Bool
}

class ButtonSoundObject : SoundObject, Sampler
//class ButtonSoundObject
{
    override var gridHeight:CGFloat { get { return 1 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var templateImageName:String { get { return "button.png" } }
    
    let selectedTexture:SKTexture = SKTexture(imageNamed: "buttonSelected.png")
    let stillTexture:SKTexture =  SKTexture(imageNamed: "button.png")

    var note : UInt8 = 0
    
    var status : ButtonStatus = ButtonStatus(pressed: false, playing: false)
    var savedStatus : Array<ButtonStatus> = Array<ButtonStatus>(count: 4, repeatedValue: ButtonStatus(pressed: false, playing: false))
    
    class func colorMap() -> Array<UIColor> {
        return [
            UIColor(red:CGFloat(255.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(255.0 / 255.0), green: CGFloat(140.0 / 255.0), blue: CGFloat(140.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(255.0 / 255.0), green: CGFloat(135.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(255.0 / 255.0), green: CGFloat(215.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(255.0 / 255.0), green: CGFloat(255.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(30.0 / 255.0), green: CGFloat(175.0 / 255.0), blue: CGFloat(70.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(65.0 / 255.0), green: CGFloat(118.0 / 255.0), blue: CGFloat(242.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(29.0 / 255.0), green: CGFloat(94.0 / 255.0), blue: CGFloat(242.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(127.0 / 255.0), green: CGFloat(163.0 / 255.0), blue: CGFloat(242.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(143.0 / 255.0), green: CGFloat(50.0 / 255.0), blue: CGFloat(237.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(192.0 / 255.0), green: CGFloat(150.0 / 255.0), blue: CGFloat(235.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(205.0 / 255.0), green: CGFloat(77.0 / 255.0), blue: CGFloat(247.0 / 255.0), alpha: CGFloat(1.0)),
            UIColor(red:CGFloat(220.0 / 255.0), green: CGFloat(155.0 / 255.0), blue: CGFloat(242.0 / 255.0), alpha: CGFloat(1.0)),
        ]
    }
    
    var audioSampler:AVAudioUnitSampler?

    override init()
    {
        self.note = 1;
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }

    func colorize()
    {
        self.color = ButtonSoundObject.colorMap()[Int(self.note) % 12]
        self.colorBlendFactor = 1.0
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.note = (aDecoder.decodeObjectForKey("note") as NSNumber).unsignedCharValue
        self.colorize()
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(NSNumber(unsignedChar:self.note), forKey: "note")
    }
    
    init(gridSize:CGFloat, note:UInt8) {
        super.init(gridSize:gridSize)
        self.note = note
        self.colorize()
    }
    
    override func touchStarted(position:CGPoint)
    {
        let changeTexture:SKAction = SKAction.setTexture(self.selectedTexture)
        self.status.pressed = true
        self.runAction(changeTexture)
    }
    
    override func touchEnded(position:CGPoint)
    {
        let changeTexture:SKAction = SKAction.setTexture(self.stillTexture)
        self.status.pressed = false
        self.runAction(changeTexture)
    }
    
    override func touchMoved(position:CGPoint)
    {
        
    }
    
    override func currentSoundIntensity() -> Float
    {
        if (self.status.pressed) {
            return 1.0
        } else {
            return 0
        }
    }
    
    func getNote() -> UInt8 {
        return self.note
    }
    
    func startSampler() {
        var error:NSError?
        self.audioSampler = AVAudioUnitSampler()
        let path = NSBundle.mainBundle().URLForResource(String("guitar"), withExtension:"sf2")
        self.audioSampler?.loadSoundBankInstrumentAtURL(path, program: 1, bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB), bankLSB: UInt8(kAUSampler_DefaultBankLSB), error: &error)
    }
    
    func sampler() -> AVAudioUnitSampler
    {
        return self.audioSampler!
    }
    
    func playSound()
    {
        if (!self.status.playing) {
            self.audioSampler?.startNote(self.note, withVelocity: 127, onChannel: 0)
            self.status.playing = true
        }
    }
    
    func stopSound()
    {
        if (self.status.playing) {
            self.audioSampler?.stopNote(self.note,  onChannel: 0)
            self.status.playing = false
        }
    }
    
    override func playObject() -> SoundObject
    {
        var result:ButtonSoundObject = ButtonSoundObject(
            texture:self.texture,
            color:self.color,
            size:self.size
        )
        result.colorBlendFactor = 1.0
        result.note = self.note
        result.position = self.position
        return result
    }
    
    override func saveStatus(slot:Int)
    {
        self.savedStatus[slot] = self.status;
    }
    override func loadStatus(slot:Int)
    {
        self.status = self.savedStatus[slot];
    }
    
    override func copy() -> AnyObject {
        var result:ButtonSoundObject = super.copy() as ButtonSoundObject
        result.note = self.note
        return result
    }
    
}