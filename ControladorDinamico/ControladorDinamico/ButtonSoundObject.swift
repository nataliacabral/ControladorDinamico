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

class ButtonSoundObject : SoundObject, Touchable
{
    override var gridHeight:CGFloat { get { return 1 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var imageName:String { get { return "button.png" } }
    
    let selectedTextureName:String = "buttonSelected.png"
    var selectedTexture:SKTexture?
    var stillTexture:SKTexture?

    var pressed : Bool

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
    
    override func currentSoundIntensity() -> UInt32
    {
        if (self.pressed) {
            return 100
        } else {
            return self.minSoundIntensity
        }
    }
    
    override func startSoundEngine() {
        self.playerNode =  AVAudioPlayerNode()
        let path = NSBundle.mainBundle().pathForResource(String("bass"), ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        self.audioFile = AVAudioFile(forReading:fileURL, error: nil);
        SoundManager.sharedInstance.audioEngine.attachNode(self.playerNode)
    }

}