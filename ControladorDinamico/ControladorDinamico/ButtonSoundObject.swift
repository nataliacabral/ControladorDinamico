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

class ButtonSoundObject : SoundObject, Touchable, Sampler
{
    override var gridHeight:CGFloat { get { return 1 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var imageName:String { get { return "button.png" } }
    
    let selectedTextureName:String = "buttonSelected.png"
    var selectedTexture:SKTexture?
    var stillTexture:SKTexture?

    var pressed : Bool
    var playing : Bool = false
    var note : UInt8 = 0
    
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
    }
    
    override init(gridSize:CGFloat) {
        self.pressed = false
        super.init(gridSize:gridSize)
    }
    
    func touchStarted(position:CGPoint)
    {
        let changeTexture:SKAction = SKAction.setTexture(self.selectedTexture!)
        self.pressed = true
        self.runAction(changeTexture)
    }
    
    func touchEnded(position:CGPoint)
    {
        let changeTexture:SKAction = SKAction.setTexture(self.stillTexture!)
        self.pressed = false
        self.runAction(changeTexture)
    }
    
    func touchMoved(position:CGPoint)
    {
        
    }
    
    func loadTextures() {
        self.selectedTexture = SKTexture(imageNamed: self.selectedTextureName);
        self.stillTexture = SKTexture(imageNamed: self.imageName);
    }
    
    override func currentSoundIntensity() -> Float
    {
        if (self.pressed) {
            return 1.0
        } else {
            return 0
        }
    }
    
    func startSampler(note:UInt8) {
//        self.playerNode =  AVAudioPlayerNode()
//        let path = NSBundle.mainBundle().pathForResource(String("bass"), ofType:"wav")
//        let fileURL = NSURL(fileURLWithPath: path!)
//        self.audioFile = AVAudioFile(forReading:fileURL, error: nil);
//        SoundManager.sharedInstance.audioEngine.attachNode(self.playerNode)
        
        let path = NSBundle.mainBundle().pathForResource(String("piano"), ofType:"sf2")
        self.note = note
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
}