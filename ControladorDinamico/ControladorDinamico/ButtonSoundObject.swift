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

class ButtonSoundObject : SoundObject, Sampler
//class ButtonSoundObject
{
    override var gridHeight:CGFloat { get { return 1 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var templateImageName:String { get { return "button.png" } }
    
    let selectedTextureName:String = "buttonSelected.png"
    var selectedTexture:SKTexture?
    var stillTexture:SKTexture?

    var pressed : Bool
    var playing : Bool = false
    var note : UInt8 = 0
    
    
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
        self.pressed = false
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        self.pressed = false
        super.init(texture: texture, color: color, size: size)
        self.loadTextures();
    }
    
    required init(coder aDecoder: NSCoder) {
        self.pressed = false
        super.init(coder:aDecoder)
        self.note = (aDecoder.decodeObjectForKey("note") as NSNumber).unsignedCharValue
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(NSNumber(unsignedChar:self.note), forKey: "note")
    }
    
    init(gridSize:CGFloat, note:UInt8) {
        self.pressed = false
        super.init(gridSize:gridSize)
        self.note = note
        let colorMap:Array<UIColor> = ButtonSoundObject.colorMap()
        self.color = colorMap[Int(note) % 12]
        self.colorBlendFactor = 1.0
    }
    
    override func touchStarted(position:CGPoint)
    {
        let changeTexture:SKAction = SKAction.setTexture(self.selectedTexture!)
        self.pressed = true
        self.runAction(changeTexture)
    }
    
    override func touchEnded(position:CGPoint)
    {
        let changeTexture:SKAction = SKAction.setTexture(self.stillTexture!)
        self.pressed = false
        self.runAction(changeTexture)
    }
    
    override func touchMoved(position:CGPoint)
    {
        
    }
    
    func loadTextures() {
        self.selectedTexture = SKTexture(imageNamed: self.selectedTextureName);
        self.stillTexture = SKTexture(imageNamed: self.templateImageName);
    }
    
    override func currentSoundIntensity() -> Float
    {
        if (self.pressed) {
            return 1.0
        } else {
            return 0
        }
    }
    
    func getNote() -> UInt8 {
        return self.note
    }
    
    func startSampler() {
        let path = NSBundle.mainBundle().pathForResource(String("piano"), ofType:"sf2")
        self.audioSampler = AVAudioUnitSampler()
    }
    
    func sampler() -> AVAudioUnitSampler
    {
        return self.audioSampler!
    }
    
    func playSound()
    {
        //self.playerNode?.scheduleFile(self.audioFile, atTime: nil, completionHandler: nil)
        //self.playerNode?.play()
        if (!playing) {
            self.audioSampler?.startNote(self.note, withVelocity: 127, onChannel: 0)
            self.playing = true
        }
    }
    
    func stopSound()
    {
        //        self.playerNode?.stop()
        if (self.playing) {
            self.audioSampler?.stopNote(self.note,  onChannel: 0)
            self.playing = false
        }
    }
    
    override func copy() -> AnyObject
    {
        var result:ButtonSoundObject = ButtonSoundObject(
            texture:self.texture,
            color:self.color,
            size:self.size
        )
        result.color = self.color
        result.colorBlendFactor = 1.0
        result.pressed = self.pressed
        result.note = self.note
        result.playing = self.playing
        result.stillTexture = self.stillTexture
        result.selectedTexture = self.selectedTexture
        result.position = self.position
        return result
    }
}